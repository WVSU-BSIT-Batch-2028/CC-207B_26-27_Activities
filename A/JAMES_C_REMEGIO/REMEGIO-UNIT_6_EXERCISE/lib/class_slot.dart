/// One class meeting in the schedule table.
///
/// [subject] is the Subject cell: code, full name, and room.
class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.time,
    required this.code,
    required this.name,
    required this.room,
  });

  final String day;
  final String time;
  final String code;
  final String name;
  final String room;

  String get subject => '$code — $name · $room';
}
