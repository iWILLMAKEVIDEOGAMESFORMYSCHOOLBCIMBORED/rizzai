# 🔥 Rizz AI — iOS Keyboard App

A fully-featured AI-powered dating keyboard assistant for iPhone.  
Works like the **Rizz** app — lives in your keyboard on iMessage, Tinder, Hinge, etc.

---

## ✨ Features

- **Custom iOS Keyboard Extension** — shows up in any app  
- **6 Rizz Categories** — Openers, Compliments, Responses, Witty, Romantic, Playful  
- **6 Personality Styles** — Smooth, Funny, Bold, Poetic, Mysterious, Wholesome  
- **AI-Powered** — GPT-4o-mini integration (optional, works offline without it)  
- **Built-in Library** — 80+ pre-written rizz lines always available  
- **One-tap insert** — tap a line and it types into whatever app you're in  
- **Beautiful onboarding** — animated gradient setup flow  

---

## 🏗 How to Build

### Requirements
- **Mac** with macOS 13+ (Ventura or later)
- **Xcode 15+** (free from App Store)
- **Apple Developer Account** — free account works for device testing, $99/yr for App Store

### Step 1 — Install XcodeGen
```bash
brew install xcodegen
```
> Don't have Homebrew? Install it from [brew.sh](https://brew.sh)

### Step 2 — Generate the Xcode Project
```bash
cd RizzAI
xcodegen generate
```
This creates `RizzAI.xcodeproj` from `project.yml`.

### Step 3 — Open in Xcode
```bash
open RizzAI.xcodeproj
```

### Step 4 — Configure Signing
1. In Xcode, click **RizzAI** in the left sidebar (project root)
2. Select the **RizzAI** target → **Signing & Capabilities**
3. Set your **Team** (your Apple ID)
4. Do the same for the **RizzAIKeyboard** target
5. Update Bundle IDs if needed (e.g., `com.yourname.rizzai`)

### Step 5 — Add App Group
1. In both targets, under **Signing & Capabilities**, click **+ Capability**
2. Add **App Groups**
3. Create a group: `group.com.rizzai.shared` (match what's in entitlements)

### Step 6 — Run on Device
1. Plug in your iPhone
2. Select your device from the top dropdown
3. Press **▶ Run** (Cmd+R)

### Step 7 — Enable the Keyboard on iPhone
1. Open **Settings** → **General** → **Keyboard** → **Keyboards**
2. Tap **Add New Keyboard...**
3. Select **RizzAI**
4. Tap it again → enable **Allow Full Access** (required for AI calls)

---

## 📦 Build .ipa for Distribution

### TestFlight / App Store
1. Product → **Archive**
2. In Organizer → **Distribute App**
3. Choose **App Store Connect** → upload
4. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) to manage

### Ad-hoc .ipa (for sharing directly)
1. Product → **Archive**
2. Distribute App → **Ad Hoc**
3. Export → you'll get a `.ipa` file

---

## 🤖 AI Setup (Optional)

Without an API key, the app uses its built-in library of 80+ lines. To enable AI:

1. Get an OpenAI API key at [platform.openai.com](https://platform.openai.com)
2. Open Rizz AI app → **Style** tab → paste your key
3. The keyboard will now generate custom lines via GPT-4o-mini

---

## 📁 Project Structure

```
RizzAI/
├── project.yml                    ← XcodeGen config (generates .xcodeproj)
├── RizzAI/                        ← Main app
│   ├── RizzAIApp.swift            ← App entry point
│   ├── ContentView.swift          ← Tab navigation
│   ├── OnboardingView.swift       ← Animated setup flow
│   ├── HomeView.swift             ← Rizz generator UI
│   ├── StyleView.swift            ← Style + API key settings
│   ├── SettingsView.swift         ← Settings
│   ├── RizzModels.swift           ← Categories, styles, data models
│   ├── RizzEngine.swift           ← OpenAI API integration
│   ├── ColorExtension.swift       ← Hex color utility
│   ├── Assets.xcassets/           ← Icons, colors
│   ├── Info.plist
│   └── RizzAI.entitlements
└── RizzAIKeyboard/                ← Keyboard Extension
    ├── KeyboardViewController.swift ← UIInputViewController
    ├── KeyboardMainView.swift       ← Full keyboard UI + AI
    ├── Info.plist
    └── RizzAIKeyboard.entitlements
```

---

## 🛠 Troubleshooting

**"No account for team" error** → Sign into Xcode with your Apple ID (Xcode → Settings → Accounts)

**Keyboard doesn't appear** → Make sure you enabled it in Settings → General → Keyboard → Keyboards

**AI not working** → Enable "Allow Full Access" for the keyboard in Settings, and verify your OpenAI key is entered in the app

**Build fails with entitlements error** → Make sure App Group is configured in both targets with the same group ID

---

## 🎨 Customization

- **Add more lines**: Edit the `examples` arrays in `RizzModels.swift` and `KeyboardMainView.swift`
- **Change AI model**: Edit `"gpt-4o-mini"` to `"gpt-4o"` in `RizzEngine.swift` for higher quality
- **Add categories**: Add cases to `RizzCategory` and `RizzKeyboardCategory` enums
- **Change colors**: Edit hex values in the views

---

Built with ❤️ — SwiftUI + UIKit keyboard extension
