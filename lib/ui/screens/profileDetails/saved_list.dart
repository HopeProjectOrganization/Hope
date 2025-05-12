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
  ];


  int selectedDateIndex = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: AppColors.purple,
          title: const Text("Saved List", style: TextStyle(color: AppColors.white)),
          bottom: const TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: -10, vertical: 5),
            tabs: [
              Tab(text: "Posts"),
              Tab(text: "Recipes"),
              Tab(text: "all"),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTaskListView(),
                  _buildTaskListView(),
                  _buildTaskListView(),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        _buildSection("Today", tasks.sublist(0, 2)),
        const SizedBox(height: 10),
        _buildSection("Yesterday", tasks.sublist(2)),
        const SizedBox(height: 10),
        _buildSection("Last weak", tasks.sublist(1)),
      ],
    );
  }

  Widget _buildSection(String title, List<Task> sectionTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title (${sectionTasks.length})",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...sectionTasks.map((task) => _buildTaskItem(task)),
      ],
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
