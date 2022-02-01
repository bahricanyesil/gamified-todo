import 'package:flutter/material.dart';
import 'package:gamified_todo/core/constants/border/border_radii.dart';
import 'package:gamified_todo/core/extensions/color/color_extensions.dart';
import 'package:gamified_todo/core/extensions/context/theme_extensions.dart';
import 'package:gamified_todo/core/helpers/color_helpers.dart';
import 'package:gamified_todo/core/theme/color/l_colors.dart';
import 'package:gamified_todo/core/widgets/text/circled_text.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/models/group/group.dart';
import '../constants/groups_texts.dart';
import '../view-model/groups_view_model.dart';

part 'components/group_item.dart';

/// Screen to view, edit, create groups.
class GroupsScreen extends StatelessWidget with GroupsTexts {
  /// Default constructor for the [GroupsScreen].
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<GroupsViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: const DefaultAppBar(titleText: GroupsTexts.title),
      );

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.low),
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints:
                  BoxConstraints.loose(Size.fromHeight(context.height * 73)),
              child: const _GroupsList(),
            ),
            SizedBox(height: context.height * 2),
            ElevatedIconTextButton(
              text: 'Add a Group',
              icon: Icons.add_outlined,
              onPressed: context.read<GroupsViewModel>().addGroup,
            ),
          ],
        ),
      );
}

class _GroupsList extends StatelessWidget with GroupsTexts {
  const _GroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      SelectorHelper<int, GroupsViewModel>().builder(
        (_, GroupsViewModel model) => model.groups.length,
        _selectorBuilder,
      );

  Widget _selectorBuilder(BuildContext context, int val, _) => ListView.builder(
        itemCount: val,
        shrinkWrap: true,
        padding: context.horizontalPadding(Sizes.med),
        itemBuilder: (_, int i) => _listenGroup(i),
      );

  Widget _listenGroup(int i) =>
      SelectorHelper<Group, GroupsViewModel>().builder(
        (_, GroupsViewModel model) => model.groups[i],
        _selectorChildBuilder,
      );

  Widget _selectorChildBuilder(BuildContext context, Group group, _) => Padding(
      padding: EdgeInsets.symmetric(vertical: context.responsiveSize * 1.5),
      child: _GroupItem(group));
}
