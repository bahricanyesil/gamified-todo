part of '../../home_screen.dart';

class _TasksSection extends StatelessWidget with ListenHomeValue {
  const _TasksSection({required this.tasksSection, Key? key}) : super(key: key);
  final TasksSection tasksSection;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _columnChildren(context),
      );

  List<Widget> _columnChildren(BuildContext context) => <Widget>[
        _TitleRow(section: tasksSection),
        context.sizedH(.5),
        _AnimatedTaskList(status: tasksSection.status),
      ];
}

class _TitleRow extends StatelessWidget with ListenHomeValue {
  const _TitleRow({required this.section, Key? key}) : super(key: key);
  final TasksSection section;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.read<HomeViewModel>().setExpanded(section.status),
        child: Padding(
          padding: context.verticalPadding(Sizes.extremeLow),
          child: _row(context),
        ),
      );

  Widget _row(BuildContext context) => Row(
        children: <Widget>[
          section.status.icon,
          context.sizedW(1.8),
          BaseText(section.title, style: TextStyles(context).titleStyle()),
          context.sizedW(1.6),
          _lengthText(context),
          const Spacer(),
          _icon(context, listenExpanded(context, section.status)),
        ],
      );

  Widget _lengthText(BuildContext context) => BaseText(
        '(${listenStatusTasks(context, section.status).length})',
        style: TextStyles(context)
            .subBodyStyle(color: context.primaryLightColor, height: 1.8),
      );

  Widget _icon(BuildContext context, bool isExpanded) => BaseIcon(
        isExpanded ? Icons.arrow_drop_down_sharp : Icons.arrow_right_sharp,
        color:
            isExpanded ? context.primaryLightColor : context.primaryDarkColor,
        sizeFactor: 11,
      );
}

class _AnimatedTaskList extends StatefulWidget {
  const _AnimatedTaskList({required this.status, Key? key}) : super(key: key);
  final TaskStatus status;

  @override
  __AnimatedTaskListState createState() => __AnimatedTaskListState();
}

class __AnimatedTaskListState extends State<_AnimatedTaskList>
    with ListenHomeValue {
  bool isExpanded = false;
  int itemCount = 2;
  Timer? _timer;
  List<Task> tasks = <Task>[];

  @override
  Widget build(BuildContext context) {
    tasks = listenStatusTasks(context, widget.status);
    isExpanded = listenExpanded(context, widget.status);
    _startTimer(isExpanded);
    return AnimatedContainer(
      duration: Duration(milliseconds: itemCount * (isExpanded ? 160 : 64)),
      child: CustomAnimatedList<Task>(animatedListModel: _animatedModel),
    );
  }

  AnimatedListModel<Task> get _animatedModel =>
      context.read<HomeViewModel>().animatedListModel(widget.status)
        ..visibleItemCount = itemCount
        ..items = tasks;

  void _startTimer(bool isExpanded) {
    final int diff = isExpanded ? tasks.length - itemCount : itemCount - 2;
    _restart(diff);
  }

  void _restart(int diff) {
    if (diff > 0 && _timer == null) {
      final int interval = itemCount * (isExpanded ? 80 : 32) ~/ diff;
      itemCount = isExpanded ? itemCount + 1 : itemCount - 1;
      _timer = Timer.periodic(Duration(milliseconds: interval), _timerCallback);
    }
  }

  void _timerCallback(Timer timer) {
    if (isExpanded && itemCount < tasks.length) {
      setState(() => itemCount++);
    } else if (!isExpanded && itemCount > 2) {
      setState(() => itemCount--);
    } else {
      timer.cancel();
      _timer = null;
    }
  }
}