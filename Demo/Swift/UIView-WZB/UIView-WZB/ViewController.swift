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

private enum DemoAccessibilityID {
    static let pushDetailButton = "push_detail_button"
    static let pushFormsButton = "push_forms_button"
    static let showSheetButton = "show_sheet_button"
    static let presentFullScreenButton = "present_fullscreen_button"
    static let dismissModalButton = "dismiss_modal_button"
    static let formsTextField = "forms_text_field"
    static let formsSwitch = "forms_switch"
    static let formsSegment = "forms_segment"
    static let formsSlider = "forms_slider"
    static let formsApplyButton = "forms_apply_button"
}

private func styleDemoButton(
    _ button: UIButton,
    title: String,
    filled: Bool = true
) {
    if #available(iOS 15.0, *) {
        button.configuration = filled ? .filled() : .bordered()
        button.configuration?.title = title
    } else {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = filled ? 0 : 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.backgroundColor = filled ? .systemBlue : .clear
        button.setTitleColor(filled ? .white : .systemBlue, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
}

final class FormsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forms"
        view.backgroundColor = .systemBackground
        configureLayout()
        buildSections()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 20

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

    private func buildSections() {
        let intro = UILabel()
        intro.numberOfLines = 0
        intro.font = .systemFont(ofSize: 15)
        intro.textColor = demoSecondaryTextColor()
        intro.text = "A compact form surface for future input primitives. The controls are real UIKit components."
        contentStack.addArrangedSubview(intro)

        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Enter display name"
        field.text = "Codex"
        field.accessibilityIdentifier = DemoAccessibilityID.formsTextField
        contentStack.addArrangedSubview(field)

        let toggleRow = UIStackView()
        toggleRow.axis = .horizontal
        toggleRow.alignment = .center
        toggleRow.distribution = .fill
        let toggleLabel = UILabel()
        toggleLabel.text = "Enable design overlay"
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.accessibilityIdentifier = DemoAccessibilityID.formsSwitch
        toggleRow.addArrangedSubview(toggleLabel)
        toggleRow.addArrangedSubview(toggle)
        contentStack.addArrangedSubview(toggleRow)

        let segment = UISegmentedControl(items: ["Compact", "Comfort", "Large"])
        segment.selectedSegmentIndex = 1
        segment.accessibilityIdentifier = DemoAccessibilityID.formsSegment
        contentStack.addArrangedSubview(segment)

        let sliderLabel = UILabel()
        sliderLabel.text = "Preview scale"
        contentStack.addArrangedSubview(sliderLabel)

        let slider = UISlider()
        slider.minimumValue = 0.8
        slider.maximumValue = 1.2
        slider.value = 1.0
        slider.accessibilityIdentifier = DemoAccessibilityID.formsSlider
        contentStack.addArrangedSubview(slider)

        let applyButton = UIButton(type: .system)
        styleDemoButton(applyButton, title: "Apply Form Settings")
        applyButton.accessibilityIdentifier = DemoAccessibilityID.formsApplyButton
        contentStack.addArrangedSubview(applyButton)
    }
}

final class ModalDemoViewController: UIViewController {
    private let titleText: String
    private let messageText: String

    init(title: String, message: String) {
        self.titleText = title
        self.messageText = message
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        view.backgroundColor = .systemBackground

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = titleText

        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textColor = demoSecondaryTextColor()
        messageLabel.text = messageText

        let dismissButton = UIButton(type: .system)
        styleDemoButton(dismissButton, title: "Dismiss Modal")
        dismissButton.accessibilityIdentifier = DemoAccessibilityID.dismissModalButton
        dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(messageLabel)
        stack.addArrangedSubview(dismissButton)
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}

final class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail Surface"
        view.backgroundColor = .systemBackground
        configureLayout()
    }

    private func configureLayout() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "Navigation and Modal Demo"

        let bodyLabel = UILabel()
        bodyLabel.numberOfLines = 0
        bodyLabel.font = .systemFont(ofSize: 16)
        bodyLabel.textColor = demoSecondaryTextColor()
        bodyLabel.text = "This page exists to validate push, present, dismiss, and controller-aware target resolution."

        let sheetButton = demoActionButton(
            title: "Show Sheet",
            accessibilityIdentifier: DemoAccessibilityID.showSheetButton,
            action: #selector(showSheet)
        )
        let fullScreenButton = demoActionButton(
            title: "Present Full Screen",
            accessibilityIdentifier: DemoAccessibilityID.presentFullScreenButton,
            action: #selector(showFullScreen)
        )

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(bodyLabel)
        stack.addArrangedSubview(sheetButton)
        stack.addArrangedSubview(fullScreenButton)

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func demoActionButton(title: String, accessibilityIdentifier: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        styleDemoButton(button, title: title)
        button.accessibilityIdentifier = accessibilityIdentifier
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func showSheet() {
        let controller = ModalDemoViewController(
            title: "Demo Sheet",
            message: "Presented from the pushed detail screen."
        )
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }

    @objc private func showFullScreen() {
        let controller = ModalDemoViewController(
            title: "Full Screen Demo",
            message: "Presented full screen to exercise controller dismissal."
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

final class ViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIView-WZB"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Details",
            style: .plain,
            target: self,
            action: #selector(showDetailScreen)
        )
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
        contentStack.addArrangedSubview(makeSectionTitle("Navigation and Modal"))
        contentStack.addArrangedSubview(makeNavigationDemo())
        contentStack.addArrangedSubview(makeSectionTitle("Basic Table"))
        contentStack.addArrangedSubview(makeBasicTableDemo())
        contentStack.addArrangedSubview(makeSectionTitle("Merged Rows and Interaction"))
        contentStack.addArrangedSubview(makeMergedTableDemo())
        contentStack.addArrangedSubview(makeSectionTitle("Variable Row Heights and Column Widths"))
        contentStack.addArrangedSubview(makeUnevenGridDemo())
        contentStack.addArrangedSubview(makeSectionTitle("Scrollable Grid"))
        contentStack.addArrangedSubview(makeScrollableGridDemo())
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

    private func makeNavigationDemo() -> UIView {
        let card = makeCard(height: 170)
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12

        let body = UILabel()
        body.numberOfLines = 0
        body.font = .systemFont(ofSize: 14)
        body.textColor = demoSecondaryTextColor()
        body.text = "Use these buttons to push a detail controller or present a modal surface. They back the controller-focused E2E flows."

        let pushButton = UIButton(type: .system)
        styleDemoButton(pushButton, title: "Push Detail Screen")
        pushButton.accessibilityIdentifier = DemoAccessibilityID.pushDetailButton
        pushButton.addTarget(self, action: #selector(showDetailScreen), for: .touchUpInside)

        let modalButton = UIButton(type: .system)
        styleDemoButton(modalButton, title: "Show Home Sheet", filled: false)
        modalButton.accessibilityIdentifier = DemoAccessibilityID.showSheetButton
        modalButton.addTarget(self, action: #selector(showHomeSheet), for: .touchUpInside)

        let formsButton = UIButton(type: .system)
        styleDemoButton(formsButton, title: "Push Forms Screen", filled: false)
        formsButton.accessibilityIdentifier = DemoAccessibilityID.pushFormsButton
        formsButton.addTarget(self, action: #selector(showFormsScreen), for: .touchUpInside)

        stack.addArrangedSubview(body)
        stack.addArrangedSubview(pushButton)
        stack.addArrangedSubview(modalButton)
        stack.addArrangedSubview(formsButton)
        card.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        return card
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
        card.clipsToBounds = true
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

    private func makeUnevenGridDemo() -> UIView {
        let card = makeCard(height: 230)
        let tableView = UIView(frame: CGRect(x: 16, y: 16, width: view.bounds.width - 64, height: 198))
        card.addSubview(tableView)

        tableView.wzb_drawList(
            with: tableView.bounds,
            defaultColumns: 3,
            rowHeights: [0.9, 1.3, 1.1, 1.7],
            datas: [
                "Quarter", "Revenue", "Trend",
                "Q1", "218.4", "Stable",
                "Q2", "325.1", "Up",
                "Q3", "410.8", "Peak"
            ],
            colorInfo: [
                2: .systemBlue,
                5: .systemGreen,
                8: .systemOrange,
                11: .systemRed
            ],
            columnWidthInfo: [
                0: [1.4, 1, 0.8],
                1: [1.2, 1, 0.8],
                2: [1.2, 1, 0.8],
                3: [1.2, 1, 0.8]
            ],
            backgroundColorInfo: [
                0: demoHeaderBackgroundColor(),
                1: demoHeaderBackgroundColor(),
                2: demoHeaderBackgroundColor()
            ]
        )

        return card
    }

    private func makeScrollableGridDemo() -> UIView {
        let card = makeCard(height: 250)
        let scrollDemo = UIScrollView(frame: CGRect(x: 16, y: 16, width: view.bounds.width - 64, height: 218))
        scrollDemo.layer.cornerRadius = 14
        scrollDemo.clipsToBounds = true
        scrollDemo.backgroundColor = .white.withAlphaComponent(0.45)
        scrollDemo.alwaysBounceHorizontal = true
        scrollDemo.alwaysBounceVertical = true
        scrollDemo.showsHorizontalScrollIndicator = true
        scrollDemo.showsVerticalScrollIndicator = true
        scrollDemo.panGestureRecognizer.addTarget(self, action: #selector(handleScrollableGridPan(_:)))
        card.addSubview(scrollDemo)

        let header = ["Month", "North", "South", "East", "West", "Total"]
        let rows = (1 ... 12).flatMap { month in
            [
                "\(month)",
                "\(Int.random(in: 80 ... 140))",
                "\(Int.random(in: 90 ... 160))",
                "\(Int.random(in: 70 ... 135))",
                "\(Int.random(in: 95 ... 180))",
                "\(Int.random(in: 400 ... 650))"
            ]
        }

        scrollDemo.wzb_drawScrollableList(
            origin: CGPoint(x: 0, y: 0),
            cellSize: CGSize(width: 92, height: 44),
            columns: 6,
            rows: 13,
            datas: header + rows,
            colorInfo: [5: .systemIndigo],
            backgroundColorInfo: Dictionary(uniqueKeysWithValues: (0 ..< 6).map { ($0, demoHeaderBackgroundColor()) })
        )

        return card
    }

    @objc private func handleScrollableGridPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            scrollView.isScrollEnabled = false
        case .cancelled, .ended, .failed:
            scrollView.isScrollEnabled = true
        default:
            break
        }
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

    @objc private func showDetailScreen() {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }

    @objc private func showHomeSheet() {
        let controller = ModalDemoViewController(
            title: "Home Sheet",
            message: "Presented from the root controller to validate controller dismissal from the home surface."
        )
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }

    @objc private func showFormsScreen() {
        navigationController?.pushViewController(FormsViewController(), animated: true)
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
