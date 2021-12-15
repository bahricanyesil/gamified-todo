part of '../home_screen.dart';

class _TaskItem extends StatelessWidget with ListenHomeValue {
  const _TaskItem({required this.taskIndex, Key? key}) : super(key: key);
  final int taskIndex;

  @override
  Widget build(BuildContext context) => Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          final HomeViewModel model = context.read<HomeViewModel>();
          if (direction == DismissDirection.startToEnd) {
            print('JERE');
            model.updateTaskStatus(taskIndex, TaskStatus.finished);
          } else if (direction == DismissDirection.endToStart) {
            model.tasks.removeAt(taskIndex);
          }
        },
        // confirmDismiss: (_) async => false,
        child: _customListTile(context),
      );

  Widget _customListTile(BuildContext context) => DecoratedBox(
        decoration: _boxDeco(context),
        child: Row(
          children: <Widget>[
            Expanded(child: _TaskPriorityNumber(priority: _priority(context))),
            Expanded(flex: 5, child: _textColumn(context)),
            Expanded(child: _TaskStatus(taskIndex: taskIndex)),
          ],
        ),
      );

  Widget _textColumn(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.extremeLow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Title(taskIndex: taskIndex),
            _Subtitle(taskIndex: taskIndex),
          ],
        ),
      );

  BoxDecoration _boxDeco(BuildContext context) => BoxDecoration(
        border: Border.all(
          color: _priority(context).color.darken(.3),
          width: 1.2,
        ),
        borderRadius: BorderRadii.lowCircular,
      );

  Priorities _priority(BuildContext context) => listenValue<Priorities>(
      (HomeViewModel value) => value.tasks[taskIndex].priority, context);
}

class _TaskPriorityNumber extends StatelessWidget {
  const _TaskPriorityNumber({required this.priority, Key? key})
      : super(key: key);
  final Priorities priority;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(context.responsiveSize * 1),
        margin: context.horizontalPadding(Sizes.lowMed),
        decoration:
            BoxDecoration(color: priority.color, shape: BoxShape.circle),
        child: priority.numberText,
      );
}

class _TaskStatus extends StatelessWidget with ListenHomeValue {
  const _TaskStatus({required this.taskIndex, Key? key}) : super(key: key);
  final int taskIndex;

  @override
  Widget build(BuildContext context) {
    print(taskIndex);
    return _status(context).icon;
  }

  TaskStatus _status(BuildContext context) => listenValue(
      (HomeViewModel value) => value.tasks[taskIndex].status, context);
}

class _Title extends StatelessWidget with ListenHomeValue {
  const _Title({required this.taskIndex, Key? key}) : super(key: key);
  final int taskIndex;

  @override
  Widget build(BuildContext context) =>
      NotFittedText(_title(context), textAlign: TextAlign.start);

  String _title(BuildContext context) => listenValue(
      (HomeViewModel value) => value.tasks[taskIndex].content, context);
}

class _Subtitle extends StatelessWidget with ListenHomeValue {
  const _Subtitle({required this.taskIndex, Key? key}) : super(key: key);
  final int taskIndex;

  @override
  Widget build(BuildContext context) => NotFittedText(
        _creationDate(context).dm,
        textAlign: TextAlign.start,
        style: TextStyles(context).subtitleTextStyle(),
      );

  DateTime _creationDate(BuildContext context) => listenValue(
      (HomeViewModel value) => value.tasks[taskIndex].createdAt, context);
}
