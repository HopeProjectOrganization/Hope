import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomDropDown extends StatefulWidget {
  final List<String>? items;
  final String? labelText;
  final String? initialValue;
  final void Function(String?)? onChanged;

  const CustomDropDown({
    super.key,
    this.items,
    this.labelText,
    this.initialValue,
    this.onChanged,
  });

  static const List<String> defaultCancerTypes = [
    'Liver',
    'Breast',
    'Prostate',
    'Skin',
    'Lymphoma',
  ];

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late AppLocalizations appLocalizations;
  late List<String> finalItems;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    finalItems = widget.items ?? CustomDropDown.defaultCancerTypes;
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    appLocalizations = AppLocalizations.of(context)!;

    return DropdownButtonFormField<String>(
      dropdownColor: !isDark ? AppColors.cloudi : AppColors.Teal,
      value: selectedValue,
      items: finalItems.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: AppColors.Teal, // أو أي لون يناسبك
          fontSize: 16,
        ),
        labelText: widget.labelText ?? appLocalizations.typeOfCancer,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return appLocalizations.selectType;
        }
        return null;
      },
    );
  }
}
