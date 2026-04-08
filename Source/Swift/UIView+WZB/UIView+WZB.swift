import ObjectiveC
import UIKit

private func wzbDefaultTextColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return .secondaryLabel
    }
    return .gray
}

private func wzbDefaultSeparatorColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return .separator
    }
    return UIColor(white: 0.82, alpha: 1)
}

@objc public enum WZBLineType: Int {
    case vertical
    case horizontal
}

private final class WZBGridStorage: NSObject {
    var labels: [UILabel] = []
    var lineLayers: [CAShapeLayer] = []
}

private final class WZBScrollableGridStorage: NSObject {
    weak var containerView: UIView?
}

private enum WZBAssociatedKeys {
    static var gridStorage: UInt8 = 0
    static var scrollableGridStorage: UInt8 = 0
}

private extension UIView {
    var wzb_gridStorage: WZBGridStorage {
        if let storage = objc_getAssociatedObject(self, &WZBAssociatedKeys.gridStorage) as? WZBGridStorage {
            return storage
        }

        let storage = WZBGridStorage()
        objc_setAssociatedObject(
            self,
            &WZBAssociatedKeys.gridStorage,
            storage,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return storage
    }

    var wzb_hairlineWidth: CGFloat {
        1 / UIScreen.main.scale
    }

    func wzb_clearGridArtifacts() {
        wzb_gridStorage.labels.forEach { $0.removeFromSuperview() }
        wzb_gridStorage.lineLayers.forEach { $0.removeFromSuperlayer() }
        wzb_gridStorage.labels.removeAll()
        wzb_gridStorage.lineLayers.removeAll()
    }

    func wzb_resolvedColumns(
        defaultColumns: Int,
        row: Int,
        columnsInfo: [Int: Int]?
    ) -> Int {
        max(columnsInfo?[row] ?? defaultColumns, 1)
    }

    func wzb_resolvedRowHeights(rows: Int, rowHeights: [CGFloat]?, totalHeight: CGFloat) -> [CGFloat] {
        guard let rowHeights, rowHeights.count == rows else {
            return Array(repeating: totalHeight / CGFloat(rows), count: rows)
        }

        let sanitizedHeights = rowHeights.map { max($0, 1) }
        let total = sanitizedHeights.reduce(0, +)
        guard total > 0 else {
            return Array(repeating: totalHeight / CGFloat(rows), count: rows)
        }

        return sanitizedHeights.map { totalHeight * ($0 / total) }
    }

    func wzb_resolvedColumnWidths(
        defaultColumns: Int,
        row: Int,
        columnsInfo: [Int: Int]?,
        columnWidthInfo: [Int: [CGFloat]]?,
        totalWidth: CGFloat
    ) -> [CGFloat] {
        let currentColumns = wzb_resolvedColumns(defaultColumns: defaultColumns, row: row, columnsInfo: columnsInfo)

        guard
            let widthWeights = columnWidthInfo?[row],
            widthWeights.count == currentColumns
        else {
            return Array(repeating: totalWidth / CGFloat(currentColumns), count: currentColumns)
        }

        let sanitizedWeights = widthWeights.map { max($0, 1) }
        let total = sanitizedWeights.reduce(0, +)
        guard total > 0 else {
            return Array(repeating: totalWidth / CGFloat(currentColumns), count: currentColumns)
        }

        return sanitizedWeights.map { totalWidth * ($0 / total) }
    }

    func wzb_makeLabel(frame: CGRect, text: Any?, textColor: UIColor, backgroundColor: UIColor) -> UILabel {
        let label = UILabel(frame: frame.integral)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = .systemFont(ofSize: 13)
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.text = text.map { String(describing: $0) } ?? ""
        return label
    }

    func wzb_storeLabel(_ label: UILabel) {
        wzb_gridStorage.labels.append(label)
        addSubview(label)
    }

    func wzb_storeLineLayer(_ layer: CAShapeLayer) {
        wzb_gridStorage.lineLayers.append(layer)
        self.layer.addSublayer(layer)
    }

    func wzb_drawList(
        with rect: CGRect,
        defaultColumns: Int,
        rows: Int,
        datas: [Any],
        colorInfo: [Int: UIColor]?,
        columnsInfo: [Int: Int]?,
        columnWidthInfo: [Int: [CGFloat]]?,
        rowHeights: [CGFloat]?,
        backgroundColorInfo: [Int: UIColor]?
    ) {
        guard defaultColumns > 0, rows > 0, rect.width > 0, rect.height > 0 else { return }

        wzb_clearGridArtifacts()

        let resolvedRowHeights = wzb_resolvedRowHeights(rows: rows, rowHeights: rowHeights, totalHeight: rect.height)
        var dataIndex = 0
        var currentY = rect.minY

        for row in 0 ..< rows {
            let currentRowHeight = resolvedRowHeights[row]
            let columnWidths = wzb_resolvedColumnWidths(
                defaultColumns: defaultColumns,
                row: row,
                columnsInfo: columnsInfo,
                columnWidthInfo: columnWidthInfo,
                totalWidth: rect.width
            )

            var currentX = rect.minX
            for columnWidth in columnWidths {
                let cellFrame = CGRect(
                    x: currentX,
                    y: currentY,
                    width: columnWidth,
                    height: currentRowHeight
                )

                wzb_drawGridBorder(for: cellFrame)

                let label = wzb_makeLabel(
                    frame: cellFrame,
                    text: dataIndex < datas.count ? datas[dataIndex] : nil,
                    textColor: colorInfo?[dataIndex] ?? wzbDefaultTextColor(),
                    backgroundColor: backgroundColorInfo?[dataIndex] ?? .clear
                )

                wzb_storeLabel(label)
                dataIndex += 1
                currentX += columnWidth
            }

            currentY += currentRowHeight
        }
    }
}

public extension UIView {
    @objc(wzb_drawListWithRect:columns:rows:datas:)
    func wzb_drawList(with rect: CGRect, columns: Int, rows: Int, datas: [Any]) {
        wzb_drawList(with: rect, columns: columns, rows: rows, datas: datas, colorInfo: nil)
    }

    @objc(wzb_drawListWithRect:columns:rows:datas:columnsInfo:)
    func wzb_drawList(
        with rect: CGRect,
        columns: Int,
        rows: Int,
        datas: [Any],
        columnsInfo: [Int: Int]?
    ) {
        wzb_drawList(with: rect, columns: columns, rows: rows, datas: datas, colorInfo: nil, columnsInfo: columnsInfo)
    }

    @objc(wzb_drawListWithRect:columns:rows:datas:colorInfo:)
    func wzb_drawList(
        with rect: CGRect,
        columns: Int,
        rows: Int,
        datas: [Any],
        colorInfo: [Int: UIColor]?
    ) {
        wzb_drawList(with: rect, columns: columns, rows: rows, datas: datas, colorInfo: colorInfo, columnsInfo: nil)
    }

    @objc(wzb_drawListWithRect:columns:rows:datas:colorInfo:columnsInfo:)
    func wzb_drawList(
        with rect: CGRect,
        columns: Int,
        rows: Int,
        datas: [Any],
        colorInfo: [Int: UIColor]?,
        columnsInfo: [Int: Int]?
    ) {
        wzb_drawList(
            with: rect,
            columns: columns,
            rows: rows,
            datas: datas,
            colorInfo: colorInfo,
            columnsInfo: columnsInfo,
            backgroundColorInfo: nil
        )
    }

    @objc(wzb_drawListWithRect:columns:rows:datas:colorInfo:columnsInfo:backgroundColorInfo:)
    func wzb_drawList(
        with rect: CGRect,
        columns: Int,
        rows: Int,
        datas: [Any],
        colorInfo: [Int: UIColor]?,
        columnsInfo: [Int: Int]?,
        backgroundColorInfo: [Int: UIColor]?
    ) {
        wzb_drawList(
            with: rect,
            defaultColumns: columns,
            rows: rows,
            datas: datas,
            colorInfo: colorInfo,
            columnsInfo: columnsInfo,
            columnWidthInfo: nil,
            rowHeights: nil,
            backgroundColorInfo: backgroundColorInfo
        )
    }

    func wzb_drawList(
        with rect: CGRect,
        defaultColumns: Int,
        rowHeights: [CGFloat],
        datas: [Any],
        colorInfo: [Int: UIColor]? = nil,
        columnsInfo: [Int: Int]? = nil,
        columnWidthInfo: [Int: [CGFloat]]? = nil,
        backgroundColorInfo: [Int: UIColor]? = nil
    ) {
        wzb_drawList(
            with: rect,
            defaultColumns: defaultColumns,
            rows: rowHeights.count,
            datas: datas,
            colorInfo: colorInfo,
            columnsInfo: columnsInfo,
            columnWidthInfo: columnWidthInfo,
            rowHeights: rowHeights,
            backgroundColorInfo: backgroundColorInfo
        )
    }

    @objc(getLabelWithIndex:)
    func getLabel(withIndex index: Int) -> UILabel? {
        guard index >= 0, index < wzb_gridStorage.labels.count else { return nil }
        return wzb_gridStorage.labels[index]
    }

    @objc(wzb_drawLineWithFrame:lineType:color:lineWidth:)
    func wzb_drawLine(
        with frame: CGRect,
        lineType: WZBLineType,
        color: UIColor,
        lineWidth: CGFloat
    ) {
        guard frame.width > 0 || frame.height > 0 else { return }

        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: .zero)
        switch lineType {
        case .horizontal:
            path.addLine(to: CGPoint(x: frame.width, y: 0))
        case .vertical:
            path.addLine(to: CGPoint(x: 0, y: frame.height))
        }

        let lineLayer = CAShapeLayer()
        lineLayer.frame = frame
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = lineWidth
        lineLayer.strokeColor = color.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        wzb_storeLineLayer(lineLayer)
    }

    func wzb_removeGrid() {
        wzb_clearGridArtifacts()
    }
}

public extension UIScrollView {
    @discardableResult
    func wzb_drawScrollableList(
        origin: CGPoint = .zero,
        cellSize: CGSize,
        columns: Int,
        rows: Int,
        datas: [Any],
        colorInfo: [Int: UIColor]? = nil,
        columnsInfo: [Int: Int]? = nil,
        backgroundColorInfo: [Int: UIColor]? = nil
    ) -> UIView {
        let storage: WZBScrollableGridStorage
        if let existing = objc_getAssociatedObject(self, &WZBAssociatedKeys.scrollableGridStorage) as? WZBScrollableGridStorage {
            storage = existing
        } else {
            storage = WZBScrollableGridStorage()
            objc_setAssociatedObject(
                self,
                &WZBAssociatedKeys.scrollableGridStorage,
                storage,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }

        storage.containerView?.removeFromSuperview()

        let resolvedColumnsInfo = columnsInfo ?? [:]
        let contentWidth = (0 ..< rows)
            .map { max(resolvedColumnsInfo[$0] ?? columns, 1) }
            .map { CGFloat($0) * cellSize.width }
            .max() ?? cellSize.width
        let contentHeight = CGFloat(rows) * cellSize.height

        let containerView = UIView(frame: CGRect(
            x: origin.x,
            y: origin.y,
            width: contentWidth,
            height: contentHeight
        ))
        addSubview(containerView)

        containerView.wzb_drawList(
            with: containerView.bounds,
            columns: columns,
            rows: rows,
            datas: datas,
            colorInfo: colorInfo,
            columnsInfo: columnsInfo,
            backgroundColorInfo: backgroundColorInfo
        )

        storage.containerView = containerView
        contentSize = CGSize(
            width: max(bounds.width, origin.x + contentWidth),
            height: max(bounds.height, origin.y + contentHeight)
        )
        return containerView
    }
}

private extension UIView {
    func wzb_drawGridBorder(for rect: CGRect) {
        let x = rect.minX
        let y = rect.minY
        let width = rect.width
        let height = rect.height
        let lineWidth = wzb_hairlineWidth

        wzb_drawLine(
            with: CGRect(x: x, y: y, width: width, height: lineWidth),
            lineType: .horizontal,
            color: wzbDefaultSeparatorColor(),
            lineWidth: lineWidth
        )
        wzb_drawLine(
            with: CGRect(x: x + width - lineWidth, y: y, width: lineWidth, height: height),
            lineType: .vertical,
            color: wzbDefaultSeparatorColor(),
            lineWidth: lineWidth
        )
        wzb_drawLine(
            with: CGRect(x: x, y: y + height - lineWidth, width: width, height: lineWidth),
            lineType: .horizontal,
            color: wzbDefaultSeparatorColor(),
            lineWidth: lineWidth
        )
        wzb_drawLine(
            with: CGRect(x: x, y: y, width: lineWidth, height: height),
            lineType: .vertical,
            color: wzbDefaultSeparatorColor(),
            lineWidth: lineWidth
        )
    }
}
