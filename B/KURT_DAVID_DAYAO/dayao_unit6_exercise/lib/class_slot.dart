class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });

  final String day;
  final String time;
  final String subject;
}

// Replace these entries with your actual class schedule.
const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Tues and Thurs',
    time: '11:30 AM - 1:00 PM',
    subject: 'Technopreneurship (BA 234)',
  ),
  ClassSlot(
    day: 'Tues and Thurs',
    time: '7:00-10:00 AM',
    subject: 'Web System and Technologies (CIT 210)',
  ),
  ClassSlot(
    day: 'Mon and Wed',
    time: '3:00-6:00 PM',
    subject: 'Application Development and Emerging Technologies (CC 207B)',
  ),
  ClassSlot(
    day: 'Mon and Wed',
    time: '9:00 AM - 12:00 PM',
    subject: 'IT Project Management (CIT 246)',
  ),
];
