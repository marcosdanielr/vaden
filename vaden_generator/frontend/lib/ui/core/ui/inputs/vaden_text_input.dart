import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/colors.dart';

class VadenTextInput extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double height;
  final double width;
  final bool isFilled;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final TextStyle? labelStyle;
  final bool hasError;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnabled;

  const VadenTextInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
    this.height = 56,
    this.width = double.infinity,
    this.isFilled = true,
    this.onChanged,
    this.autovalidateMode,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.labelStyle,
    this.hasError = false,
    this.inputFormatters,
    this.isEnabled = true,
  });

  @override
  State<VadenTextInput> createState() => _VadenTextInputState();
}

class _VadenTextInputState extends State<VadenTextInput> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: widget.height,
      width: widget.width,
      constraints: const BoxConstraints(minHeight: 56),
      child: TextFormField(
        autovalidateMode: widget.autovalidateMode,
        enabled: widget.isEnabled,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        style: widget.isEnabled
            ? theme.textTheme.bodyLarge
            : theme.textTheme.bodyLarge!.copyWith(
                color: VadenColors.txtDisabled,
              ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          labelText: widget.label,
          labelStyle: widget.labelStyle ??
              theme.textTheme.bodyLarge!.copyWith(
                color: widget.isEnabled ? VadenColors.whiteColor : VadenColors.txtDisabled,
              ),
          hintText: widget.hint,
          hintStyle: widget.labelStyle ??
              theme.textTheme.bodyLarge!.copyWith(
                color: widget.isEnabled ? VadenColors.txtSupport : VadenColors.txtDisabled,
              ),
          border: OutlineInputBorder(
            borderSide: widget.hasError
                ? const BorderSide(color: VadenColors.errorColor, width: 1)
                : const BorderSide(color: VadenColors.txtSupport2, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: VadenColors.txtSupport2, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: widget.hasError
                ? const BorderSide(color: VadenColors.errorColor, width: 1)
                : const BorderSide(color: VadenColors.txtSupport2, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: widget.hasError
                ? const BorderSide(color: VadenColors.errorColor, width: 1)
                : const BorderSide(color: VadenColors.whiteColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: VadenColors.errorColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: VadenColors.errorColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: const TextStyle(
            color: VadenColors.errorColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
