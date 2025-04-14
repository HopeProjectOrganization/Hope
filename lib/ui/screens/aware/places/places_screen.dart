import 'package:flutter/material.dart';
import 'package:hope/Api/places/fetch_places.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/places_dm.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesScreen extends StatefulWidget {
  static const routeName = '/places';

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String searchQuery = "";
  PlaceModel? place;

  @override
  void initState() {
    super.initState();
    fetchPlaceById("1").then((value) {
      print("Fetched place: ${value?.name}");
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
          icon: const Icon(Icons.arrow_back_outlined),
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
            const SizedBox(height: 16),
            // Body content
            Expanded(
              child: place == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        Card(
                          color: AppColors.lavender,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // الصورة
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    place!.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // التفاصيل
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place!.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final url = place!.website;
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          }
                                        },
                                        child: buildRow(
                                            Icons.language, place!.website),
                                      ),
                                      buildRow(Icons.phone, place!.phone),
                                      GestureDetector(
                                        onTap: () async {
                                          final url = place!.location;
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          }
                                        },
                                        child: buildRow(
                                            Icons.location_on, place!.address),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

  Widget buildRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.dark),
          const SizedBox(width: 5),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}