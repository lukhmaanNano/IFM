import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends DropdownButton2<T> {
  final ScrollController? scrollController;
  final void Function()? onTap;

  CustomDropdownButton({
    Key? key,
    required List<DropdownMenuItem<T>>? items,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    void Function(T?)? onChanged,
    TextStyle? style,
    Widget? underline,
    bool isDense = false,
    bool isExpanded = false,
    FocusNode? focusNode,
    bool autofocus = false,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    ButtonStyleData? buttonStyleData,
    IconStyleData iconStyleData = const IconStyleData(),
    DropdownStyleData dropdownStyleData = const DropdownStyleData(),
    MenuItemStyleData menuItemStyleData = const MenuItemStyleData(),
    DropdownSearchData<T>? dropdownSearchData,
    Widget? customButton,
    bool openWithLongPress = false,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    this.scrollController,
    this.onTap,
    required Container child,
  }) : super(
          key: key,
          items: items,
          value: value,
          hint: hint,
          disabledHint: disabledHint,
          onChanged: onChanged,
          style: style,
          underline: underline,
          isDense: isDense,
          isExpanded: isExpanded,
          focusNode: focusNode,
          autofocus: autofocus,
          enableFeedback: enableFeedback,
          alignment: alignment,
          buttonStyleData: buttonStyleData,
          iconStyleData: iconStyleData,
          dropdownStyleData: dropdownStyleData,
          menuItemStyleData: menuItemStyleData,
          dropdownSearchData: dropdownSearchData,
          customButton: customButton,
          openWithLongPress: openWithLongPress,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
        );

  @override
  State<DropdownButton2<T>> createState() {
    return _CustomDropdownButtonState<T>();
  }
}

class _CustomDropdownButtonState<T> extends DropdownButton2State<T> {
  @override
  Widget build(BuildContext context) {
    final scrollController = (widget as CustomDropdownButton).scrollController;

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (scrollController != null) {
          if (scrollController.position.extentAfter == 0) {
            widget.onMenuStateChange?.call(false);
          }
        }
        return true;
      },
      child: super.build(context),
    );
  }
}
