import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamified_todo/core/providers/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/app-bar/default_app_bar.dart';
import '../../../core/widgets/divider/custom_divider.dart';
import '../../../core/widgets/list/custom_checkbox_tile.dart';
import '../../../core/widgets/text/colored-text/bullet_colored_text.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/settings_enums.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../constants/settings_texts.dart';
import '../utilities/listen_settings_value.dart';
import '../view-model/settings_view_model.dart';

part 'components/settings_item.dart';

/// Settings settings of the app.
/// User can set the visible task sections and
/// other adjustments for the tasks in this screen
class SettingsScreen extends StatelessWidget with SettingsTexts {
  /// Default constructor for [SettingsScreen].
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<SettingsViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: DefaultAppBar(
          titleText: SettingsTexts.title,
          showBack: !kIsWeb,
          textStyle: TextStyles(context).titleStyle(color: AppColors.white),
        ),
      );

  Widget _bodyBuilder(BuildContext context) {
    final int optionLength = SettingsOptions.values.length;
    return ListView.builder(
      itemCount: optionLength + 1,
      padding: context.allPadding(Sizes.med),
      itemBuilder: (BuildContext context, int index) => index == optionLength
          ? Padding(
              padding: context.topPadding(Sizes.lowMed),
              child: BaseText(SettingsTexts.madeBy,
                  fontSizeFactor: 5.5, color: context.primaryColor),
            )
          : Column(
              children: <Widget>[
                _SettingsItem(settings: SettingsOptions.values[index]),
                const CustomDivider(),
              ],
            ),
    );
  }
}
