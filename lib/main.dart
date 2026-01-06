// import 'package:academixstore/Appwrite/appwrite_services.dart';
import 'package:academixstore/Appwrite/main_view_model.dart';
import 'package:academixstore/Core/bookmarks/api/purchase_book_api_service.dart';
import 'package:academixstore/Core/home/api/home_api_services.dart';
import 'package:academixstore/Core/splash/splash_screen.dart';
import 'package:academixstore/Core/theme/theme_provider.dart';
import 'package:academixstore/Core/utils/responsive_extensions.dart';
// import 'package:academixstore/Core/auth/view/signin_screen.dart';
// import 'package:academixstore/Core/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // AppwriteService.instance; // Initialize - COMMENTED FOR STATIC APP
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseBookApiService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Update theme when system theme changes
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    context.read<ThemeProvider>().updateSystemTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => HomeApiServices())],
          child: MaterialApp(
            navigatorKey: navigatorKey, // For respix context access
            title: 'AcademixStore',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: themeProvider.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
