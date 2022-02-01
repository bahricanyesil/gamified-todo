part of '../groups_screen.dart';

class _GroupItem extends StatelessWidget with ColorHelpers {
  const _GroupItem(this.group, {Key? key}) : super(key: key);
  final Group group;

  @override
  Widget build(BuildContext context) {
    final Color color = lightRandomColor;
    return DecoratedBox(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadii.mediumCircular),
      child: Row(
        children: <Widget>[
          _circledText(color, context),
          _title,
          const Spacer(),

          /// Base Icon Button
        ],
      ),
    );
  }

  Widget _circledText(Color color, BuildContext context) => CircledText(
        text: group.title[0],
        color: color.darken(.4),
        paddingFactor: 2.5,
        margin: EdgeInsets.symmetric(horizontal: context.responsiveSize * 4),
      );

  Widget get _title => BaseText(group.title, color: Colors.black);
}
