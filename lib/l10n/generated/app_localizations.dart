import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Material Design Showcase'**
  String get appTitle;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get followSystem;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// No description provided for @categoryMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material Components'**
  String get categoryMaterial;

  /// No description provided for @categoryAnimations.
  ///
  /// In en, this message translates to:
  /// **'Animations & Layout'**
  String get categoryAnimations;

  /// No description provided for @categoryStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get categoryStorage;

  /// No description provided for @categoryHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get categoryHardware;

  /// No description provided for @categorySystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get categorySystem;

  /// No description provided for @buttons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get buttons;

  /// No description provided for @buttonsDesc.
  ///
  /// In en, this message translates to:
  /// **'ElevatedButton, FilledButton, TextButton, etc.'**
  String get buttonsDesc;

  /// No description provided for @inputs.
  ///
  /// In en, this message translates to:
  /// **'Input Fields'**
  String get inputs;

  /// No description provided for @inputsDesc.
  ///
  /// In en, this message translates to:
  /// **'TextField, TextFormField, Search Bar'**
  String get inputsDesc;

  /// No description provided for @selections.
  ///
  /// In en, this message translates to:
  /// **'Selection Controls'**
  String get selections;

  /// No description provided for @selectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch, Checkbox, Radio, Slider, Chips'**
  String get selectionsDesc;

  /// No description provided for @dialogs.
  ///
  /// In en, this message translates to:
  /// **'Dialogs & Alerts'**
  String get dialogs;

  /// No description provided for @dialogsDesc.
  ///
  /// In en, this message translates to:
  /// **'Dialog, BottomSheet, Snackbar, Toast'**
  String get dialogsDesc;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @navigationDesc.
  ///
  /// In en, this message translates to:
  /// **'AppBar, Drawer, TabBar, BottomNav'**
  String get navigationDesc;

  /// No description provided for @cardsLists.
  ///
  /// In en, this message translates to:
  /// **'Cards & Lists'**
  String get cardsLists;

  /// No description provided for @cardsListsDesc.
  ///
  /// In en, this message translates to:
  /// **'Card, ListTile, ExpansionTile, GridView'**
  String get cardsListsDesc;

  /// No description provided for @animations.
  ///
  /// In en, this message translates to:
  /// **'Animation Effects'**
  String get animations;

  /// No description provided for @animationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Page transitions, Hero, Implicit/Explicit animations'**
  String get animationsDesc;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage Capabilities'**
  String get storage;

  /// No description provided for @storageDesc.
  ///
  /// In en, this message translates to:
  /// **'SharedPreferences, SQLite, File Operations'**
  String get storageDesc;

  /// No description provided for @hardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware Features'**
  String get hardware;

  /// No description provided for @hardwareDesc.
  ///
  /// In en, this message translates to:
  /// **'Camera, Biometric, Sensors'**
  String get hardwareDesc;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System Features'**
  String get system;

  /// No description provided for @systemDesc.
  ///
  /// In en, this message translates to:
  /// **'File picker, Share, URL launcher'**
  String get systemDesc;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get colorIndigo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
