import 'package:flutter/material.dart';

import '../../../constants/border/border_constants_shelf.dart';
import '../../../constants/enums/enums_shelf.dart';
import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../extensions/context/theme_extensions.dart';
import '../../list/custom_checkbox_tile.dart';
import '../../text-field/custom_text_field.dart';
import '../../text/base_text.dart';

/// A choose dialog with multiple options.
class MultipleChooseDialog<T> extends StatefulWidget {
  /// Default constructor of [MultipleChooseDialog].
  const MultipleChooseDialog({
    required this.elements,
    required this.title,
    this.enableSearch = false,
    this.initialSelecteds,
    Key? key,
  }) : super(key: key);

  /// Title of the dialog.
  final String title;

  /// All possible elements.
  final List<T> elements;

  /// Enables or disables search
  final bool enableSearch;

  /// Initial selected values.
  final List<T>? initialSelecteds;

  @override
  _MultipleChooseDialogState<T> createState() =>
      _MultipleChooseDialogState<T>();
}

class _MultipleChooseDialogState<T> extends State<MultipleChooseDialog<T>> {
  String searchText = '';
  List<T> selectedItems = <T>[];
  List<T> localList = <T>[];

  @override
  void initState() {
    super.initState();
    localList = widget.elements;
    if ((widget.initialSelecteds ?? <T>[]).isNotEmpty) {
      selectedItems = widget.initialSelecteds!.toSet().toList();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO:
    getSearchResults();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.lowMed),
        child: AlertDialog(
          title: BaseText(widget.title),
          shape: ShapedBorders.roundedLowMed,
          backgroundColor: context.primaryLightColor,
          contentPadding: context.allPadding(Sizes.low),
          actionsPadding: context.allPadding(Sizes.low),
          content: getContent(),
          actions: <Widget>[_getActionButton()],
        ),
      );

  void getSearchResults() {
    localList = widget.elements
        .where((T e) =>
            e.toString().toLowerCase().startsWith(searchText.toLowerCase()))
        .toList();
  }

  Widget getContent() => SizedBox(
        width: context.width * 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.enableSearch) _getSearchForm(),
            Expanded(child: _getList()),
          ],
        ),
      );

  Widget _getActionButton() => TextButton(
        onPressed: () {
          final List<T> distinctSelectedTexts = selectedItems.toSet().toList();
          Navigator.of(context).pop(distinctSelectedTexts);
        },
        child: const BaseText(
          'OK',
          // style: context.headline5.copyWith(color: context.primaryColor),
        ),
      );

  Widget _getList() => ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: localList.length,
        itemBuilder: _getSheetElement,
      );

  Widget _getSheetElement(BuildContext context, int index) => Padding(
        padding: EdgeInsets.only(top: context.height),
        child: Row(
          children: <Widget>[
            _getRadio(index),
            context.sizedW(.5),
            _getGestureDetector(index),
          ],
        ),
      );

  Widget _getRadio(int index) => CustomCheckboxTile(
        text: 'ads',
        initialValue: selectedItems.contains(localList[index]),
        onTap: (bool? val) => _chooseItem(index),
      );

  Widget _getGestureDetector(int index) => GestureDetector(
        onTap: () => _chooseItem(index),
        child: BaseText(localList[index].toString()),
      );

  Widget _getSearchForm() => Padding(
        padding: context.bottomPadding(Sizes.low),
        child: CustomTextField(
          onChanged: (String? val) {
            if (val == null) return;
            setState(() => searchText = val);
          },
          hintText: 'Search',
        ),
      );

  void _chooseItem(int index) {
    selectedItems.contains(localList[index])
        ? selectedItems.remove(localList[index])
        : selectedItems.add(localList[index]);
    setState(() {});
  }
}
