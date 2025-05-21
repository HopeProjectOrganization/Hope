import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatefulWidget {
  final List<String>? items;
  final String? labelText; // حقل الـ label
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
    'Lymphoma'
  ];

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late ThemeProvider themeProvider;
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
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return DropdownButtonFormField<String>(
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
        labelText: widget.labelText ?? appLocalizations.typeOfCancer,
        labelStyle: Theme.of(context).primaryTextTheme.titleMedium,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select the type';
        }
        return null;
      },
    );
  }
}
