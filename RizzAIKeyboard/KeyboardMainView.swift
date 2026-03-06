import UIKit

// MARK: - Delegate Protocol
protocol KeyboardMainViewDelegate: AnyObject {
    func didTapRizzLine(_ line: String)
    func didTapDelete()
    func didTapReturn()
    func didTapNextKeyboard()
    func getCurrentText() -> String
}

// MARK: - KeyboardMainView
class KeyboardMainView: UIView {

    weak var delegate: KeyboardMainViewDelegate?

    private var selectedCategory: RizzKeyboardCategory = .openers
    private var suggestions: [String] = []
    private var isLoading = false

    // UI Elements
    private let headerView = UIView()
    private let categoryScrollView = UIScrollView()
    private let categoryStackView = UIStackView()
    private let suggestionsCollectionView: UICollectionView
    private let bottomBar = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Init
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 60)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        suggestionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(frame: frame)
        setupUI()
        loadSuggestions()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = UIColor.systemBackground

        setupHeader()
        setupCategoryBar()
        setupSuggestionsArea()
        setupBottomBar()
    }

    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)

        // Logo label
        let logoLabel = UILabel()
        logoLabel.text = "🔥 Rizz AI"
        logoLabel.font = .systemFont(ofSize: 15, weight: .bold)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(logoLabel)

        // Style badge
        let styleBadge = UILabel()
        let style = getRizzStyle()
        styleBadge.text = "\(style.emoji) \(style.title)"
        styleBadge.font = .systemFont(ofSize: 11, weight: .semibold)
        styleBadge.textColor = .white
        styleBadge.backgroundColor = UIColor(red: 0.54, green: 0.36, blue: 0.96, alpha: 1)
        styleBadge.layer.cornerRadius = 8
        styleBadge.layer.masksToBounds = true
        styleBadge.textAlignment = .center
        styleBadge.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(styleBadge)

        // Next keyboard button
        let nextKBButton = UIButton(type: .system)
        nextKBButton.setImage(UIImage(systemName: "globe"), for: .normal)
        nextKBButton.tintColor = .secondaryLabel
        nextKBButton.addTarget(self, action: #selector(nextKeyboardTapped), for: .touchUpInside)
        nextKBButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(nextKBButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 36),

            logoLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            logoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            styleBadge.leadingAnchor.constraint(equalTo: logoLabel.trailingAnchor, constant: 8),
            styleBadge.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            styleBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            styleBadge.heightAnchor.constraint(equalToConstant: 20),

            nextKBButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -12),
            nextKBButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            nextKBButton.widthAnchor.constraint(equalToConstant: 30),
            nextKBButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    private func setupCategoryBar() {
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        categoryScrollView.showsHorizontalScrollIndicator = false
        addSubview(categoryScrollView)

        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 8
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryScrollView.addSubview(categoryStackView)

        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 4),
            categoryScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 36),

            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 12),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -12),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
        ])

        for cat in RizzKeyboardCategory.allCases {
            let button = makeCategoryButton(category: cat)
            categoryStackView.addArrangedSubview(button)
        }
    }

    private func makeCategoryButton(category: RizzKeyboardCategory) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("\(category.emoji) \(category.title)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.layer.cornerRadius = 14
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        button.tag = RizzKeyboardCategory.allCases.firstIndex(of: category) ?? 0

        if category == selectedCategory {
            button.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.33, alpha: 1)
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .systemGray5
            button.setTitleColor(.label, for: .normal)
        }

        button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
        return button
    }

    private func setupSuggestionsArea() {
        suggestionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        suggestionsCollectionView.backgroundColor = .clear
        suggestionsCollectionView.showsHorizontalScrollIndicator = false
        suggestionsCollectionView.register(RizzSuggestionCell.self, forCellWithReuseIdentifier: "RizzCell")
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.delegate = self
        addSubview(suggestionsCollectionView)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            suggestionsCollectionView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 8),
            suggestionsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            suggestionsCollectionView.heightAnchor.constraint(equalToConstant: 138),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: suggestionsCollectionView.centerYAnchor),
        ])
    }

    private func setupBottomBar() {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = UIColor.systemGray6
        addSubview(bottomBar)

        // Delete button
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "delete.left"), for: .normal)
        deleteButton.tintColor = .label
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(deleteButton)

        // Space button
        let spaceButton = UIButton(type: .system)
        spaceButton.setTitle("space", for: .normal)
        spaceButton.backgroundColor = .white
        spaceButton.layer.cornerRadius = 5
        spaceButton.titleLabel?.font = .systemFont(ofSize: 16)
        spaceButton.setTitleColor(.label, for: .normal)
        spaceButton.layer.shadowColor = UIColor.black.cgColor
        spaceButton.layer.shadowOpacity = 0.15
        spaceButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        spaceButton.layer.shadowRadius = 0
        spaceButton.addTarget(self, action: #selector(spaceTapped), for: .touchUpInside)
        spaceButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(spaceButton)

        // Return button
        let returnButton = UIButton(type: .system)
        returnButton.setTitle("return", for: .normal)
        returnButton.backgroundColor = .systemGray4
        returnButton.layer.cornerRadius = 5
        returnButton.titleLabel?.font = .systemFont(ofSize: 16)
        returnButton.setTitleColor(.label, for: .normal)
        returnButton.layer.shadowColor = UIColor.black.cgColor
        returnButton.layer.shadowOpacity = 0.15
        returnButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        returnButton.layer.shadowRadius = 0
        returnButton.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(returnButton)

        NSLayoutConstraint.activate([
            bottomBar.topAnchor.constraint(equalTo: suggestionsCollectionView.bottomAnchor, constant: 4),
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 56),

            deleteButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 8),
            deleteButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 42),

            returnButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -8),
            returnButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            returnButton.widthAnchor.constraint(equalToConstant: 80),
            returnButton.heightAnchor.constraint(equalToConstant: 42),

            spaceButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 8),
            spaceButton.trailingAnchor.constraint(equalTo: returnButton.leadingAnchor, constant: -8),
            spaceButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            spaceButton.heightAnchor.constraint(equalToConstant: 42),
        ])
    }

    // MARK: - Actions
    @objc private func categoryTapped(_ sender: UIButton) {
        let cats = RizzKeyboardCategory.allCases
        guard sender.tag < cats.count else { return }
        selectedCategory = cats[sender.tag]
        refreshCategoryButtons()
        loadSuggestions()
    }

    @objc private func deleteTapped() {
        delegate?.didTapDelete()
    }

    @objc private func spaceTapped() {
        delegate?.didTapRizzLine(" ")
    }

    @objc private func returnTapped() {
        delegate?.didTapReturn()
    }

    @objc private func nextKeyboardTapped() {
        delegate?.didTapNextKeyboard()
    }

    private func refreshCategoryButtons() {
        for (i, view) in categoryStackView.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else { continue }
            let cat = RizzKeyboardCategory.allCases[i]
            if cat == selectedCategory {
                button.backgroundColor = UIColor(red: 1, green: 0.18, blue: 0.33, alpha: 1)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .systemGray5
                button.setTitleColor(.label, for: .normal)
            }
        }
    }

    // MARK: - Load Suggestions
    private func loadSuggestions() {
        // First show built-in examples instantly
        suggestions = Array(selectedCategory.examples.shuffled().prefix(8))
        suggestionsCollectionView.reloadData()

        // Then try AI if available
        let apiKey = UserDefaults.standard.string(forKey: "openAIKey") ?? ""
        guard !apiKey.isEmpty else { return }

        isLoading = true
        loadingIndicator.startAnimating()

        let context = delegate?.getCurrentText() ?? ""
        let cat = selectedCategory

        Task {
            let engine = KeyboardRizzEngine()
            let lines = await engine.generateLines(category: cat, context: context.isEmpty ? nil : context)
            DispatchQueue.main.async { [weak self] in
                self?.suggestions = lines
                self?.suggestionsCollectionView.reloadData()
                self?.isLoading = false
                self?.loadingIndicator.stopAnimating()
            }
        }
    }

    private func getRizzStyle() -> RizzKeyboardStyle {
        let raw = UserDefaults(suiteName: "group.com.rizzai.shared")?.string(forKey: "rizzStyle")
            ?? UserDefaults.standard.string(forKey: "rizzStyle")
            ?? "smooth"
        return RizzKeyboardStyle(rawValue: raw) ?? .smooth
    }
}

// MARK: - Collection View DataSource & Delegate
extension KeyboardMainView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RizzCell", for: indexPath) as! RizzSuggestionCell
        cell.configure(with: suggestions[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let line = suggestions[indexPath.item]
        delegate?.didTapRizzLine(line)

        // Bounce animation
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
    }
}

// MARK: - RizzSuggestionCell
class RizzSuggestionCell: UICollectionViewCell {
    private let label = UILabel()
    private let container = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)

        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -10),
        ])
    }

    func configure(with text: String) {
        label.text = text
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.container.backgroundColor = self.isHighlighted
                    ? UIColor(red: 1, green: 0.18, blue: 0.33, alpha: 0.15)
                    : .systemGray6
            }
        }
    }
}

// MARK: - Keyboard-side models (duplicated to avoid cross-target deps)
enum RizzKeyboardCategory: String, CaseIterable {
    case openers, compliments, responses, witty, romantic, playful

    var title: String {
        rawValue.capitalized
    }

    var emoji: String {
        switch self {
        case .openers: return "🚀"
        case .compliments: return "💫"
        case .responses: return "💬"
        case .witty: return "🧠"
        case .romantic: return "❤️"
        case .playful: return "😏"
        }
    }

    var examples: [String] {
        switch self {
        case .openers:
            return [
                "Are you a parking ticket? Because you've got 'fine' written all over you.",
                "Do you have a map? I keep getting lost in your eyes.",
                "Is your name Google? Because you have everything I've been searching for.",
                "Are you made of copper and tellurium? Because you're CuTe.",
                "Do you believe in love at first swipe, or should I unmatch and try again?",
                "Excuse me, but I think you dropped something: my jaw.",
                "If you were a vegetable, you'd be a cute-cumber.",
                "Are you a campfire? Because you're hot and I want to be near you."
            ]
        case .compliments:
            return [
                "Your smile could literally light up any room.",
                "I've met a lot of people, but you're genuinely one of a kind.",
                "The way you think is honestly one of your most attractive qualities.",
                "You have this energy that just makes everything feel more alive.",
                "Your laugh is absolutely contagious — in the best way possible.",
                "You make the world look better just by being in it.",
                "There's something about you I can't stop thinking about.",
                "Talking to you is genuinely the highlight of my day."
            ]
        case .responses:
            return [
                "You know what's funny? I was just thinking about you.",
                "Bold of you to assume I wasn't already on my way.",
                "See, this is exactly why I keep you around.",
                "I mean, you're not wrong. But I'm curious where you're going with this.",
                "Okay that actually made me smile. Well played.",
                "You always know exactly what to say.",
                "That's either the best or worst idea I've heard — I love it.",
                "Honestly? You had me at hello. But that just sealed it."
            ]
        case .witty:
            return [
                "I'd tell you a chemistry joke but I know I'd get a reaction.",
                "I must be a snowflake because I've fallen for you.",
                "Are you a bank loan? Because you've got my interest.",
                "I was blinded by your beauty — I'm going to need your name for insurance.",
                "My phone is broken. It doesn't have your number in it.",
                "Are you wi-fi? Because I'm feeling a connection.",
                "You must be a magician — every time I look at you, everyone else disappears.",
                "Is your name Bluetooth? Because I feel like we're pairing."
            ]
        case .romantic:
            return [
                "I never believed in destiny until I met you.",
                "Every song I hear now somehow reminds me of you.",
                "With you, even ordinary moments feel extraordinary.",
                "I find myself smiling for no reason — and then I realize it's because of you.",
                "You make me want to be a better version of myself.",
                "I could talk to you for hours and it still wouldn't feel like enough.",
                "You're the kind of person I've always hoped existed.",
                "I don't know how to explain it, but being around you just feels right."
            ]
        case .playful:
            return [
                "Stop being so cute, you're making it really hard to concentrate.",
                "I'm not a photographer, but I can definitely picture us together.",
                "Do you like science? Because we have great chemistry.",
                "You must be tired because you've been running through my mind all day.",
                "Is your name Netflix? Because I could watch you for hours.",
                "I'd say God bless you, but it looks like He already did.",
                "Are you a time traveler? Because I see you in my future.",
                "I was wondering if you had an extra heart — mine just got stolen."
            ]
        }
    }
}

enum RizzKeyboardStyle: String {
    case smooth, funny, bold, poetic, mysterious, wholesome

    var title: String { rawValue.capitalized }

    var emoji: String {
        switch self {
        case .smooth: return "😎"
        case .funny: return "😂"
        case .bold: return "💪"
        case .poetic: return "🌹"
        case .mysterious: return "🌙"
        case .wholesome: return "🥰"
        }
    }
}

// MARK: - Keyboard RizzEngine (minimal, no shared module)
class KeyboardRizzEngine {
    private var apiKey: String {
        UserDefaults.standard.string(forKey: "openAIKey") ?? ""
    }

    func generateLines(category: RizzKeyboardCategory, context: String?) async -> [String] {
        guard !apiKey.isEmpty else {
            return Array(category.examples.shuffled().prefix(8))
        }

        let styleRaw = UserDefaults.standard.string(forKey: "rizzStyle") ?? "smooth"
        let contextNote = context.map { " Context about the person: \($0)." } ?? ""
        let prompt = """
        Generate 8 unique, creative \(category.title.lowercased()) lines for a dating scenario.\(contextNote)
        Style: \(styleRaw)
        Return ONLY the 8 lines, one per line, no numbering or quotes.
        """

        do {
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
                return Array(category.examples.shuffled().prefix(8))
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10

            let body: [String: Any] = [
                "model": "gpt-4o-mini",
                "messages": [
                    ["role": "system", "content": "You are a charming rizz assistant helping someone impress their crush."],
                    ["role": "user", "content": prompt]
                ],
                "max_tokens": 400,
                "temperature": 0.9
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let choices = json?["choices"] as? [[String: Any]]
            let content = (choices?.first?["message"] as? [String: Any])?["content"] as? String ?? ""

            let lines = content.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            return lines.isEmpty ? Array(category.examples.shuffled().prefix(8)) : Array(lines.prefix(8))
        } catch {
            return Array(category.examples.shuffled().prefix(8))
        }
    }
}
