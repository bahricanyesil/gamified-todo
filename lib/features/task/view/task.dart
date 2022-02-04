import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/models/group/group.dart';
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
        appBar: const DefaultAppBar(titleText: TaskTexts.title),
        customInitState: _customInitState,
      );

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
      context.sizedH(3),
      _dueDateButton,
      context.sizedH(3),
      _createButton(context, model),
    ];
  }

  Widget _createButton(BuildContext context, TaskViewModel model) =>
      ElevatedIconTextButton(
        icon: model.screenType.icon,
        text: model.screenType.actionText,
        onPressed: () {
          model.action(context.read<HomeViewModel>());
        },
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
}
