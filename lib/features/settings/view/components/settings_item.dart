part of '../settings_screen.dart';

class _SettingsItem extends StatelessWidget
    with SettingsTexts, ListenSettingsValue {
  const _SettingsItem({required this.settings, Key? key}) : super(key: key);
  final SettingsOptions settings;

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          dense: true,
          child: _expansionTile(context),
        ),
      );

  Widget _expansionTile(BuildContext context) => ExpansionTile(
        collapsedTextColor: context.primaryLightColor,
        collapsedIconColor: context.primaryLightColor,
        tilePadding: EdgeInsets.symmetric(horizontal: context.width * 1.5),
        leading: PrimaryBaseIcon(settings.icon, sizeFactor: 9),
        title: _title(context),
        subtitle: _subtitle(context),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: _children(context),
      );

  List<Widget> _children(BuildContext context) {
    switch (settings) {
      case SettingsOptions.visibleTaskSections:
        return List<CustomCheckboxTile>.generate(
            TaskStatus.values.length, (int i) => _checkbox(i, context));
      case SettingsOptions.info:
        return List<BaseText>.generate(
          SettingsTexts.infoSentences.length,
          (int i) => PrimaryBaseText(
            SettingsTexts.infoSentences[i],
            style: TextStyles(context).subtitleTextStyle(height: 2),
            textAlign: TextAlign.start,
          ),
        );
    }
  }

  CustomCheckboxTile _checkbox(int i, BuildContext context) {
    final TaskStatus status = TaskStatus.values[i];
    final SettingsViewModel model = context.read<SettingsViewModel>();
    return CustomCheckboxTile(
      text: status.value,
      onTap: (bool value) => model.setSectionVisibility(status, value),
      initialValue: listenVisibleSection(context, status),
    );
  }

  Widget _title(BuildContext context) => BaseText(
        settings.title,
        textAlign: TextAlign.start,
        style: TextStyles(context).bodyStyle(color: context.primaryColor),
      );

  Widget _subtitle(BuildContext context) => BaseText(
        settings.subtitle,
        textAlign: TextAlign.start,
        style: TextStyles(context).subtitleTextStyle(),
      );
}
