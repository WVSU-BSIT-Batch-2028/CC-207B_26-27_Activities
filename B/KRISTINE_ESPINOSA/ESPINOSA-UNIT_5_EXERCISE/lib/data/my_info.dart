import 'package:flutter/material.dart';

import '../models/profile_info.dart';

const String fullName = 'Kristine Joy Espinosa';
const String tagline = 'BSIT student who is building apps.'; 
const String profilePhoto = 'assets/images/me.jpg';

const List<ProfileInfo> infos = [
  ProfileInfo(
    icon: Icons.school,
    label: 'Course',
    value: 'BS Information Technology, 3-B',
  ),
  ProfileInfo(
    icon: Icons.account_balance,
    label: 'School',
    value: 'West Visayas State University, CICT',
  ),
  ProfileInfo(
    icon: Icons.location_on,
    label: 'Location',
    value: 'Iloilo City, Philippines', 
  ),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'espinosakristine27@gmail.com',
  ),
  ProfileInfo(
    icon: Icons.interests,
    label: 'Hobbies',
    value: 'Coding, Music, Sports', 
  ),
];

const String biography =
    'I am Kristine Joy Espinosa, a third-year BS Information Technology '
    'student at West Visayas State University, College of Information and '
    'Communications Technology. I enjoy turning ideas into working apps and '
    'websites, and I am currently learning Flutter to build mobile apps. '
    'Outside of class, I like spending time with my pet and exploring new '
    'things in tech and design.';

const String petName = 'Yuki';
const String petAnimal = 'dog';
const String petSoundVerb = 'barked'; 
const String petPhoto = 'assets/images/pet.jpeg';
const String petSound = 'sounds/dog_sound.mp3';
