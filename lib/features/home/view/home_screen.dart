import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/border/border_radii.dart';
import '../../../core/constants/enums/sizes.dart';
import '../../../core/constants/enums/tasks/priorities.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/color/color_extensions.dart';
import '../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../core/extensions/date/date_time_extensions.dart';
import '../../../core/extensions/text-style/decoration_extensions.dart';
import '../../../core/widgets/text/base_text.dart';
import '../../../core/widgets/text/not_fitted_text.dart';
import '../../../product/constants/enums/task_status.dart';
import '../../../product/models/task/task.dart';
import '../constants/home_texts.dart';
import '../view-model/home_view_model.dart';

part 'components/task_item.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(context),
            Expanded(
              child: ListView.builder(
                padding: context.verticalPadding(Sizes.low),
                itemCount: 10,
                itemBuilder: (BuildContext innerContext, int index) => Padding(
                  padding: context.bottomPadding(Sizes.low),
                  child: _TaskItem(
                      task: context.read<HomeViewModel>().tasks[index]),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _title(BuildContext context) => BaseText(
        HomeTexts.tasksTitle,
        style: TextStyles(context).titleStyle().underline(),
      );
}
