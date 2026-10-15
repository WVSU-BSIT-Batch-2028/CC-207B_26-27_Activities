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

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: pages[selectedIndex],


      bottomNavigationBar: NavigationBar(

        selectedIndex: selectedIndex,


        onDestinationSelected: (index){

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

class ProfileScreen extends StatelessWidget {


  const ProfileScreen({super.key});



  final List<ProfileInfo> infos = const [


    ProfileInfo(

      icon: Icons.school,

      label: "Course",

      value: "Bachelor of Science in Information Technology",

    ),


    ProfileInfo(

      icon: Icons.favorite,

      label: "Hobbies",

      value: "Coding, Music, Watching movies",

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





  @override
  Widget build(BuildContext context) {


    final theme = Theme.of(context);



    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Grasyl Ann Geocadin",
        ),

      ),



      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),



        child: Column(


          children: [



            Semantics(

              label: "Photo of Grasyl Ann Geocadin",


              child: Row(

                children: [


                  const CircleAvatar(

                    radius: 45,


                    backgroundImage:

                    AssetImage(

                      "assets/images/profile.jpg",

                    ),

                  ),



                  const SizedBox(width:20),



                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,


                      children: [


                        Text(

                          "Grasyl Ann Geocadin",

                          style:
                          theme.textTheme.headlineSmall,

                        ),



                        const Text(

                          "Aspiring IT professional and technology enthusiast.",

                        ),


                      ],

                    ),

                  )

                ],

              ),

            ),




            const SizedBox(height:25),



            Text(

              "Information",

              style: theme.textTheme.titleLarge,

            ),




            for(final info in infos)

              InfoTile(info: info),





            Card(

              child: Padding(

                padding:
                const EdgeInsets.all(16),


                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children: [


                    Text(

                      "My Biography",

                      style:
                      theme.textTheme.titleLarge,

                    ),



                    const Text(

                      "I am a BSIT student who enjoys "
                      "learning programming and developing "
                      "applications using technology.",

                    )

                  ],

                ),

              ),

            )

          ],

        ),

      ),

    );

  }

}









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

  void initState(){

    super.initState();


    player.onPlayerComplete.listen((event){

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



    await player.play(

      AssetSource(

        "sounds/pet_sound.mp3"

      )

    );

  }






  @override

  void dispose(){

    player.dispose();

    super.dispose();

  }







  @override

  Widget build(BuildContext context) {



    return Scaffold(


      appBar: AppBar(

        title: const Text("My Pet"),

      ),



      body: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [



          GestureDetector(


            onDoubleTap: (){


              setState(() {

                heart = !heart;

              });


            },



            child: Stack(


              alignment: Alignment.center,


              children: [



                ClipRRect(

                  borderRadius:
                  BorderRadius.circular(20),


                  child: Image.asset(

                    "assets/images/pet.jpg",


                    height:300,

                    width:300,

                    fit:BoxFit.cover,


                  ),

                ),




                if(heart)

                  const Icon(

                    Icons.favorite,

                    size:80,

                    color:Colors.red,

                  )


              ],

            ),

          ),





          const SizedBox(height:20),





          FilledButton.icon(

            onPressed:
            playing ? null : playSound,


            icon:
            const Icon(Icons.volume_up),


            label: Text(

              playing
                  ? "Playing..."
                  : "Play Pet Sound",

            ),

          ),





          const SizedBox(height:10),





          Text(

            "My pet has made a sound $count times.",

          )

        ],

      ),

    );

  }

}