import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/widgets/text/text_widgets_shelf.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../constants/home_texts.dart';
import '../utilities/listen_home_value.dart';
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
            context.sizedH(2),
            Expanded(child: _listViewBuilder(context)),
          ],
        ),
      );

  Widget _listViewBuilder(BuildContext context) => ListView.builder(
        itemCount: 12,
        itemBuilder: (BuildContext innerContext, int index) => Padding(
          padding: context.bottomPadding(Sizes.low),
          child: _TaskItem(taskIndex: index),
        ),
      );

  Widget _title(BuildContext context) =>
      BaseText(HomeTexts.tasksTitle, style: TextStyles(context).titleStyle());
}
