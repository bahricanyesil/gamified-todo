part of 'focused_menu.dart';

class _FocusedMenuDetails extends StatelessWidget {
  const _FocusedMenuDetails({
    required this.menuItems,
    required this.child,
    required this.childOffset,
    required this.childSize,
    required this.menuBoxDecoration,
    required this.itemExtent,
    required this.animateMenu,
    required this.blurSize,
    required this.blurBackgroundColor,
    required this.menuWidth,
    required this.bottomOffsetHeight,
    required this.menuOffset,
    Key? key,
  }) : super(key: key);

  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double bottomOffsetHeight;
  final double menuOffset;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double maxMenuHeight = size.height * 0.45;
    final double listHeight = menuItems.length * (itemExtent ?? 50);

    final double maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final double menuHeight =
        listHeight < maxMenuHeight ? listHeight : maxMenuHeight;

    final double leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize.width);
    final double topOffset = (childOffset.dy + menuHeight + childSize.height) <
            size.height - bottomOffsetHeight
        ? childOffset.dy + childSize.height + menuOffset
        : childOffset.dy - menuHeight - menuOffset;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _background(context),
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: _tweenAnimationBuilder(maxMenuWidth, menuHeight),
          ),
          Positioned(
              top: childOffset.dy, left: childOffset.dx, child: _absorbPointer),
        ],
      ),
    );
  }

  Widget get _absorbPointer => AbsorbPointer(
        child: SizedBox(
          width: childSize.width,
          height: childSize.height,
          child: child,
        ),
      );

  Widget _tweenAnimationBuilder(double maxMenuWidth, double menuHeight) =>
      TweenAnimationBuilder<double>(
        duration: Durations.fast,
        builder: (BuildContext context, dynamic value, Widget? child) =>
            Transform.scale(scale: value, child: child),
        tween: Tween<double>(begin: 0, end: 1),
        child: Container(
          width: maxMenuWidth,
          height: menuHeight,
          decoration: _boxDeco,
          child: ClipRRect(
              borderRadius: BorderRadii.lowCircular, child: _menuList),
        ),
      );

  Widget get _menuList => ListView.builder(
        itemCount: menuItems.length,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final FocusedMenuItem item = menuItems[index];
          if (animateMenu) {
            return TweenAnimationBuilder<double>(
              builder: _itemAnimationBuilder,
              tween: Tween<double>(begin: 1, end: 0),
              duration: Duration(milliseconds: index * 150),
              child: _ListItem(item: item, itemExtent: itemExtent),
            );
          } else {
            return _ListItem(item: item, itemExtent: itemExtent);
          }
        },
      );

  Widget _itemAnimationBuilder(
          BuildContext context, double value, Widget? child) =>
      Transform(
        transform: Matrix4.rotationX(1.5708 * value),
        alignment: Alignment.bottomCenter,
        child: child,
      );

  Widget _background(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: (blurBackgroundColor ?? AppColors.black).withOpacity(0.8),
            ),
          ),
        ),
      );

  BoxDecoration get _boxDeco =>
      menuBoxDecoration ??
      BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadii.lowCircular,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1),
        ],
      );
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.item,
    required this.itemExtent,
    Key? key,
  }) : super(key: key);
  final FocusedMenuItem item;
  final double? itemExtent;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.pop(context);
          item.onPressed();
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 1),
          color: item.backgroundColor ?? Colors.white,
          height: itemExtent ?? 50.0,
          child: _containerPadding(context, item),
        ),
      );

  Widget _containerPadding(BuildContext context, FocusedMenuItem item) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.height * 2,
          horizontal: context.width * 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            item.title,
            if (item.trailingIcon != null) ...<Widget>[item.trailingIcon!]
          ],
        ),
      );
}
