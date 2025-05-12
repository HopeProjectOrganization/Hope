import 'package:flutter/material.dart';

class Task {
  final String time;
  final String title;
  final bool isDone;

  Task({required this.time, required this.title, this.isDone = false});
}

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  List<Task> tasks = [
    Task(time: "14:00", title: "Update Blog"),
    Task(time: "13:00", title: "Finalize Presentation", isDone: true),
    Task(time: "09:00", title: "Book Flights To Seattle", isDone: true),
    Task(time: "11:00", title: "Buy Travel Insurance", isDone: true),
  ];

  final List<String> weekdays = ["MON", "TUE", "WED", "THU", "FRI"];
  final List<String> dates = ["21", "22", "23", "24", "25"];
  int selectedDateIndex = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التبويبات
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Saved List"),
          bottom: const TabBar(
            labelColor: Colors.purple,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Posts"),
              Tab(text: "Recipes"),
              Tab(text: "Other"),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildCalendar(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          const Text("AUGUST 2017",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekdays.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedDateIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedDateIndex = index);
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(weekdays[index],
                            style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black)),
                        const SizedBox(height: 4),
                        Text(dates[index],
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    isSelected ? Colors.white : Colors.black)),
                      ],
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

  Widget _buildTaskListView() {
    return ListView(
      children: [
        _buildSection("TO DO", false),
        _buildSection("DONE", true),
      ],
    );
  }

  Widget _buildSection(String title, bool done) {
    final sectionTasks = tasks.where((task) => task.isDone == done).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title (${sectionTasks.length})",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...sectionTasks.map((task) => _buildTaskItem(task, done)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, bool done) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
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
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              color: done ? Colors.green : Colors.orange,
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.time, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(task.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (done) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
