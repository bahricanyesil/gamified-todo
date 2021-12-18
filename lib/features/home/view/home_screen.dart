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
class HomeScreen extends StatelessWidget with HomeTexts {
  /// Default constructor for home screen.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        bodyBuilder: _bodyBuilder,
      );

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.medWidth,
          vertical: context.lowMedHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const BaseText('text'),
              _listView,
            ],
          ),
        ),
      );

  Widget get _listView => ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: _listItemBuilder,
        separatorBuilder: _seperatorBuilder,
        itemCount: TaskStatus.values.length,
      );

  Widget _listItemBuilder(BuildContext context, int index) =>
      _TasksSection(tasksSection: HomeViewModel.tasksSectionTitles[index]);

  Widget _seperatorBuilder(BuildContext context, int index) => Padding(
        padding: context.verticalPadding(Sizes.extremeLow),
        child: CustomDivider(context),
      );
}
