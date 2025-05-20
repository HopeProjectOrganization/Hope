import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Admin/aware/places/admin_places_edit.dart';
import 'package:hope/Api/places/fetch_places.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/places_dm.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PlacesAdminScreen extends StatefulWidget {
  static const routeName = '/adminPlaces';

  @override
  _PlacesAdminScreenState createState() => _PlacesAdminScreenState();
}

class _PlacesAdminScreenState extends State<PlacesAdminScreen> {
  String searchQuery = "";
  late AppLocalizations appLocalizations;
  List<PlaceModel> places = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllPlaces();
  }

  void deletePlace(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.4:8081/Places/$id'),
    );
    print('Delete response status: ${response.statusCode}');
    if (response.statusCode == 204) {
      setState(() {
        places.removeWhere((place) => place.id == id);
      });
      print('Place removed. Remaining count: ${places.length}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hospital deleted successfully')),
      );
    } else {
      print('Failed to delete: ${response.statusCode}');
    }
  }

  void fetchAllPlaces() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedPlaces = await fetchAllPlacesFromApi();
      setState(() {
        places = fetchedPlaces;
        isLoading = false;
      });
      print("Fetched places count: ${places.length}");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;

    final filteredPlaces = places.where((place) {
      return place.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.purple,
        centerTitle: true,
        title: Text(
          appLocalizations.cancerTreatmentPlaces,
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
                hintText: appLocalizations.search,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Body content
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = filteredPlaces[index];
                        return Stack(
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: (place.image == null ||
                                              place.image.isEmpty)
                                          ? Image.asset(
                                              AppAssets.hospital,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              place.image,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          (place.website == null ||
                                                  place.website.isEmpty)
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    final url = place.website;
                                                    if (url.isNotEmpty &&
                                                        await canLaunchUrl(
                                                            Uri.parse(url))) {
                                                      await launchUrl(
                                                          Uri.parse(url),
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    }
                                                  },
                                                  child: buildRow(
                                                      Icons.language,
                                                      place.website),
                                                ),
                                          GestureDetector(
                                            onTap: () async {
                                              final tel = "tel:${place.phone}";
                                              if (await canLaunchUrl(
                                                  Uri.parse(tel))) {
                                                await launchUrl(Uri.parse(tel));
                                              }
                                            },
                                            child: buildRow(
                                                Icons.phone, place.phone),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final url = place.location;
                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url));
                                              }
                                            },
                                            child: buildRow(Icons.location_on,
                                                place.address),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // زر الحذف العلوي
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: AppColors.gray),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this hospital?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            deletePlace(place.id);
                                            setState(() {
                                              places.removeWhere(
                                                  (p) => p.id == place.id);
                                            });
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminAddHospitalScreen()),
          );

          if (result == true) {
            fetchAllPlaces();
          }
        },
        backgroundColor: AppColors.purple,
        child: const Icon(
          Icons.add,
          color: AppColors.lavender,
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
