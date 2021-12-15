import 'package:flutter/material.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';

import '../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../core/managers/navigation/navigation_shelf.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../constants/splash_texts.dart';

/// Splash screen of the app.
class SplashScreen extends StatefulWidget {
  /// Default constructor for splash screen.
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SplashTexts {
  late Future<bool> _initialize;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _initialize = _initializeApp();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<bool>(future: _initialize, builder: _builder),
      );

  Widget _builder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.hasData && !_retrying) {
      _navigate();
      return Container();
    } else if (snapshot.hasError && !_retrying) {
      return _ErrorScreen(onPressed: _onRetry);
    }
    return const Center(child: LoadingIndicator());
  }

  void _navigate() {
    Future<void>.delayed(
      Duration.zero,
      () => NavigationManager.instance.setInitialRoutePath(ScreenConfig.home()),
    );
  }

  void _onRetry() {
    _initialize = _retryInitialization();
    setState(() => _retrying = true);
  }

  Future<bool> _initializeApp() async => true;

  Future<bool> _retryInitialization() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _retrying = false;
    return true;
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.onPressed, Key? key}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: context.allPadding(Sizes.med),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _errorChildren(context),
        ),
      );

  List<Widget> _errorChildren(BuildContext context) => <Widget>[
        const BaseText(SplashTexts.error),
        SizedBox(height: context.height * 3),
        ElevatedTextButton(
          onPressed: onPressed,
          text: SplashTexts.retry,
        ),
      ];
}
