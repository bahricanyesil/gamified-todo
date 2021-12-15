part of '../home_screen.dart';

class _TaskItem extends StatelessWidget {
  const _TaskItem({required this.task, Key? key}) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: task.priority.color.darken(.3),
            width: 1.2,
          ),
          borderRadius: BorderRadii.lowCircular,
        ),
        child: Row(
          children: <Widget>[
            _TaskStatus(status: task.status),
          ],
        ),
        // ListTile(
        //   leading: _TaskPriorityNumber(priority: task.priority),
        //   contentPadding: context.horizontalPadding(Sizes.lowMed),
        //   title: _title,
        //   subtitle: _subtitle(context),
        //   trailing: _TaskStatus(status: task.status),
        // ),
      );

  Widget get _title => NotFittedText(task.content, textAlign: TextAlign.start);

  Widget _subtitle(BuildContext context) => NotFittedText(task.createdAt.dm,
      textAlign: TextAlign.start,
      style: TextStyles(context).subtitleTextStyle());
}

class _TaskPriorityNumber extends StatelessWidget {
  const _TaskPriorityNumber({required this.priority, Key? key})
      : super(key: key);
  final Priorities priority;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minWidth: context.responsiveSize * 12),
        padding: EdgeInsets.all(context.responsiveSize * .8),
        decoration:
            BoxDecoration(color: priority.color, shape: BoxShape.circle),
        child: priority.numberText,
      );
}

class _TaskStatus extends StatelessWidget {
  const _TaskStatus({required this.status, Key? key}) : super(key: key);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          status.icon,
        ],
      );
}

// class _TitleSubtitle extends StatelessWidget {
//   const _TitleSubtitle({required this.status, Key? key}) : super(key: key);
//   final String title;
//   final String subtitle;

//   @override
//   Widget build(BuildContext context) => Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           status.icon,
//         ],
//       );

// }