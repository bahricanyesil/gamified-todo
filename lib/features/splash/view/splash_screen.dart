import 'package:flutter/material.dart';

import '../../../core/managers/navigation/navigation_shelf.dart';
import '../../../core/widgets/buttons/elevated_text_button.dart';
import '../../../core/widgets/indicators/loading_indicator.dart';
import '../../../core/widgets/text/base_text.dart';
import '../constants/splash_texts.dart';

/// Splash screen of the app.
class SplashScreen extends StatefulWidget {
  /// Default constructor for splash screen.
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SplashTexts {
  final Future<bool> _initializeApp = Future<bool>.delayed(
    const Duration(seconds: 2),
    () => true,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<bool>(
          future: _initializeApp,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              NavigationManager.instance.setNewRoutePath(ScreenConfig.home());
            } else if (snapshot.hasError) {
              return _errorWidget;
            }
            return Center(child: LoadingIndicator(context));
          },
        ),
      );

  Widget get _errorWidget => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const BaseText(SplashTexts.error),
          ElevatedTextButton(
            onPressed: () => setState(() {}),
            text: SplashTexts.retry,
          ),
        ],
      );
}
