import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatefulWidget {
  static String? cancerType;
  static final List<String> cancerTypes = [
    'Liver',
    'Breast',
    'Prostate',
    'Skin',
    'Lymphoma'
  ];

  const CustomDropDown({
    super.key,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late ThemeProvider themeProvider;

  late AppLocalizations appLocalizations;

  late bool isChecked;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      value: CustomDropDown.cancerType,
      items: CustomDropDown.cancerTypes.map((String type) {
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
          CustomDropDown.cancerType = value!;
        });
      },
      decoration: InputDecoration(
        labelText: appLocalizations.typeOfCancer,
        labelStyle: Theme.of(context).primaryTextTheme.titleMedium,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select the type of cancer';
        }
        return null;
      },
    );
  }
}
