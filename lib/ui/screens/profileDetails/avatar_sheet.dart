import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';

class AvatarSheet extends StatefulWidget {
  final String? selectedAvatarAsset;

  const AvatarSheet({super.key, this.selectedAvatarAsset});

  @override
  State<AvatarSheet> createState() => _AvatarSheetState();
}

class _AvatarSheetState extends State<AvatarSheet> {
  String? selectedAvatarAsset;
  String? selectedAvatarId;

  @override
  void initState() {
    super.initState();
    selectedAvatarAsset = widget.selectedAvatarAsset;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: Avatar.avatars.length,
              itemBuilder: (context, index) {
                final avatar = Avatar.avatars[index];
                bool isSelected = avatar['asset'] == selectedAvatarAsset;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatarAsset = avatar['asset'];
                      selectedAvatarId = avatar['id'].toString();
                    });

                    Navigator.pop(
                      context,
                      {
                        'asset': selectedAvatarAsset,
                        'id': selectedAvatarId,
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.purple.withOpacity(0.6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.purple,
                        width: 3,
                      ),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        avatar['asset'],
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
