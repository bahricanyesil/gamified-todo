part of '../../home_screen.dart';

class _HomeTitle extends StatelessWidget {
  const _HomeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: context.bottomPadding(Sizes.low),
        child: Row(
          children: <Widget>[
            const BaseIcon(Icons.checklist_outlined,
                color: AppColors.white, sizeFactor: 8.2),
            SizedBox(width: context.width * 3),
            const BaseText('Gamified To-Do',
                color: AppColors.white, fontSizeFactor: 7),
          ],
        ),
      );
}
