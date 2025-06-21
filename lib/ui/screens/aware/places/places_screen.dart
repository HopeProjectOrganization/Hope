import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/places/places_service.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/places_dm.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesScreen extends StatefulWidget {
  static const routeName = '/places';

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String searchQuery = "";
  List<PlaceModel> places = [];
  bool isLoading = true;
  late AppLocalizations appLocalizations;
  late ThemeProvider themeProvider;
  final PlacesApiService apiService = PlacesApiService();

  @override
  void initState() {
    super.initState();
    fetchAllPlaces();
  }

  void fetchAllPlaces() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedPlaces = await apiService.fetchAllPlaces();
      setState(() {
        places = fetchedPlaces;
        isLoading = false;
      });
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
    themeProvider = Provider.of<ThemeProvider>(context);

    final filteredPlaces = places.where((place) {
      return place.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.Teal,
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
                prefixIcon: Icon(Icons.search, color: AppColors.Teal),
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
                        return Card(
                          color: AppColors.cloudi,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                                  child: (place.image.isEmpty)
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall),
                                      (place.website == null ||
                                              place.website.isEmpty)
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () async {
                                                final url = place.website;
                                                if (url != null &&
                                                    url.isNotEmpty) {
                                                  final uri = Uri.parse(url);
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(
                                                      Uri.parse(place.website),
                                                      mode: LaunchMode
                                                          .externalApplication,
                                                    );
                                                  } else {
                                                    print(
                                                        'Could not launch $url');
                                                  }
                                                } else {
                                                  print('No website available');
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
                                        child:
                                            buildRow(Icons.phone, place.phone),
                                      ),
                                      GestureDetector(
                                  onTap: () async {
                                          final url = place.location;
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                    }
                                  },
                                        child: buildRow(
                                            Icons.location_on, place.address),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: themeProvider.isDark() ? AppColors.white : AppColors.dark),
          const SizedBox(width: 5),
          Expanded(
              child: Text(
            text,
          )),
        ],
      ),
    );
  }
}
