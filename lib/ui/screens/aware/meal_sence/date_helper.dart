import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class DateHelper {
  static String getMonthName(int month) {
    const months = [
      "", // index 0 placeholder
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month];
  }

  static String getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }

  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static double calculateScrollOffset({
    required int selectedIndex,
    required int totalDays,
    required double itemWidth,
    required double screenWidth,
  }) {
    double targetScrollOffset =
        (itemWidth * selectedIndex) - (screenWidth / 2) + (itemWidth / 2);
    if (targetScrollOffset < 0) return 0;

    double maxScrollExtent = (itemWidth * totalDays) - screenWidth;
    if (targetScrollOffset > maxScrollExtent) return maxScrollExtent;

    return targetScrollOffset;
  }

  static List<DateTime> getWeekDates() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // Monday = 1
    DateTime monday = today.subtract(Duration(days: currentWeekday - 1));
    return List.generate(5, (index) => monday.add(Duration(days: index)));
  }
}

class MyCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const MyCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<MyCalendarWidget> createState() => MyCalendarWidgetState();
}

class MyCalendarWidgetState extends State<MyCalendarWidget> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  final ScrollController _scrollController = ScrollController();

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
  }

  void _scrollToSelectedDay() {
    const double itemWidth = 68; // عرض العنصر مع الحواف padding/margin
    final screenWidth = MediaQuery.of(context).size.width;
    final daysCount =
        DateHelper.getDaysInMonth(selectedDate.year, selectedDate.month);
    final selectedIndex = selectedDate.day - 1;

    final offset = DateHelper.calculateScrollOffset(
      selectedIndex: selectedIndex,
      totalDays: daysCount,
      itemWidth: itemWidth,
      screenWidth: screenWidth,
    );

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildDay(String day, String date, bool isSelected,
      {bool isToday = false}) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lavender : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isToday ? Border.all(color: AppColors.Teal, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? AppColors.Teal : AppColors.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? AppColors.Teal : AppColors.dark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        "${DateHelper.getMonthName(selectedDate.month)} ${selectedDate.year}",
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.Teal),
      ),
    );
  }

  Widget _buildDaysOfMonth(int year, int month, int selectedDay) {
    int daysCount = DateHelper.getDaysInMonth(year, month);
    DateTime today = DateTime.now();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: daysCount,
        itemBuilder: (context, index) {
          int day = index + 1;
          DateTime date = DateTime(year, month, day);
          String dayName = DateHelper.getWeekdayName(date.weekday);
          String dayDate = day.toString().padLeft(2, '0');

          bool isSelected = day == selectedDay;
          bool isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
                widget.onDateChanged(date); // ⬅️ هنا نستدعي callback
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToSelectedDay();
                });
              },
              child: _buildDay(dayName, dayDate, isSelected, isToday: isToday),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildMonthYearHeader(),
        _buildDaysOfMonth(
            selectedDate.year, selectedDate.month, selectedDate.day),
      ],
    );
  }
}
