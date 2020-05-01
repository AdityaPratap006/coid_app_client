import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//Providers
import './providers/auth.dart';
import './providers/hotspot_locations.dart';

//Screens
import './screens/home_screen.dart';
import './screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: HotspotLocations(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            canvasColor: Colors.white,
            primaryColor: Color(0xFF36d1dc),
            accentColor: Color(0xFF36096D),
            textTheme: GoogleFonts.robotoMonoTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Scaffold(
                              body: Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          : LoginScreen(),
                ),
        ),
      ),
    );
  }
}
