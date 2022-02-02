part of '../groups_screen.dart';

class _GroupItem extends StatelessWidget {
  const _GroupItem(this.group, {Key? key}) : super(key: key);
  final Group group;

  @override
  Widget build(BuildContext context) {
    final GroupsViewModel model = context.read<GroupsViewModel>();
    final Color color = model.color(group.id);
    return CustomExpansionTile(
      mainListTile: _mainListTile(context, color, model),
      backgroundColor: color,
      customChildrenWidget: _ExpansionChildren(groupId: group.id),
      onExpansionChanged: (bool val) => context
          .read<GroupsViewModel>()
          .setExpansion(group.id, isExpanded: val),
    );
  }

  Widget _mainListTile(
          BuildContext context, Color color, GroupsViewModel model) =>
      Row(
        children: <Widget>[
          _circledText(color),
          Expanded(child: _colorSelector(_titleBuilder)),
          _deleteButton(model),
        ],
      );

  Widget _deleteButton(GroupsViewModel model) => BaseIconButton(
      onPressed: () => model.deleteGroup(group.id),
      icon: Icons.delete,
      color: AppColors.error.darken(.1));

  Widget _circledText(Color color) =>
      SelectorHelper<String, GroupsViewModel>().builder(
          _circledTextSelector,
          (BuildContext context, String val, _) =>
              _buildCircledText(context, val, color));

  String _circledTextSelector(_, GroupsViewModel model) {
    final String? title = model.titleController(group.id)?.text;
    if (title == null || title.isEmpty) return ' ';
    return title[0];
  }

  Widget _buildCircledText(BuildContext context, String val, Color color) =>
      CircledText(
        text: val,
        color: color.darken(.4),
        paddingFactor: 2.5,
        margin: context.horizontalPadding(Sizes.extremeLow),
      );

  Widget _colorSelector(SelectorBuilder<Color> builder) =>
      SelectorHelper<Color, GroupsViewModel>().builder(
          (_, GroupsViewModel model) =>
              model.isExpanded(group.id) ? Colors.black : AppColors.white,
          builder);

  Widget _titleBuilder(BuildContext context, Color color, Widget? child) {
    final GroupsViewModel model = context.read<GroupsViewModel>();
    return Padding(
      padding: context
          .horizontalPadding(Sizes.low)
          .copyWith(bottom: context.responsiveSize),
      child: TextField(
        controller: model.titleController(group.id),
        style: TextStyles(context).textFormStyle(color: color),
        decoration: InputDeco(context).underlinedDeco(color: color),
        onChanged: (String? val) => model.onTitleChanged(group.id, val),
      ),
    );
  }
}

class _ExpansionChildren extends StatelessWidget {
  const _ExpansionChildren({required this.groupId, Key? key}) : super(key: key);
  final String groupId;
  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = SelectorHelper<List<Task>, HomeViewModel>()
        .listenValue(
            (HomeViewModel model) => model.getByGroupId(groupId), context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int i) => Padding(
        padding: _expansionChildPadding(i, context),
        child: BulletText(
          tasks[i].content,
          color: Colors.black,
          textAlign: TextAlign.start,
          fontSizeFactor: 4.8,
        ),
      ),
    );
  }

  EdgeInsets _expansionChildPadding(int i, BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.responsiveSize * 5,
      ).copyWith(
        top: context.responsiveSize * (i == 0 ? 2 : 1),
        bottom: context.responsiveSize * (i == 1 ? 2 : 1),
      );
}
