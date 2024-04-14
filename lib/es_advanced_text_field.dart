/*
 * Developed by Erratum Solutions
 * Contact us @ support@erratums.com
 * https://erratums.com
 * Date created: 14-Apr-2024
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ESTextField extends StatefulWidget {
  final String caption;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry margin;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final bool autofocus;
  final bool? readOnly;
  final String? prefixText;
  final String? suffixText;
  final IconData? iconData;
  final int maxLines;
  final List<IconData>? suffixIconDataList;
  final Function()? onPrefixTap;
  final Function(IconData iData)? onSuffixTap;
  final Map<IconData, String>? suffixIconTooltips;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final String? counterText;
  final String? errorText;
  final ESFieldDecoration? decoration;
  final TextEditingController controller;
  final Function()? onEditingComplete;
  final TextInputAction textInputAction;

  const ESTextField(
    this.caption, {
    Key? key,
    required this.controller,
    this.focusNode,
    this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    this.obscureText = false,
    this.autofillHints,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly,
    this.prefixText,
    this.suffixText,
    this.helperText,
    this.counterText,
    this.errorText,
    this.decoration,
    this.iconData,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.onPrefixTap,
    this.onSuffixTap,
    this.suffixIconTooltips,
    this.onChanged,
    this.onTap,
    this.suffixIconDataList,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  @override
  createState() => _ESTextFieldState();
}

class _ESTextFieldState extends State<ESTextField> {
  bool _isSuffixTap = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: TextField(
        key: widget.key,
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: widget.obscureText,
        autofillHints: widget.autofillHints,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly ?? false,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        decoration: _fieldDecoration,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: widget.textInputAction,
        onTap: () {
          if (_isSuffixTap) {
            // Suffix tap trigger onTap also. Stop onTap { Ajmal }
            _isSuffixTap = false;
          } else if (widget.onTap != null) {
            widget.onTap!();
          }
        },
      ),
    );
  }

  ESFieldDecoration get _fieldDecoration {
    return widget.decoration ??
        ESFieldDecoration(
          enabled: widget.enabled,
          iconData: widget.iconData,
          suffixIconDataList: widget.suffixIconDataList ?? const [Icons.cancel],
          suffixIconTooltips: widget.suffixIconTooltips,
          labelText: widget.caption,
          prefixText: widget.prefixText,
          suffixText: widget.suffixText,
          helperText: widget.helperText,
          counterText: widget.counterText,
          errorText: widget.errorText,
          onPrefixTap: widget.onPrefixTap,
          onSuffixTap: (IconData iData) => _doOnSuffixTap(iData),
        );
  }

  _doOnSuffixTap(IconData iData) {
    if (widget.onSuffixTap == null) {
      if (iData == Icons.cancel) {
        widget.controller.clear();
      }
    } else {
      widget.onSuffixTap!(iData);
    }
  }
}

class ESFieldDecoration extends InputDecoration {
  final IconData? iconData;
  final List<IconData> suffixIconDataList;
  final Function()? onPrefixTap;
  final Function(IconData iconData)? onSuffixTap;
  final Map<IconData, String>? suffixIconTooltips;

  const ESFieldDecoration({
    final String? labelText,
    final String? errorText,
    final String? prefixText,
    final String? suffixText,
    final String? helperText,
    final String? counterText,
    final bool enabled = true,
    final bool showLabelText = true,
    final InputBorder border = const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
    this.iconData,
    this.onPrefixTap,
    this.onSuffixTap,
    this.suffixIconTooltips,
    this.suffixIconDataList = const [Icons.cancel],
  }) : super(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.black),
          hintText: prefixText != null ? '' : labelText,
          labelText: showLabelText ? labelText : null,
        );

  @override
  Widget? get prefixIcon => iconData == null ? null : InkWell(canRequestFocus: false, onTap: onPrefixTap, child: Icon(iconData));

  @override
  Widget? get suffixIcon => () {
        if (!enabled) return null;

        Widget includeInTooltip(IconData aIconData, Widget aWidget) {
          if (aIconData == Icons.cancel) {
            return Tooltip(message: suffixIconTooltips?[aIconData] ?? 'Clear', child: aWidget);
          } else if (suffixIconTooltips != null && suffixIconTooltips!.containsKey(aIconData)) {
            return Tooltip(message: suffixIconTooltips![aIconData]!, child: aWidget);
          }
          return aWidget;
        }

        if (suffixIconDataList.length == 1) {
          return includeInTooltip(
            suffixIconDataList[0],
            InkWell(
              canRequestFocus: false,
              child: Icon(suffixIconDataList[0]),
              onTap: () {
                if (onSuffixTap != null) onSuffixTap!(suffixIconDataList[0]);
              },
            ),
          );
        }

        final List<Widget> buttonList = [];
        for (int iCntr = 0; iCntr < suffixIconDataList.length; iCntr++) {
          final IconData varIconData = suffixIconDataList[iCntr];
          buttonList.add(
            includeInTooltip(
              varIconData,
              InkWell(
                canRequestFocus: false,
                child: Padding(padding: EdgeInsets.only(left: 2.5, right: iCntr == suffixIconDataList.length - 1 ? 10 : 2.5), child: Icon(varIconData)),
                onTap: () {
                  if (onSuffixTap != null) onSuffixTap!(varIconData);
                },
              ),
            ),
          );
        }

        return IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttonList,
          ),
        );
      }();
}
