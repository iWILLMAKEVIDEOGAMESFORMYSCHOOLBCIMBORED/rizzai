import UIKit

class KeyboardViewController: UIInputViewController {

    // MARK: - Properties
    private var mainView: KeyboardMainView!
    private var heightConstraint: NSLayoutConstraint?
    private let keyboardHeight: CGFloat = 280

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardHeight()
    }

    // MARK: - Setup
    private func setupKeyboard() {
        mainView = KeyboardMainView(frame: .zero)
        mainView.delegate = self
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setKeyboardHeight() {
        heightConstraint?.isActive = false
        heightConstraint = view.heightAnchor.constraint(equalToConstant: keyboardHeight)
        heightConstraint?.isActive = true
    }
}

// MARK: - KeyboardMainViewDelegate
extension KeyboardViewController: KeyboardMainViewDelegate {
    func didTapRizzLine(_ line: String) {
        // Insert the rizz line into the current text field
        let proxy = textDocumentProxy
        proxy.insertText(line)

        // Haptics
        if UserDefaults.standard.bool(forKey: "hapticsEnabled") != false {
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
        }
    }

    func didTapDelete() {
        textDocumentProxy.deleteBackward()
    }

    func didTapReturn() {
        textDocumentProxy.insertText("\n")
    }

    func didTapNextKeyboard() {
        advanceToNextInputMode()
    }

    func getCurrentText() -> String {
        return textDocumentProxy.documentContextBeforeInput ?? ""
    }
}
