<div align="center">

# 🌿 Goal on Wall

**Turn your lock screen into a living reminder of what matters most.**

Goal on Wall is a Flutter app that generates stunning, personalised wallpapers — visualising your life in weeks, your year in days, and your goals as countdowns — right on your lock screen.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/adityakhadsecode/goal-on-wall?style=flat-square)](https://github.com/adityakhadsecode/goal-on-wall/stargazers)

</div>

---

## ✨ What Is It?

Every day you unlock your phone dozens of times. Goal on Wall turns that moment into a silent motivator — a beautiful, data-driven wallpaper showing exactly where you are in life, the year, or your journey toward a goal. 

Now featuring a **Dynamic Home Screen** that shows your active goal's progress at a glance, and a **Detailed Analytics Dashboard** to dive deep into your metrics.

---

## 🎨 Wallpaper Types

Choose from **5 powerful calendar types**, each rendered in your preferred visual style:

| Type | Icon | What it shows |
|---|---|---|
| **Life Calendar** | 🟩 | Every week of your life — filled vs remaining |
| **Year Calendar** | 📅 | Days / Months / Quarters of the current year |
| **Goal Calendar** | 🎯 | Countdown from start to your personal deadline |
| **Product Launch** | 🚀 | Days until your big launch day |
| **Fitness Goal** | 💪 | Training days until your event or race |

---

## 🚀 Key Features

- **Native Resolution Rendering** — Wallpapers are rendered at your device's exact physical pixel dimensions for maximum crispness.
- **One-Tap Sharing** — Share your progress visually (PNG) and textually via WhatsApp, Instagram, or any other app.
- **Customization Redirection** — Tweak your active wallpaper anytime; the app remembers your settings and pre-populates the editor.
- **Goal Analytics** — A dedicated screen with progress charts, total/passed/remaining days, and a visual timeline.
- **History & Memory** — Keeps track of your recently generated wallpapers.

---

## 🖼️ Visual Styles

Each wallpaper type ships with two distinct looks:

| Style | Description |
|---|---|
| **The Flow** | An organic river path that grows as you progress — inspired by nature |
| **Dots** | A crisp grid of dots where filled circles mark time already lived |

---

## 🌈 Themes

The entire app is theme-aware with multiple handcrafted palettes:

- 🌲 **Forest** — Deep greens, moss, and amber (default)
- 🌊 **Ocean** — Deep navy with cyan accents

All colours, gradients, and glass surfaces adapt instantly.

---

## 🏗️ Tech Stack

- **Flutter 3** — cross-platform UI
- **Dart 3** — null-safe logic
- **Provider** — state management for theming and saved wallpapers
- **Custom Painters** — hand-drawn wallpaper previews (Flow path, Dot grid)
- **Glassmorphism UI** — organic dark design language with `OrganicBackground`, `GlassCard`
- **WorkManager** — daily periodic background refresh of lock screen
- **Wallpaper Manager** — native platform integration for setting Android wallpaper
- **Share Plus** — for sharing goal progress
- **Intl** — date formatting and localization logic
- **Shared Preferences** — persistent storage for wallpaper configurations

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── models/
│   └── wallpaper_config.dart       # Core data models & enums
├── providers/
│   └── wallpaper_provider.dart     # State management for saved wallpapers
├── screens/
│   ├── home_screen.dart            # Dynamic home with "My Goal Progress"
│   ├── analytics_screen.dart       # Detailed goal metrics & timeline
│   ├── wallpaper_preview_screen.dart # Final preview & setting logic
│   ├── wallpaper_type_screen.dart  # Step 1 — Choose Type
│   ├── theme_selection_screen.dart # Step 2 — Pick a Style
│   ├── life_customize_screen.dart  # Step 3+ — Configuration editors
│   ├── year_customize_screen.dart
│   ├── goal_customize_screen.dart
│   ├── product_launch_customize_screen.dart
│   └── fitness_goal_customize_screen.dart
├── theme/
│   ├── app_theme.dart              # Palette definitions
│   └── theme_provider.dart
├── services/
│   ├── background_task.dart        # Daily refresh dispatcher
│   ├── wallpaper_service.dart     # PNG rendering (Native Resolution)
│   └── wallpaper_storage.dart     # SharedPreferences persistence
└── widgets/
    ├── organic_background.dart     # Animated radial surfaces
    ├── glass_card.dart             # Frosted glass containers
    └── customize_shared_widgets.dart
```

---

## 🗺️ Roadmap

- [x] Actual wallpaper image generation (Native Resolution PNG)
- [x] Android lock screen auto-set
- [x] Dynamic Home Screen metrics
- [x] Detailed Analytics & Timeline view
- [x] One-tap Sharing system
- [x] Daily automatic background refresh
- [ ] iOS Shortcuts integration
- [ ] More visual styles (Heatmap, Arc, Timeline)
- [ ] Cloud backup of configurations
- [ ] Home screen widget support

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

1. Fork the repo
2. Create your feature branch: `git checkout -b feat/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push: `git push origin feat/amazing-feature`
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

---

<div align="center">

Made with 💚 by [Aditya Khadse](https://github.com/adityakhadsecode)

*Every week is a dot. Make them count.*

</div>
