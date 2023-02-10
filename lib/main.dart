import 'package:customer/screens/home.dart';
import 'package:customer/screens/splash_screen.dart';
import 'package:customer/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Restaurant',
            debugShowCheckedModeBanner: false,
            theme: notifier.darkTheme ? dark : light,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}