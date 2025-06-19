import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class Task {
  final String type;
  final String title;

  Task({required this.type, required this.title});
}

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  List<Task> tasks = [
    Task(type: "Hereditary", title: "Update Blog"),
    Task(type: "Awareness", title: "Finalize Presentation"),
    Task(type: "Healthy diet", title: "Book Flights To Seattle"),
    Task(type: "High risk people", title: "Buy Travel Insurance"),
    Task(type: "Awareness", title: "Campaign Planning"),
  ];

  String? selectedType; // null = All

  List<String> get types => tasks.map((e) => e.type).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: AppColors.purple,
          title: const Text("Saved List", style: TextStyle(color: AppColors.white)),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                child: Text("Filter by Type", style: TextStyle(fontSize: 20)),
              ),
              ListTile(
                title: const Text("All"),
                onTap: () {
                  setState(() {
                    selectedType = null;
                    Navigator.pop(context);
                  });
                },
              ),
              ...types.map((type) => ListTile(
                    title: Text(type),
                    onTap: () {
                      setState(() {
                        selectedType = type;
                        Navigator.pop(context);
                      });
                    },
                  )),
            ],
          ),
        ),
        body: Column(
          children: [
            if (selectedType != null)
              Container(
                width: double.infinity,
                color: AppColors.lavender.withOpacity(0.2),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filtered by: $selectedType"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedType = null;
                        });
                      },
                      child: const Text("Clear Filter"),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Expanded(child: _buildGroupedTasksView()),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedTasksView() {
    final List<Task> filteredTasks = selectedType == null
        ? tasks
        : tasks.where((task) => task.type == selectedType).toList();

    // Group tasks
    Map<String, List<Task>> groupedTasks = {};
    for (var task in filteredTasks) {
      groupedTasks.putIfAbsent(task.type, () => []).add(task);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: groupedTasks.entries.map((entry) {
        final String type = entry.key;
        final List<Task> sectionTasks = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$type (${sectionTasks.length})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...sectionTasks.map((task) => _buildTaskItem(task)).toList(),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        setState(() {
          tasks.remove(task);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              color: AppColors.lavender,
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.type, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(task.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
