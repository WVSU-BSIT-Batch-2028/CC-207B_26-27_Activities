// 5.1 Dart Basics: variables, type inference, final/const, null safety.
// Run it: paste into https://dartpad.dev, or `dart run 01_variables_and_null_safety.dart`.

void main() {
  // ---- Data types ----
  int age = 20; // whole numbers
  double gwa = 1.75; // decimal numbers
  bool isEnrolled = true; // true / false
  String name = 'Juan'; // text
  print('$name is $age years old, GWA $gwa, enrolled: $isEnrolled');

  // ---- Type inference with var ----
  var course = 'BSCS'; // Dart infers String
  course = 'BSIT'; // OK: still a String
  // course = 3;     // ERROR: a String variable can't hold an int
  print('Course: $course');

  // dynamic can change type at runtime. Use sparingly!
  dynamic anything = 10;
  anything = 'now a String';
  print('dynamic value: $anything');

  // ---- final vs const ----
  final DateTime enrolledAt = DateTime.now(); // set once, at runtime
  const double pi = 3.14159; // known at compile time
  print('Enrolled at $enrolledAt, pi = $pi');

  // final means the VARIABLE can't be reassigned,
  // but the object it points to can still change:
  final List<String> subjects = ['CC 206'];
  subjects.add('CC 207'); // OK
  // subjects = [];     // ERROR: can't reassign a final variable
  print('Subjects: $subjects');

  // ---- Null safety ----
  // By default, variables can NOT be null.
  // String middleName = null; // ERROR
  String? middleName = findMiddleName('Juan'); // add ? to allow null
  print('Middle name: $middleName'); // null

  // ?? gives a fallback value when something is null
  print('Middle name or default: ${middleName ?? 'N/A'}');

  // ?. only calls the member when the value is not null
  print('Middle name length: ${middleName?.length}'); // null, no crash

  middleName = findMiddleName('Maria');
  // After a null check, Dart "promotes" the type to non-nullable String:
  if (middleName != null) {
    print('Middle initial: ${middleName[0]}');
  }

  // ! says "trust me, this is not null". It crashes if you are wrong,
  // so prefer ?? or an if-check when you can.
  String? nickname = getNickname(true);
  print('Nickname: ${nickname!.toUpperCase()}');

  // ??= assigns only if the variable is currently null
  String? section;
  section ??= 'A';
  print('Section: $section');

  // late: "I promise to assign this before I use it"
  late String greeting;
  greeting = 'Magandang umaga, $name!';
  print(greeting);

  // ---- Multiline strings ----
  const String motto = '''
West Visayas State University
College of ICT
''';
  print(motto);
}

String? findMiddleName(String first) => first == 'Maria' ? 'Santos' : null;

String? getNickname(bool hasNickname) => hasNickname ? 'Jun' : null;
