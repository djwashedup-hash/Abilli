# Economic Influence

A Flutter app that maps consumer purchases to corporate ownership chains and major shareholders. See where your money actually goes when you buy groceries, coffee, and everyday items.

## Features

- **Receipt Scanning**: Scan receipts with your camera (native builds) or paste email receipt text
- **Manual Entry**: Add purchases with live merchant matching
- **Ownership Chains**: View complete corporate ownership structures
- **Shareholder Analysis**: See which individuals and entities are linked to your spending
- **Sourced Public Actions**: View public records of shareholder activities (FEC donations, NLRB actions, etc.)
- **Privacy-First**: All data stays on your device - no servers, no tracking

## Screenshots

The app features a dark theme inspired by GitHub with 5 main tabs:
- **Scan**: Camera receipt scanning (native) or web placeholder
- **Manual**: Add purchases with merchant matching
- **Alternatives**: Explore different shopping options
- **Report**: View spending analysis with pie charts and shareholder breakdowns
- **Settings**: Data management and privacy info

## Tech Stack

- **Framework**: Flutter/Dart
- **State Management**: Provider + ChangeNotifier
- **Local Storage**: SharedPreferences
- **UI**: Material Design 3 with custom dark theme
- **Fuzzy Matching**: string_similarity package

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / Xcode (for native builds)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/djwashedup-hash/economic_influence-.git
cd economic_influence-
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web
flutter run -d chrome

# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios
```

## Building

### Web Build
```bash
flutter build web --release --base-href "/economic_influence-/"
```

### Android Build
```bash
flutter build apk --release
```

### iOS Build
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── data/
│   ├── ownership_database.dart    # Merchant matching + ownership lookups
│   ├── ownership_seed_data.dart   # All company/shareholder/action data
│   └── report_generator.dart      # Report generation logic
├── models/
│   ├── alternative.dart           # Alternative product/store model
│   ├── company.dart               # Company model
│   ├── individual.dart            # Shareholder model
│   ├── monthly_report.dart        # Report classes
│   ├── product.dart               # Product model
│   ├── public_action.dart         # Public action model
│   ├── purchase.dart              # Purchase model
│   └── uncertainty_note.dart      # Uncertainty disclaimer model
├── screens/
│   ├── add_purchase_screen.dart   # Manual entry form
│   ├── alternatives_screen.dart   # Alternatives view
│   ├── monthly_report_screen.dart # Report view
│   ├── receipt_scanner_screen.dart # Scanner placeholder
│   └── settings_screen.dart       # Settings view
├── services/
│   ├── purchase_service.dart      # Purchase management
│   └── receipt_parser.dart        # OCR text parsing
├── theme/
│   └── app_theme.dart             # Dark theme configuration
├── widgets/
│   ├── shareholder_card.dart      # Expandable shareholder card
│   └── spending_pie_chart.dart    # Donut chart widget
└── main.dart                      # App entry point
```

## Data Sources

All ownership percentages are sourced from:
- **SEC EDGAR** filings (13F, DEF 14A)
- **SEDAR** (Canadian securities filings)
- Company annual reports

All public actions are sourced from:
- **FEC** (Federal Election Commission) - political donations
- **NLRB** (National Labor Relations Board) - labor relations
- **FTC** (Federal Trade Commission) - regulatory actions
- **Court filings** - legal proceedings
- **Lobbying disclosures** - official lobbying records

## Core Principles

1. **Structural relationships only** - Show ownership chains, never rate or score companies
2. **No moral judgments** - Never label anything as "good" or "bad"
3. **Illustrative calculations** - Clearly indicate that amounts are calculations, not literal cash flows
4. **Preserve uncertainty** - Note when ownership data is approximate
5. **Neutral language** - Use terms like "ownership-linked individuals"
6. **All public actions sourced** - Every claim has a source and date

## Testing

Run unit tests:
```bash
flutter test
```

Test coverage includes:
- `OwnershipDatabase` - merchant matching, ownership chains
- `ReportGenerator` - report generation, date filtering
- `PurchaseService` - CRUD operations, date filtering
- `ReceiptParser` - receipt text parsing

## Privacy

See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for complete privacy information.

**Key Points:**
- All data stored locally on device
- No data sent to any server
- No account required
- No tracking or analytics
- Camera used only for on-device OCR

## License

This project is proprietary software. All rights reserved.

## Acknowledgments

Built by Jason in Nanaimo, BC. Special thanks to everyone who provided feedback and testing.

## Contact

For questions or support, contact through the App Store listing.
