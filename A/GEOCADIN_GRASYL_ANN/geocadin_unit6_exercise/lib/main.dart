import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),

      home: const HomeShell(),

    );
  }
}






class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  final pages = const [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: "My Pet",
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: "Gallery",
          ),
        ],
      ),
    );
  }
}

// PHOTO MODEL

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'Chanyeol',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'Xiumin',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'Kyungsoo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'Baekhyun',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'Sehun',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'Suho',
  ),
];


// GALLERY SCREEN

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            InkWell(
              onTap: () => _open(photo),
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                      ),
                    ),
                  ),
                  if (favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


// PHOTO DETAIL SCREEN

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.star),
              label: const Text('Make favorite'),
            ),
          ),
        ],
      ),
    );
  }
}
// PROFILE MODEL

class ProfileInfo {


  final IconData icon;

  final String label;

  final String value;



  const ProfileInfo({

    required this.icon,

    required this.label,

    required this.value,

  });

}







// INFO TILE

class InfoTile extends StatelessWidget {


  final ProfileInfo info;



  const InfoTile({

    super.key,

    required this.info,

  });



  @override
  Widget build(BuildContext context) {


    return Card(

      child: ListTile(

        leading: Icon(info.icon),

        title: Text(info.label),

        subtitle: Text(info.value),

      ),

    );

  }
}








// PROFILE SCREEN
// CLASS SCHEDULE MODEL

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
}


// PROFILE SCREEN

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> infos = const [
    ProfileInfo(
      icon: Icons.school,
      label: "Course",
      value: "Bachelor of Science in Information Technology",
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: "Location",
      value: "Iloilo, Philippines",
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: "Skills",
      value: "Flutter, Dart, Programming",
    ),
    ProfileInfo(
      icon: Icons.star,
      label: "Favorite",
      value: "Technology and creating apps",
    ),
  ];

  final List<String> hobbies = const [
    "Coding",
    "Music",
    "Watching movies",
    "Photography",
    "Gaming",
    "Reading",
  ];

  final List<ClassSlot> classes = const [
    ClassSlot(
      day: "Mon",
      time: "7:00 AM",
      subject: "Human Computer Interaction 2",
    ),
    ClassSlot(
      day: "Tue",
      time: "9:00 AM",
      subject: "App Development",
    ),
    ClassSlot(
      day: "Wed",
      time: "10:00 AM",
      subject: "IT Project Management",
    ),
    ClassSlot(
      day: "Thu",
      time: "1:00 PM",
      subject: "Technopreneurship",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grasyl Ann Geocadin"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: "Photo of Grasyl Ann Geocadin",
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      "assets/images/profile.jpg",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grasyl Ann Geocadin",
                          style: theme.textTheme.headlineSmall,
                        ),
                        const Text(
                          "Aspiring IT professional and technology enthusiast.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Information",
              style: theme.textTheme.titleLarge,
            ),

            for (final info in infos)
              InfoTile(info: info),

            // HOBBIES CHIPS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Hobbies",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies)
                          Chip(
                            label: Text(hobby),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // CLASS SCHEDULE TABLE
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Class Schedule",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: theme.dividerColor,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(55),
                        1: FixedColumnWidth(85),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final heading in [
                              "Day",
                              "Time",
                              "Subject",
                            ])
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  heading,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (final slot in classes)
                          TableRow(
                            children: [
                              for (final value in [
                                slot.day,
                                slot.time,
                                slot.subject,
                              ])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(value),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // BIOGRAPHY
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Biography",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "I am a BSIT student who enjoys "
                      "learning programming and developing "
                      "applications using technology.",
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








// PET SCREEN


// PET SCREEN

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer player = AudioPlayer();

  bool playing = false;
  bool heart = false;
  int count = 0;

  @override
  void initState() {
    super.initState();

    player.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        playing = false;
      });
    });
  }

  Future<void> playSound() async {
    setState(() {
      playing = true;
      count++;
    });

    try {
      await player.play(
        AssetSource("sounds/pet_sound.mp3"),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        playing = false;
      });
    }
  }

  Future<void> _confirmReset() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Reset the count?"),
          content: const Text(
            "Are you sure you want to reset the bark count?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      count = 0;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pet"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  heart = !heart;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/pet.jpg",
                      height: 260,
                      width: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (heart)
                    const Icon(
                      Icons.favorite,
                      size: 80,
                      color: Colors.red,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: playing ? null : playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(
                playing ? "Playing..." : "Play Pet Sound",
              ),
            ),
            const SizedBox(height: 10),
            Text("My pet has made a sound $count times."),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: count == 0 ? null : _confirmReset,
              child: const Text("Reset count"),
            ),
          ],
        ),
      ),
    );
  }
}