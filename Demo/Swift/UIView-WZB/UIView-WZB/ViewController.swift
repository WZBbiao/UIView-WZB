import UIKit

private func demoSecondaryTextColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return .secondaryLabel
    }
    return .darkGray
}

private func demoCardBackgroundColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return .secondarySystemBackground
    }
    return UIColor(white: 0.95, alpha: 1)
}

private func demoHeaderBackgroundColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor.systemIndigo.withAlphaComponent(0.12)
    }
    return UIColor.purple.withAlphaComponent(0.12)
}

private func demoPrimaryTextColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return .label
    }
    return .black
}

final class ViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIView-WZB"
        view.backgroundColor = .systemBackground
        configureLayout()
        buildDemoSections()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 24

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func buildDemoSections() {
        contentStack.addArrangedSubview(makeIntroLabel())
        contentStack.addArrangedSubview(makeSectionTitle("Basic Table"))
        contentStack.addArrangedSubview(makeBasicTableDemo())
        contentStack.addArrangedSubview(makeSectionTitle("Merged Rows and Interaction"))
        contentStack.addArrangedSubview(makeMergedTableDemo())
        contentStack.addArrangedSubview(makeSectionTitle("Decorative Lines"))
        contentStack.addArrangedSubview(makeLinesDemo())
    }

    private func makeIntroLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = demoSecondaryTextColor()
        label.text = "Swift rewrite of UIView-WZB. Each block below is drawn with the UIView extension API."
        return label
    }

    private func makeSectionTitle(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = title
        return label
    }

    private func makeCard(height: CGFloat) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = demoCardBackgroundColor()
        card.layer.cornerRadius = 20
        if #available(iOS 13.0, *) {
            card.layer.cornerCurve = .continuous
        }
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: height)
        ])
        return card
    }

    private func makeBasicTableDemo() -> UIView {
        let card = makeCard(height: 180)
        let tableView = UIView(frame: CGRect(x: 16, y: 16, width: view.bounds.width - 64, height: 148))
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        card.addSubview(tableView)

        tableView.wzb_drawList(
            with: tableView.bounds,
            columns: 4,
            rows: 4,
            datas: [
                "", "Chinese", "Math", "English",
                "Wang Xiaoming", "100.5", "128", "95",
                "Li Xiaohua", "96.0", "105", "89",
                "Zhang Aiqi", "88.0", "118", "93"
            ],
            colorInfo: [
                1: .systemRed,
                2: .systemBlue,
                3: .systemGreen
            ]
        )

        return card
    }

    private func makeMergedTableDemo() -> UIView {
        let card = makeCard(height: 240)
        let tableView = UIView(frame: CGRect(x: 16, y: 16, width: view.bounds.width - 64, height: 208))
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        card.addSubview(tableView)

        tableView.wzb_drawList(
            with: tableView.bounds,
            columns: 3,
            rows: 5,
            datas: [
                "Regional Sales in December",
                "Guangdong", "4685.36", "Open",
                "Henan", "6894.09", "Open",
                "Northeast", "10452.78", "Open",
                "Shanghai", "12882.78", "Open"
            ],
            colorInfo: [
                3: .systemBlue,
                6: .systemBlue,
                9: .systemBlue,
                12: .systemBlue
            ],
            columnsInfo: [
                0: 1
            ],
            backgroundColorInfo: [
                0: demoHeaderBackgroundColor()
            ]
        )

        if let header = tableView.getLabel(withIndex: 0) {
            header.font = .systemFont(ofSize: 15, weight: .semibold)
            header.textColor = demoPrimaryTextColor()
        }

        for index in stride(from: 3, through: 12, by: 3) {
            guard let label = tableView.getLabel(withIndex: index) else { continue }
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetail)))
        }

        return card
    }

    private func makeLinesDemo() -> UIView {
        let card = makeCard(height: 160)
        let lineCanvas = UIView(frame: CGRect(x: 16, y: 20, width: view.bounds.width - 64, height: 120))
        lineCanvas.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        card.addSubview(lineCanvas)

        let lineCount = 16
        let spacing = lineCanvas.bounds.width / CGFloat(lineCount)
        for index in 0 ..< lineCount {
            lineCanvas.wzb_drawLine(
                with: CGRect(
                    x: CGFloat(index) * spacing,
                    y: 0,
                    width: 1,
                    height: lineCanvas.bounds.height
                ),
                lineType: .vertical,
                color: randomColor(),
                lineWidth: 3
            )
        }

        return card
    }

    @objc private func showDetail() {
        let alert = UIAlertController(
            title: "UIView-WZB",
            message: "Cell tap interaction is available through getLabel(withIndex:).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func randomColor() -> UIColor {
        UIColor(
            red: CGFloat.random(in: 0.15 ... 1),
            green: CGFloat.random(in: 0.15 ... 1),
            blue: CGFloat.random(in: 0.15 ... 1),
            alpha: 1
        )
    }
}
