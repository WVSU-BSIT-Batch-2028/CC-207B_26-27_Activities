import 'package:flutter/material.dart';

import '../models/class_slot.dart';
import '../models/photo.dart';
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
    icon: Icons.pets,
    label: 'Pet',
    value: 'Yuki, my dog',
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

const List<String> hobbies = [
  'Coding',
  'Music',
  'Sports',
  'UI Design',
  'Playing with Yuki',
  'Playing Pickleball',
];

const List<ClassSlot> classSlots = [
  ClassSlot(day: 'Mon', time: '8:00 - 10:00', subject: 'CC 207B Application Development'),
  ClassSlot(day: 'Tue', time: '10:00 - 12:00', subject: 'CC 208 Methods of Research in Computing'),
  ClassSlot(day: 'Wed', time: '1:00 - 3:00', subject: 'CIT 213 Human Computer Interaction 2'),
  ClassSlot(day: 'Thu', time: '8:00 - 10:00', subject: 'CIT 246 IT Project Management'),
  ClassSlot(day: 'Fri', time: '1:00 - 3:00', subject: 'BA 234 Technopreneurship'),
];

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Me'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'Yuki'),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Me and Yuki'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Yuki New Haircut'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Yuki Playing'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Me and Yukibells'),
];
