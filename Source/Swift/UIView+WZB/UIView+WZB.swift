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

private enum WZBAssociatedKeys {
    static var gridStorage: UInt8 = 0
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
        guard columns > 0, rows > 0, rect.width > 0, rect.height > 0 else { return }

        wzb_clearGridArtifacts()

        let rowHeight = rect.height / CGFloat(rows)
        var dataIndex = 0

        for row in 0 ..< rows {
            let currentColumns = wzb_resolvedColumns(defaultColumns: columns, row: row, columnsInfo: columnsInfo)
            let columnWidth = rect.width / CGFloat(currentColumns)

            for column in 0 ..< currentColumns {
                let cellFrame = CGRect(
                    x: rect.minX + CGFloat(column) * columnWidth,
                    y: rect.minY + CGFloat(row) * rowHeight,
                    width: columnWidth,
                    height: rowHeight
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
            }
        }
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
