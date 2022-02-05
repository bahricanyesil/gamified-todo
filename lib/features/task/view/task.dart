import 'package:flutter/material.dart';
import 'package:gamified_todo/core/managers/navigation/navigation_shelf.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';
import '../../home/view-model/home_view_model.dart';
import '../constants/create_task_texts.dart';
import '../view-model/task_view_model.dart';

/// Screen to create a task.
class TaskScreen extends StatelessWidget with TaskTexts {
  /// Default constructor for [TaskScreen].
  const TaskScreen({this.id, Key? key}) : super(key: key);

  /// Id of the task if the screen is edit.
  final String? id;

  @override
  Widget build(BuildContext context) => BaseView<TaskViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: DefaultAppBar(
          titleText: TaskTexts.title,
          actionsList: _appBarIcons(context),
        ),
        customInitState: _customInitState,
      );

  List<Widget> _appBarIcons(BuildContext context) => <Widget>[
        if (id != null)
          BaseIconButton(
            margin: context.rightPadding(Sizes.low),
            onPressed: () async =>
                context.read<TaskViewModel>().delete(context),
            icon: Icons.delete,
            color: AppColors.error.lighten(.05),
          ),
      ];

  void _customInitState(TaskViewModel model) {
    if (id != null) model.setScreenType(ScreenType.edit, id!);
  }

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.lowMed),
        child: Column(children: _bodyChildren(context)),
      );

  List<Widget> _bodyChildren(BuildContext context) {
    final TaskViewModel model = context.read<TaskViewModel>();
    return <Widget>[
      CustomTextField(
        controller: model.content,
        hintText: TaskTexts.hintText,
        maxLength: 175,
      ),
      context.sizedH(1.6),
      _chooseRow,
      context.sizedH(2.5),
      _dueDateButton,
      context.sizedH(2.5),
      _awardButtonWrapper(isAwardOf: true),
      context.sizedH(2.5),
      _awardButtonWrapper(isAwardOf: false),
      context.sizedH(3.5),
      _createButton(context, model),
    ];
  }

  Widget _createButton(BuildContext context, TaskViewModel model) =>
      ElevatedIconTextButton(
        icon: model.screenType.icon,
        text: model.screenType.actionText,
        onPressed: () => model.action(context.read<HomeViewModel>()),
      );

  Widget get _dueDateButton =>
      SelectorHelper<DateTime, TaskViewModel>().builder(
        (_, TaskViewModel model) => model.dueDate,
        (_, DateTime date, __) => TitledButton<DateTime>(
          buttonTitle: TaskTexts.dueDate,
          customButton: (BuildContext context) =>
              _customButtonCallback(context, date),
        ),
      );

  Widget _customButtonCallback(BuildContext context, DateTime date) {
    final TaskViewModel model = context.read<TaskViewModel>();
    return CustomDatePicker(
      callback: model.onDueDateChoose,
      selectedDate: date,
      initialDate: model.dueDate,
    );
  }

  Widget get _chooseRow => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_priorityButton, _groupButton],
      );

  Widget get _priorityButton =>
      SelectorHelper<Priorities, TaskViewModel>().builder(
        (_, TaskViewModel model) => model.priority,
        (BuildContext context, Priorities priority, _) {
          final TaskViewModel model = context.read<TaskViewModel>();
          return TitledButton<Priorities>(
            buttonTitle: TaskTexts.priority,
            title: TaskTexts.priorityDialogTitle,
            values: model.priorities,
            initialValues: <Priorities>[priority],
            callback: model.onPriorityChoose,
          );
        },
      );

  Widget get _groupButton => SelectorHelper<Group, TaskViewModel>().builder(
        (_, TaskViewModel model) => model.group,
        (BuildContext context, Group group, __) {
          final TaskViewModel model = context.read<TaskViewModel>();
          return TitledButton<Group>(
            buttonTitle: TaskTexts.group,
            title: TaskTexts.groupDialogTitle,
            values: model.groups(context),
            initialValues: <Group>[group],
            callback: model.onGroupChoose,
            autoSizeText: false,
            buttonWidth: context.responsiveSize * 55,
          );
        },
      );

  Widget _awardButtonWrapper({required bool isAwardOf}) =>
      SelectorHelper<List<Task>, HomeViewModel>().builder(
        (_, HomeViewModel model) => model.tasks,
        (BuildContext context, List<Task> tasks, __) =>
            SelectorHelper<Tuple2<List<Task>, List<Task>>, TaskViewModel>()
                .builder(
          (_, TaskViewModel model) => Tuple2<List<Task>, List<Task>>(
              model.awardOfTasks, model.awardsTasks),
          (BuildContext context, Tuple2<List<Task>, List<Task>> tuple, _) =>
              _awardButtonBuilder(context, tuple, tasks, isAwardOf),
        ),
      );

  Widget _awardButtonBuilder(BuildContext context,
      Tuple2<List<Task>, List<Task>> tuple, List<Task> tasks, bool isAwardOf) {
    final TaskViewModel model = context.read<TaskViewModel>();
    final List<Task> possibleValues = <Task>[];
    final List<Task> initialValues = isAwardOf ? tuple.item1 : tuple.item2;
    final List<Task> otherList = isAwardOf ? tuple.item2 : tuple.item1;
    for (final Task t in tasks) {
      final bool existOther =
          otherList.indexWhere((Task el) => el.id == t.id) != -1;
      if (t.id != id && !existOther) possibleValues.add(t);
    }
    final Function(List<Task> tasks) callback =
        isAwardOf ? model.onAwardOfChoose : model.onAwardsChoose;
    final IconData icon =
        isAwardOf ? Icons.card_giftcard_outlined : Icons.task_outlined;
    return _awardButton(
      context,
      values: possibleValues,
      initialValues: initialValues,
      callback: callback,
      icon: icon,
      buttonTitle: isAwardOf ? TaskTexts.awardOfTitle : TaskTexts.awardsTitle,
      dialogTitle: isAwardOf
          ? TaskTexts.awardOfDialogTitle
          : TaskTexts.awardsDialogTitle,
    );
  }

  Widget _awardButton(
    BuildContext context, {
    required List<Task> values,
    required List<Task> initialValues,
    required Function(List<Task>) callback,
    required IconData icon,
    required String buttonTitle,
    required String dialogTitle,
  }) =>
      TitledButton<Task>(
        buttonTitle: buttonTitle,
        title: dialogTitle,
        values: values,
        dialogType: ChooseDialogTypes.multiple,
        initialValues: initialValues,
        callback: callback,
        autoSizeText: false,
        buttonWidth: context.responsiveSize * 110,
        icon: icon,
      );
}
