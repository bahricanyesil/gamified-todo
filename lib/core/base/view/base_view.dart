import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view-model/base_view_model.dart';

/// Base view class to create customized view models using this.
class BaseView<T extends BaseViewModel> extends StatefulWidget {
  //final Widget Function(BuildContext) bodyBuilder;

  /// Custom dispose method to call on dispose.
  final VoidCallback? customDispose;
  final VoidCallback? customInitState;
  final List<Widget>? appBarChildren;
  final double? appBarSize;
  final bool safeArea;
  final bool resize;

  const BaseView({
    //required this.bodyBuilder,
    this.customDispose,
    this.customInitState,
    this.appBarChildren,
    this.appBarSize,
    this.safeArea = true,
    this.resize = true,
    Key? key,
  }) : super(key: key);

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model = context.read<T>();

  @override
  void initState() {
    super.initState();
    if (widget.customInitState != null) widget.customInitState!();
  }

  @override
  void dispose() {
    model.disposeLocal();
    if (widget.customDispose != null) widget.customDispose!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_initializeModel();
    return Container();
  }
  /*return context.watch<T>().state == ViewStates.uninitialized
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: widget.resize,
            appBar: _appBar,
            body: widget.safeArea
                ? SafeArea(child: widget.bodyBuilder(context))
                : widget.bodyBuilder(context),
          );
  }

  DefaultAppBar? get _appBar =>
      widget.appBarChildren != null && widget.appBarSize != null
          ? DefaultAppBar(
              size: widget.appBarSize!, children: widget.appBarChildren!)
          : null;

  void _initializeModel() {
    model = context.read<T>();
    model
      ..context = context
      ..isLandscape = DeviceTypeHelper(context).isLandscape;
  }*/
}
