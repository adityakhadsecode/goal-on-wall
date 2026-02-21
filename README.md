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
- *(more themes planned)*

All colours, gradients, and glass surfaces adapt instantly.

---

## 📱 App Flow

```
Home Screen
  └─▶ Create New Wallpaper
        └─▶ 1. Choose Type  (Life / Year / Goal / Product Launch / Fitness Goal)
              └─▶ 2. Pick a Style  (The Flow  ·  Dots)
                    └─▶ 3. Define your Wallpaper  (dates, goal names, layout)
                          └─▶ ✨ Generate Wallpaper
```

---

## 🏗️ Tech Stack

- **Flutter 3** — cross-platform UI
- **Dart 3** — null-safe, exhaustive switch patterns
- **Provider** — lightweight state management for theming
- **Custom Painters** — hand-drawn wallpaper previews (Flow path, Dot grid)
- **Glassmorphism UI** — organic dark design language with `OrganicBackground`, `GlassCard`

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── models/
│   └── wallpaper_config.dart       # CalendarType & WallpaperTheme enums
├── screens/
│   ├── home_screen.dart            # Animated home with life snapshot
│   ├── wallpaper_type_screen.dart  # Step 1 — Choose Type
│   ├── theme_selection_screen.dart # Step 2 — Pick a Style
│   ├── life_customize_screen.dart  # Step 3a — Life Calendar
│   ├── year_customize_screen.dart  # Step 3b — Year Calendar
│   ├── goal_customize_screen.dart  # Step 3c — Goal Calendar
│   ├── product_launch_customize_screen.dart
│   └── fitness_goal_customize_screen.dart
├── theme/
│   ├── app_theme.dart              # AppColorPalette definitions
│   └── theme_provider.dart
└── widgets/
    ├── organic_background.dart     # Radial gradient + floating orbs
    ├── glass_card.dart             # Frosted glass card
    ├── customize_shared_widgets.dart  # Shared: Breadcrumb, DateInputField, GenerateButton
    ├── main_scaffold.dart
    └── dot_grid.dart
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0
- Dart ≥ 3.0
- Android Studio / VS Code with Flutter extension

### Run locally

```bash
# Clone the repo
git clone https://github.com/adityakhadsecode/goal-on-wall.git
cd goal-on-wall

# Install dependencies
flutter pub get

# Run on your device / emulator
flutter run

# Or run on Chrome (web)
flutter run -d chrome
```

### Analyse

```bash
flutter analyze   # Should report: No issues found!
```

---

## 🗺️ Roadmap

- [ ] Actual wallpaper image generation (canvas → PNG export)
- [ ] Android lock screen auto-set via platform channel
- [ ] iOS Shortcuts integration
- [ ] More visual styles (Heatmap, Arc, Timeline)
- [ ] iCloud / Google Drive backup of wallpaper configs
- [ ] Widget support (home screen widgets)

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
