import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/models/group/group.dart';
import '../constants/create_task_texts.dart';
import '../view-model/create_task_view_model.dart';

/// Screen to create a task.
class CreateTaskScreen extends StatelessWidget with CreateTaskTexts {
  /// Default constructor for [CreateTaskScreen].
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<CreateTaskViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: const DefaultAppBar(titleText: CreateTaskTexts.title),
      );

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.lowMed),
        child: Column(children: _bodyChildren(context)),
      );

  List<Widget> _bodyChildren(BuildContext context) {
    final CreateTaskViewModel model = context.read<CreateTaskViewModel>();
    return <Widget>[
      CustomTextField(
        controller: model.content,
        hintText: CreateTaskTexts.hintText,
        maxLength: 175,
      ),
      context.sizedH(1.6),
      _chooseRow,
      context.sizedH(3),
      _dueDateButton,
    ];
  }

  Widget get _dueDateButton =>
      SelectorHelper<DateTime, CreateTaskViewModel>().builder(
        (_, CreateTaskViewModel model) => model.dueDate,
        (_, DateTime date, __) => TitledButton<DateTime>(
          buttonTitle: CreateTaskTexts.dueDate,
          customButton: (BuildContext context) => CustomDatePicker(
            callback: context.read<CreateTaskViewModel>().onDueDateChoose,
            selectedDate: date,
          ),
        ),
      );

  Widget get _chooseRow => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_priorityButton, _groupButton],
      );

  Widget get _priorityButton =>
      SelectorHelper<Priorities, CreateTaskViewModel>().builder(
        (_, CreateTaskViewModel model) => model.priority,
        (BuildContext context, Priorities priority, _) {
          final CreateTaskViewModel model = context.read<CreateTaskViewModel>();
          return TitledButton<Priorities>(
            buttonTitle: CreateTaskTexts.priority,
            title: CreateTaskTexts.priorityDialogTitle,
            values: model.priorities,
            initialValues: <Priorities>[priority],
            callback: model.onPriorityChoose,
          );
        },
      );

  Widget get _groupButton =>
      SelectorHelper<Group, CreateTaskViewModel>().builder(
        (_, CreateTaskViewModel model) => model.group,
        (BuildContext context, Group group, __) {
          final CreateTaskViewModel model = context.read<CreateTaskViewModel>();
          return TitledButton<Group>(
            buttonTitle: CreateTaskTexts.group,
            title: CreateTaskTexts.groupDialogTitle,
            values: model.groups,
            initialValues: <Group>[group],
            callback: model.onGroupChoose,
            autoSizeText: false,
            buttonWidth: context.responsiveSize * 55,
          );
        },
      );
}
