import 'package:app_maxall2/providers/ThemeProvider.dart';
import 'package:app_maxall2/screens/Orders/orders_screen.dart';
import 'package:app_maxall2/screens/favorites_screen.dart';
import 'package:app_maxall2/screens/returns_screen.dart';
import 'package:app_maxall2/screens/splash_screen.dart';
import 'package:app_maxall2/screens/wallet_screen.dart';
import 'package:app_maxall2/utils/language_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'providers/cart_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final langCode = await LanguageSession.getLanguage() ?? 'ar';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(startLocale: Locale(langCode)),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale startLocale;
  const MyApp({super.key, required this.startLocale});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.startLocale;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maxalll Ecommerce',
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      home: const SplashScreen(),
      routes: {
        "/orders": (context) => OrdersScreen(),
        "/returns": (context) => ReturnsScreen(),
        "/favorites": (context) => FavoritesScreen(),
        "/credits": (context) => WalletScreen(),
        "/login": (context) => LoginScreen(),
      },
    );
  }
}
