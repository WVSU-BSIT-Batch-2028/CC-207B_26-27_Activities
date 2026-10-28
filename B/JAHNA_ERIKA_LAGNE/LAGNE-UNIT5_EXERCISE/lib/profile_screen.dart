import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 202, 233),
        title: const Text("Hi! This is My Profile",
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
              ProfileInfo(Icons.favorite, "Hobbies", "Reading, Sleeping, Watching Documentaries, Doomscrolling, Eating"),
            ].map((info) => InfoTile(info: info)),
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

