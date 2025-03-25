import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';

class PlacesScreen extends StatefulWidget {
  static const routeName = '/places';

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<Map<String, String>> hospitals = [
    {
      "name": "Children Cancer Hospital 57357",
      "website": "www.57357.org",
      "phone": "+20 2 25351500",
      "address": "1 St, Seket El Emam, Sayeda Zeinab, Cairo",
      "image": AppAssets.places
    },
    {
      "name": "Baheya Hospital",
      "website": "www.baheya.org",
      "phone": "+20 2 33927460",
      "address": "Off El Haram Street, Next to Dairy & Abiba Square, Giza",
      "image": AppAssets.healthyDiet
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.purple,
        centerTitle: true,
        title: Text(
          "Cancer treatment places",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColors.purple),
                hintText: "Search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16),
            // List of Hospitals
            Expanded(
              child: ListView.builder(
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = hospitals[index];
                  if (searchQuery.isNotEmpty &&
                      !hospital["name"]!.toLowerCase().contains(searchQuery)) {
                    return SizedBox();
                  }
                  return Card(
                      color: AppColors.lavender,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        hospital["name"]!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      buildRow(
                                          Icons.language, hospital["website"]!),
                                      buildRow(Icons.phone, hospital["phone"]!),
                                      buildRow(Icons.location_on,
                                          hospital["address"]!),
                                    ],
                                  )),
                              SizedBox(width: 12),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          hospital["image"]!,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      // Location Icon
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            child: IconButton(
                                              icon: Icon(Icons.place,
                                                  color: AppColors.dark),
                                              onPressed: () {},
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: AppColors.purple),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String website) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.dark),
        SizedBox(
          width: 5,
        ),
        Expanded(child: Text(website)),
      ],
    );
  }
}
