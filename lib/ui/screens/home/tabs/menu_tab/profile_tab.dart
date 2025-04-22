// import 'package:flutter/material.dart';
// import 'package:hope/Api/profile/profile_service.dart';
// import 'package:hope/core/theme/app_colors.dart';
// import 'package:hope/model/get_profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class ProfileTab extends StatefulWidget {
//   const ProfileTab({super.key});
//
//   @override
//   State<ProfileTab> createState() => _ProfileTabState();
// }
//
// class _ProfileTabState extends State<ProfileTab> {
//   late AppLocalizations appLocalizations;
//   GetUserProfileData? userProfile;
//   bool isLoading = true;
//   String? token;
//   int historyCount = 0;
//   int wishListCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchToken();
//   }
//
//   Future<void> fetchToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedToken = prefs.getString('auth_token');
//
//     if (storedToken != null) {
//       token = storedToken;
//       await fetchUserProfile(storedToken);
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> fetchUserProfile(String token) async {
//     final service = GetUserProfile();
//     final data = await service.fetchUserProfile(token);
//
//     if (mounted && data != null) {
//       setState(() {
//         userProfile = data;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     appLocalizations = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("profile"),
//         backgroundColor: AppColors.purple,
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(color: AppColors.purple),
//       )
//           : userProfile == null
//           ? const Center(
//         child: Text("Failed to load profile"),
//       )
//           : _buildProfileContent(),
//     );
//   }
//
//   Widget _buildProfileContent() {
//     final profile = userProfile!.data;
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: CircleAvatar(
//               radius: 50,
//               backgroundImage: NetworkImage(
//                   "https://via.placeholder.com/150"), // صورة افتراضية
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildInfoRow("Name", profile?.role ?? "N/A"),
//           _buildInfoRow("Email", profile?.email ?? "N/A"),
//           _buildInfoRow("Phone", profile?.phone ?? "N/A"),
//           const SizedBox(height: 20),
//           _buildTabBar(),
//           SizedBox(height: 300, child: _buildTabView()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             "$label: ",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabBar() {
//     return Container(
//       color: AppColors.lavender,
//       child: const TabBar(
//         indicatorColor: AppColors.purple,
//         labelColor: AppColors.purple,
//         unselectedLabelColor: Colors.grey,
//         tabs: [
//           Tab(icon: Icon(Icons.list), text: "List"),
//           Tab(icon: Icon(Icons.folder), text: "Saved"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabView() {
//     return const TabBarView(
//       children: [
//         Center(child: Text("List Items")),
//         Center(child: Text("Saved Items")),
//       ],
//     );
//   }
// }
