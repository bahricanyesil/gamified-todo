part of '../../home_screen.dart';

/// Section for filtering task sections.
class _FilterSections extends StatelessWidget {
  /// Default constructor for [_FilterSections].
  const _FilterSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: context.isLandscape ? 4 : 2,
        shrinkWrap: true,
        childAspectRatio: context.responsiveSize * 1.4,
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
