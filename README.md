# Unit Converter App

A premium, high-quality Unit Converter Application built with Flutter featuring a modern Neumorphic design.

## Features

### 🎨 Premium UI/UX Design
- **Neumorphic Design Language**: Modern, soft UI with smooth shadows and gradients
- **Light/Dark Mode Toggle**: Seamless theme switching with haptic feedback
- **Smooth Animations**: Fade transitions and animated containers throughout
- **Beautiful Icons**: Emoji-based category icons for visual appeal
- **Responsive Layout**: Works perfectly on all screen sizes

### 📊 Unit Categories
- **Weight & Mass**: kg, g, mg, Metric Tons, lb, oz
- **Length & Distance**: m, km, cm, mm, miles, yards, ft, inches
- **Volume & Capacity**: L, mL, m³, Gallons (US/UK), Quarts, Pints, Cups
- **Temperature**: Celsius, Fahrenheit, Kelvin
- **Area**: m², km², cm², Hectares, Acres, ft², in²
- **Speed**: m/s, km/h, mph, Knots, ft/s

### ⚡ Core Functionality
- **Real-time Conversion**: Instant calculation as you type
- **Swap Button**: Quick reverse of From/To units
- **Copy to Clipboard**: One-tap copy of converted results
- **High Precision**: Up to 10 decimal places accuracy
- **Smart Formatting**: Automatic comma separators and scientific notation for extreme values

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK (for building APK)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd unit_converter_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Building APK via GitHub Actions

This project includes a complete GitHub Actions workflow that automatically builds the APK when you push to the `main` branch.

### Steps:

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **GitHub Actions will automatically:**
   - Set up Flutter environment
   - Install all dependencies
   - Build release APKs (both split-per-ABI and universal)
   - Upload APKs as artifacts
   - Create a GitHub Release with the APKs attached

3. **Download the APK:**
   - Go to the **Actions** tab in your GitHub repository
   - Click on the latest workflow run
   - Download the APK from the **Artifacts** section
   
   OR
   
   - Go to the **Releases** section
   - Download the APK from the latest release

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── unit_models.dart      # Data models and conversion logic
├── providers/
│   └── converter_provider.dart  # State management
├── screens/
│   └── home_screen.dart      # Main UI screen
└── widgets/
    ├── action_buttons.dart   # Swap and Copy buttons
    ├── category_card.dart    # Category selection cards
    ├── conversion_card.dart  # Input/output display cards
    └── theme_toggle.dart     # Light/Dark mode toggle

.github/
└── workflows/
    └── build-apk.yml         # GitHub Actions workflow
```

## Dependencies

- **provider**: State management
- **google_fonts**: Beautiful typography
- **neumorphic**: Neumorphic design elements
- **flutter_svg**: SVG support
- **intl**: Internationalization utilities
- **clipboard**: Clipboard functionality

## Screenshots

The app features:
- Clean, modern interface with gradient accents
- Horizontal scrolling category selector
- Large, easy-to-read input/output fields
- Prominent swap button between conversion fields
- Action buttons for swap and copy operations
- Theme toggle in the header

## License

This project is open source and available under the MIT License.

## Contributing

Feel free to fork this project and submit pull requests for any improvements!

---

Made with ❤️ using Flutter
