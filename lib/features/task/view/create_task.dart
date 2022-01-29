import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/app-bar/default_app_bar.dart';
import '../constants/create_task_texts.dart';
import '../view-model/create_task_view_model.dart';

/// Screen to create a task.
class CreateTaskScreen extends StatelessWidget {
  /// Default constructor for [CreateTaskScreen].
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<CreateTaskViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: const DefaultAppBar(
            titleText: CreateTaskTexts.title, showBack: !kIsWeb),
      );

  Widget _bodyBuilder(BuildContext context) => Container();
}
