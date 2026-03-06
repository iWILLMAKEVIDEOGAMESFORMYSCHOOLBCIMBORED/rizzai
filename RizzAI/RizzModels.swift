import Foundation

// MARK: - Rizz Category
enum RizzCategory: String, CaseIterable, Identifiable {
    case openers, compliments, responses, witty, romantic, playful

    var id: String { rawValue }

    var title: String {
        switch self {
        case .openers: return "Openers"
        case .compliments: return "Compliments"
        case .responses: return "Responses"
        case .witty: return "Witty"
        case .romantic: return "Romantic"
        case .playful: return "Playful"
        }
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
                "Do you believe in love at first swipe, or should I match with you again?"
            ]
        case .compliments:
            return [
                "Your smile could literally light up any room — but especially this one.",
                "I've met a lot of people, but you're genuinely one of a kind.",
                "The way you think is honestly one of your most attractive qualities.",
                "You have this energy that just makes everything feel more alive.",
                "Your laugh is absolutely contagious — in the best way possible."
            ]
        case .responses:
            return [
                "You know what's funny? I was just thinking about you.",
                "I'd say that's surprising, but honestly nothing you do surprises me anymore.",
                "Bold of you to assume I wasn't already on my way.",
                "See, this is exactly why I keep you around.",
                "I mean, you're not wrong. But I'm curious where you're going with this."
            ]
        case .witty:
            return [
                "I'd tell you a chemistry joke but I know I'd get a reaction.",
                "Do you have a sunburn or are you always this hot?",
                "I must be a snowflake because I've fallen for you.",
                "Are you a bank loan? Because you've got my interest.",
                "I was blinded by your beauty — I'm going to need your name and number for insurance purposes."
            ]
        case .romantic:
            return [
                "I never believed in destiny until I met you.",
                "Every song I hear now somehow reminds me of you.",
                "With you, even ordinary moments feel extraordinary.",
                "I find myself smiling for no reason — and then I realize it's because I'm thinking of you.",
                "You make me want to be a better version of myself."
            ]
        case .playful:
            return [
                "Stop being so cute, you're making it really hard to concentrate.",
                "I'm not a photographer, but I can definitely picture us together.",
                "Do you like science? Because we have great chemistry.",
                "Is your name WiFi? Because I'm feeling a real connection.",
                "You must be tired because you've been running through my mind all day."
            ]
        }
    }
}

// MARK: - Rizz Style
enum RizzStyle: String, CaseIterable, Identifiable {
    case smooth, funny, bold, poetic, mysterious, wholesome

    var id: String { rawValue }

    var title: String {
        switch self {
        case .smooth: return "Smooth"
        case .funny: return "Funny"
        case .bold: return "Bold"
        case .poetic: return "Poetic"
        case .mysterious: return "Mysterious"
        case .wholesome: return "Wholesome"
        }
    }

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

    var description: String {
        switch self {
        case .smooth: return "Cool, confident, effortless"
        case .funny: return "Playful & makes them laugh"
        case .bold: return "Direct and unapologetic"
        case .poetic: return "Deep, lyrical, heartfelt"
        case .mysterious: return "Intriguing & keeps them guessing"
        case .wholesome: return "Sweet, genuine, kind"
        }
    }

    var systemPrompt: String {
        switch self {
        case .smooth:
            return "You are a smooth, confident rizz assistant. Generate lines that are cool, effortless, and charming. Never try-hard. Always sound natural."
        case .funny:
            return "You are a funny rizz assistant. Generate witty, humorous lines with clever wordplay or puns that will make someone laugh and feel comfortable."
        case .bold:
            return "You are a bold, direct rizz assistant. Generate confident, direct lines that express interest clearly and unapologetically."
        case .poetic:
            return "You are a poetic rizz assistant. Generate lyrical, deep, heartfelt lines that feel like poetry — beautiful and thoughtful."
        case .mysterious:
            return "You are a mysterious rizz assistant. Generate intriguing, cryptic lines that leave the other person curious and wanting to know more."
        case .wholesome:
            return "You are a wholesome rizz assistant. Generate sweet, genuine, kind-hearted lines that show sincere interest and warmth."
        }
    }
}
