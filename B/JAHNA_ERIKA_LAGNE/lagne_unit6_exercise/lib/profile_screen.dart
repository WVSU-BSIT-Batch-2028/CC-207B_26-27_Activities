import 'package:flutter/material.dart';

// Pastel pink palette
const Color kPinkLight = Color(0xFFFFF0F7); // card background
const Color kPinkMid = Color(0xFFFFCAE9); // borders, chips
const Color kPinkRow = Color(0xFFFFF8FB); // alternate table rows
const Color kInk = Color(0xFF5B3A4B); // soft mauve text

class ClassSlot {
  final String day;
  final String time;
  final String subject;
  const ClassSlot(this.day, this.time, this.subject);
}

const List<ClassSlot> schedule = [
  ClassSlot("Mon", "9:00am-6:00pm", "CIT 251 - CIT 212 - CC 207B"),
  ClassSlot("Tue", "7:00am-6:00pm", "CIT 210 - BA 234 - CC 208 - CIT 213"),
  ClassSlot("Wed", "10:00am-6:00pm", "CIT 251 - CIT 212 - CC 207B"),
  ClassSlot("Thu", "7:00am-6:00pm", "CIT 210 - BA 234 - CC 208 - CIT 213"),
];

const List<String> hobbies = [
  "Reading",
  "Sleeping",
  "Watching Documentaries",
  "Doomscrolling",
  "Eating",
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 202, 233),
        title: const Text(
          "Hi! This is My Profile",
          style: TextStyle(
            color: Color.fromARGB(255, 41, 41, 41),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/photo.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    semanticLabel: "Photo of You",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("I'm Jahna Erika Lagne",
                          style: Theme.of(context).textTheme.headlineSmall),
                      const Text("Ang Mahalaga Umuusad ka!"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ...[
              ProfileInfo(Icons.cake, "Birthdate", "May 31, 2006"),
              ProfileInfo(Icons.pin_drop, "Address", "Pavia, Iloilo, Philippines"),
              ProfileInfo(Icons.email, "Email", "jahnaerika.lagne@wvsu.edu.ph"),
              ProfileInfo(Icons.school, "Education", "WEST VISAYAS STATE UNIVERSITY"),
            ].map((info) => InfoTile(info: info)),
            const SizedBox(height: 20),

            // Part C-a: Hobbies as chips (pastel pink)
            Card(
              color: kPinkLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: kPinkMid, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Color(0xFFF48FB1), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          "My Hobbies",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: kInk,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies)
                          Chip(
                            label: Text(hobby),
                            labelStyle: const TextStyle(color: kInk),
                            backgroundColor: kPinkMid,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              color: const Color.fromARGB(255, 255, 202, 233),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Wanna know Me?",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    const Text(
                      "I was born and grew up in Santolan, Pasig City, but I moved to Iloilo back in 2020. Life here feels calmer and more comfortable compared to the busy city. My hobbies are simple — I like reading, sleeping, watching documentaries, doomscrolling, and of course eating. I enjoy reading thriller, fantasy, and romance stories whenever I get free time. I also spend a lot of time scrolling on TikTok, and I usually end my nights watching documentaries before bed. It’s just my way of mixing fun, curiosity, and relaxation every day.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Part C-b: Class schedule as a Table (pastel pink)
            Card(
              color: kPinkLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: kPinkMid, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            color: Color(0xFFF48FB1), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          "My Class Schedule",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: kInk,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Table(
                        border: TableBorder.all(
                          color: kPinkMid,
                          width: 1.2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(56),
                          1: FixedColumnWidth(125),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          // Header row: colour comes from the theme
                          TableRow(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Day",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: kInk)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: kInk)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Subject",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: kInk)),
                              ),
                            ],
                          ),
                          // One row per class, alternating soft tints
                          for (final (i, slot) in schedule.indexed)
                            TableRow(
                              decoration: BoxDecoration(
                                color: i.isEven ? Colors.white : kPinkRow,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(slot.day,
                                      style: const TextStyle(color: kInk)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(slot.time,
                                      style: const TextStyle(color: kInk)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(slot.subject,
                                      style: const TextStyle(color: kInk)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;
  const ProfileInfo(this.icon, this.label, this.value);
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;
  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // spacing between rows
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 41, 41, 41), // background color
        borderRadius: BorderRadius.circular(8), // rounded corners
      ),
      child: ListTile(
        leading: Icon(info.icon, color: const Color.fromARGB(255, 255, 202, 233)),
        title: Text(info.label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        textColor: Colors.white,
        subtitle: Text(info.value),
      ),
    );
  }
}