import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/src/cupertino_settings_item.dart';

import 'defines.dart';

enum _SettingsTileType { simple, switchTile, sliderTile }

class SettingsTile extends StatelessWidget {
  final String title;
  final int? titleMaxLines;
  final String? subtitle;
  final int? subtitleMaxLines;
  final Widget? leading;
  final Widget? trailing;
  final Icon? iosChevron;
  final EdgeInsetsGeometry? iosChevronPadding;
  final VoidCallback? onTap;
  final Function(BuildContext context)? onPressed;
  final Function(bool value)? onToggle;
  final bool? switchValue;
  final bool enabled;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final Color? switchActiveColor;
  final _SettingsTileType _tileType;

  // Values for Slider
  final double? sliderValue;
  final ValueChanged<double>? sliderOnChanged;
  final ValueChanged<double>? sliderOnChangeStart;
  final ValueChanged<double>? sliderOnChangeEnd;
  final double? sliderMin;
  final double? sliderMax;
  final int? sliderDivisions;
  final Color? sliderActiveColor;
  final Color? sliderThumbColor;

  const SettingsTile({
    Key? key,
    required this.title,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.trailing,
    this.iosChevron = defaultCupertinoForwardIcon,
    this.iosChevronPadding = defaultCupertinoForwardPadding,
    @Deprecated('Use onPressed instead') this.onTap,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled = true,
    this.onPressed,
    this.switchActiveColor,
    this.sliderValue,
    this.sliderOnChanged,
    this.sliderOnChangeStart,
    this.sliderOnChangeEnd,
    this.sliderMin,
    this.sliderMax,
    this.sliderDivisions,
    this.sliderActiveColor,
    this.sliderThumbColor,
  })  : _tileType = _SettingsTileType.simple,
        onToggle = null,
        switchValue = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  const SettingsTile.switchTile({
    Key? key,
    required this.title,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.enabled = true,
    this.trailing,
    required this.onToggle,
    required this.switchValue,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.switchActiveColor,
    this.sliderValue = 0.5,
    this.sliderOnChanged,
    this.sliderOnChangeStart,
    this.sliderOnChangeEnd,
    this.sliderMin,
    this.sliderMax,
    this.sliderDivisions,
    this.sliderActiveColor,
    this.sliderThumbColor,
  })  : _tileType = _SettingsTileType.switchTile,
        onTap = null,
        onPressed = null,
        iosChevron = null,
        iosChevronPadding = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  const SettingsTile.sliderTile({
    Key? key,
    this.title = '',
    this.titleMaxLines,
    this.leading,
    this.enabled = true,
    this.trailing,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.switchActiveColor,
    this.subtitle,
    this.subtitleMaxLines,
    this.onToggle,
    this.switchValue,
    required this.sliderValue,
    this.sliderOnChanged,
    this.sliderOnChangeStart,
    this.sliderOnChangeEnd,
    this.sliderMin,
    this.sliderMax,
    this.sliderDivisions,
    this.sliderActiveColor,
    this.sliderThumbColor,
  })  : _tileType = _SettingsTileType.sliderTile,
        onTap = null,
        onPressed = null,
        iosChevron = null,
        iosChevronPadding = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(sliderDivisions == null || sliderDivisions > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return iosTile(context);
    } else if (Platform.isIOS || Platform.isMacOS) {
      return iosTile(context);
    } else {
      return androidTile(context);
    }
  }

  Widget iosTile(BuildContext context) {
    if (_tileType == _SettingsTileType.sliderTile) {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.slider,
        label: title,
        labelMaxLines: titleMaxLines,
        leading: leading,
        subtitle: subtitle,
        subtitleMaxLines: subtitleMaxLines,
        switchValue: switchValue,
        onToggle: onToggle,
        labelTextStyle: titleTextStyle,
        switchActiveColor: switchActiveColor,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
        trailing: trailing,
        sliderValue: sliderValue,
        sliderMax: sliderMax,
        sliderMin: sliderMin,
        sliderThumbColor: sliderThumbColor,
        sliderActiveColor: sliderActiveColor,
        sliderOnChangeStart: sliderOnChangeStart,
        sliderOnChangeEnd: sliderOnChangeEnd,
        sliderOnChanged: sliderOnChanged,
        sliderDivisions: sliderDivisions,
      );
    } else if (_tileType == _SettingsTileType.switchTile) {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.toggle,
        label: title,
        labelMaxLines: titleMaxLines,
        leading: leading,
        subtitle: subtitle,
        subtitleMaxLines: subtitleMaxLines,
        switchValue: switchValue,
        onToggle: onToggle,
        labelTextStyle: titleTextStyle,
        switchActiveColor: switchActiveColor,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
        trailing: trailing,
      );
    } else {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.modal,
        label: title,
        labelMaxLines: titleMaxLines,
        value: subtitle,
        trailing: trailing,
        iosChevron: iosChevron,
        iosChevronPadding: iosChevronPadding,
        hasDetails: false,
        leading: leading,
        onPress: onTapFunction(context) as void Function()?,
        labelTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
      );
    }
  }

  Widget androidTile(BuildContext context) {
    if (_tileType == _SettingsTileType.switchTile) {
      return SwitchListTile(
        secondary: leading,
        value: switchValue!,
        activeColor: switchActiveColor,
        onChanged: enabled ? onToggle : null,
        title: Text(
          title,
          style: titleTextStyle,
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleTextStyle,
                maxLines: subtitleMaxLines,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      );
    } else if (_tileType == _SettingsTileType.sliderTile) {
      if (title.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 72.0),
              child: Text(
                title,
                style: titleTextStyle,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              title: Slider(
                value: sliderValue ?? 0,
                min: sliderMin ?? 0,
                max: sliderMax ?? 1,
                onChangeStart: sliderOnChangeStart,
                onChangeEnd: sliderOnChangeEnd,
                onChanged: sliderOnChanged,
              ),
              leading: leading,
              enabled: enabled,
              trailing: trailing,
              onTap: onTapFunction(context) as void Function()?,
            ),
          ],
        );
      } else {
        return ListTile(
          title: Slider(
            value: sliderValue ?? 0,
            min: sliderMin ?? 0,
            max: sliderMax ?? 1,
            onChangeStart: sliderOnChangeStart,
            onChangeEnd: sliderOnChangeEnd,
            onChanged: sliderOnChanged,
          ),
          leading: leading,
          enabled: enabled,
          trailing: trailing,
          onTap: onTapFunction(context) as void Function()?,
        );
      }
    } else {
      return ListTile(
        title: Text(title, style: titleTextStyle),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleTextStyle,
                maxLines: subtitleMaxLines,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        leading: leading,
        enabled: enabled,
        trailing: trailing,
        onTap: onTapFunction(context) as void Function()?,
      );
    }
  }

  Function? onTapFunction(BuildContext context) =>
      onTap != null || onPressed != null
          ? () {
              if (onPressed != null) {
                onPressed!.call(context);
              } else {
                onTap!.call();
              }
            }
          : null;
}
