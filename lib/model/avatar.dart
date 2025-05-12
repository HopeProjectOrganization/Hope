class Avatar {
  static final List<Map<String, dynamic>> avatars = [
    {'id': 0, 'asset': 'assets/avatar/avatar9.png'},
    {'id': 1, 'asset': 'assets/avatar/avatar1.png'},
    {'id': 2, 'asset': 'assets/avatar/avatar2.png'},
    {'id': 3, 'asset': 'assets/avatar/avatar3.png'},
    {'id': 4, 'asset': 'assets/avatar/avatar4.png'},
    {'id': 5, 'asset': 'assets/avatar/avatar5.png'},
    {'id': 6, 'asset': 'assets/avatar/avatar6.png'},
    {'id': 7, 'asset': 'assets/avatar/avatar7.png'},
    {'id': 8, 'asset': 'assets/avatar/avatar8.png'},
  ];

  static String getAvatarById(String id) {
    int parsedId = int.tryParse(id) ?? -1;
    return avatars.firstWhere(
      (avatar) => avatar['id'] == parsedId,
      orElse: () => {'asset': 'assets/avatar/avatar5.png'},
    )['asset'];
  }
}
