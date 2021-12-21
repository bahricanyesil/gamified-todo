import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/decoration/text_styles.dart';
import '../../../../../product/constants/enums/task/task_status.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/app-bar/default_app_bar.dart';
import '../../../core/widgets/divider/custom_divider.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../../../product/models/task/task.dart';
import '../constants/home_texts.dart';
import '../utilities/listen_home_value.dart';
import '../view-model/home_view_model.dart';
import 'ui-models/tasks_section_title.dart';

part 'components/filter/filter_sections.dart';
part 'components/home-app-bar/home_title.dart';
part 'components/tasks/tasks_section.dart';

/// Home Screen of the app.
class HomeScreen extends StatelessWidget with HomeTexts, ListenHomeValue {
  /// Default constructor for home screen.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: DefaultAppBar(
          titleW: const _HomeTitle(), titlePadding: context.medWidth,
          // leadingW: ,
        ),
        //  <Widget>[
        //   const BaseIcon(Icons.checklist_outlined,
        //       color: AppColors.white, sizeFactor: 8.2),
        //   SizedBox(width: context.width * 2.3),
        //  ,
        // ],
      );

  Widget _bodyBuilder(BuildContext context) {
    final List<TasksSection> sections = HomeViewModel.tasksSections
        .where((TasksSection s) => listenVisibleSection(context, s.status))
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.medWidth,
        vertical: context.lowHeight,
      ),
      child: _listView(sections),
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
