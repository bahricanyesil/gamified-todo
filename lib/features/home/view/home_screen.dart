import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/widgets/divider/custom_divider.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../../../product/models/task/task.dart';
import '../constants/home_texts.dart';
import '../utilities/listen_home_value.dart';
import '../view-model/home_view_model.dart';
import 'ui-models/tasks_section_title.dart';

part 'components/tasks_section.dart';

/// Home Screen of the app.
class HomeScreen extends StatelessWidget with HomeTexts, ListenHomeValue {
  /// Default constructor for home screen.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        bodyBuilder: _bodyBuilder,
      );

  Widget _bodyBuilder(BuildContext context) {
    final List<TasksSection> sections = HomeViewModel.tasksSections
        .where((TasksSection s) => listenVisibleSection(context, s.status))
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.medWidth,
        vertical: context.lowMedHeight,
      ),
      child: SingleChildScrollView(
        child: Column(
            children: <Widget>[const _FilterSections(), _listView(sections)]),
      ),
    );
  }

  Widget _listView(List<TasksSection> sections) => ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, int index) =>
            _TasksSection(tasksSection: sections[index]),
        separatorBuilder: _seperatorBuilder,
        itemCount: sections.length,
      );

  Widget _seperatorBuilder(BuildContext context, int index) => Padding(
        padding: context.verticalPadding(Sizes.extremeLow),
        child: CustomDivider(context),
      );
}

class _FilterSections extends StatelessWidget {
  const _FilterSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 4.2,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: context.width,
        children: List<_CheckboxListTile>.generate(TaskStatus.values.length,
            (int index) => _CheckboxListTile(status: TaskStatus.values[index])),
      );
}

class _CheckboxListTile extends StatelessWidget with ListenHomeValue {
  const _CheckboxListTile({required this.status, Key? key}) : super(key: key);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final bool value = listenVisibleSection(context, status);
    return GestureDetector(
      onTap: () => _changeVisibility(!value, status, context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _checkbox(context, value),
          _expanded(context, value),
        ],
      ),
    );
  }

  Widget _checkbox(BuildContext context, bool value) => Checkbox(
        value: value,
        onChanged: (bool? value) => _changeVisibility(value, status, context),
      );

  Widget _expanded(BuildContext context, bool value) => Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: BaseText(
            status.value,
            style: TextStyles(context).subBodyStyle(
                color: value ? context.primaryColor.darken() : null),
          ),
        ),
      );

  void _changeVisibility(bool? value, TaskStatus status, BuildContext context) {
    if (value != null) {
      context.read<HomeViewModel>().setSectionVisibility(status, value);
    }
  }
}
