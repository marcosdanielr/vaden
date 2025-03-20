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
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnabled;
  final double verticalPadding;

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
    this.errorText,
    this.inputFormatters,
    this.isEnabled = true,
    this.verticalPadding = 12,
  });

  @override
  State<VadenTextInput> createState() => _VadenTextInputState();
}

class _VadenTextInputState extends State<VadenTextInput> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
                ? theme.textTheme.bodyLarge!.copyWith(
                    color: VadenColors.whiteColor,
                  )
                : theme.textTheme.bodyLarge!.copyWith(
                    color: VadenColors.txtDisabled,
                  ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding,
                horizontal: 12,
              ),
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
              // Removemos o errorText da decoração para exibi-lo separadamente
              errorStyle: const TextStyle(
                height: 0,
                color: Colors.transparent,
              ),
              border: OutlineInputBorder(
                borderSide: (widget.hasError || widget.errorText != null)
                    ? const BorderSide(color: VadenColors.errorColor, width: 1)
                    : const BorderSide(color: VadenColors.txtSupport2, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: VadenColors.txtSupport2, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: (widget.hasError || widget.errorText != null)
                    ? const BorderSide(color: VadenColors.errorColor, width: 1)
                    : const BorderSide(color: VadenColors.txtSupport2, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: (widget.hasError || widget.errorText != null)
                    ? const BorderSide(color: VadenColors.errorColor, width: 1)
                    : const BorderSide(color: VadenColors.whiteColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: VadenColors.errorColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // Exibimos o texto de erro separadamente
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              widget.errorText!,
              style: theme.textTheme.bodySmall!.copyWith(
                color: VadenColors.errorColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
