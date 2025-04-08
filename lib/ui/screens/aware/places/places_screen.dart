import 'package:flutter/material.dart';
import 'package:hope/Api/places/fetch_places.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/places_dm.dart';

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
      "logo": AppAssets.places
    },
    {
      "name": "Baheya Hospital",
      "website": "www.baheya.org",
      "phone": "+20 2 33927460",
      "address": "Off El Haram Street, Next to Dairy & Abiba Square, Giza",
      "logo": AppAssets.healthyDiet
    },
  ];

  String searchQuery = "";

  PlaceModel? place;

  @override
  void initState() {
    super.initState();
    fetchPlaceById("2").then((value) {
      setState(() {
        place = value;
      });
    });
  }

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
            place == null
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView(
                      children: [
                        Card(
                          color: AppColors.lavender,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Row(
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
                                          place!.name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        buildRow(Icons.language,
                                            place!.website ?? 'No website'),
                                        buildRow(Icons.phone, place!.phone),
                                        buildRow(
                                            Icons.location_on, place!.address),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
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
