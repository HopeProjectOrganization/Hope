import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/home_tab/utls/recent_scan_provider.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:provider/provider.dart';

class MostRecentScan extends StatefulWidget {
  const MostRecentScan({super.key});

  @override
  State<MostRecentScan> createState() => _MostRecentScanState();
}

class _MostRecentScanState extends State<MostRecentScan> {
  late RecentScannedProductsProvider provider;

  @override
  void initState() {
    super.initState();

    /// يتم استدعاؤه بعد اكتمال الـ `build`
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMostRecentScans();
    });
  }

  Future<void> fetchMostRecentScans() async {
    await provider.refreshRecentScannedProducts();
    setState(() {}); // تحديث الواجهة
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<RecentScannedProductsProvider>(context);

    print("Recent Scanned Products: ${provider.recentScannedProducts}");

    return provider.recentScannedProducts.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Most Recently Scanned",
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .25,
                child: ListView.builder(
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return buildMostRecentProductWidget(
                        provider.recentScannedProducts[index]);
                  },
                ),
              ),
            ],
          );
  }

  Widget buildMostRecentProductWidget(String product) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          TextButton(
            child: Text(
              "Go to result",
              style: TextStyle(fontSize: 14, color: AppColors.purple),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                ResultScreen.routeName,
                arguments: product,
              );
            },
          ),
        ],
      ),
    );
  }
}
