class OrgOfficer {
  const OrgOfficer({required this.name, required this.position});

  final String name;
  final String position;
}

class OrgEvent {
  const OrgEvent({
    required this.title,
    required this.date,
    required this.location,
  });

  final String title;
  final String date;
  final String location;
}

class BoothSlot {
  const BoothSlot({
    required this.time,
    required this.booth,
    required this.orgAcronym,
  });

  final String time;
  final String booth;
  final String orgAcronym;
}

const officersByOrg = <String, List<OrgOfficer>>{
  'csc': [
    OrgOfficer(name: 'Fritz Marick Fernandez', position: 'Chairman'),
    OrgOfficer(name: 'John Israel Mercado', position: 'Vice Chairman'),
    OrgOfficer(name: 'Justin Ace Ardena', position: 'Secretary'),
  ],
  'itso': [
    OrgOfficer(name: 'Mikaela Santos', position: 'Chairman'),
    OrgOfficer(name: 'Rafael Dela Cruz', position: 'Vice Chairman'),
    OrgOfficer(name: 'Janelle Flores', position: 'Secretary'),
  ],
  'robotics': [
    OrgOfficer(name: 'Kenneth Mac Rene Anas', position: 'Chairman'),
    OrgOfficer(name: 'Kenneth Mac Rene Anas', position: 'Vice Chairman'),
    OrgOfficer(name: 'Kenneth Mac Rene Anas', position: 'Secretary'),
  ],
  'ballers': [
    OrgOfficer(name: 'Enzo Ramirez', position: 'Captain'),
    OrgOfficer(name: 'Gabriel Torres', position: 'Vice Captain'),
    OrgOfficer(name: 'Noah Garcia', position: 'Manager'),
  ],
  'shuttle': [
    OrgOfficer(name: 'Alyssa Cruz', position: 'Chairman'),
    OrgOfficer(name: 'Miguel Reyes', position: 'Vice Chairman'),
    OrgOfficer(name: 'Sofia Lopez', position: 'Secretary'),
  ],
  'pixel': [
    OrgOfficer(name: 'Bea Navarro', position: 'Chairman'),
    OrgOfficer(name: 'Luis Bautista', position: 'Vice Chairman'),
    OrgOfficer(name: 'Celine Ramos', position: 'Secretary'),
  ],
  'tunog': [
    OrgOfficer(name: 'Trisha Mendoza', position: 'Chairman'),
    OrgOfficer(name: 'Jared Aquino', position: 'Music Director'),
    OrgOfficer(name: 'Nina Castillo', position: 'Secretary'),
  ],
  'tabang': [
    OrgOfficer(name: 'Ella Fernandez', position: 'Chairman'),
    OrgOfficer(name: 'Marco Villanueva', position: 'Vice Chairman'),
    OrgOfficer(name: 'Ysa Flores', position: 'Secretary'),
  ],
};

const eventsByOrg = <String, List<OrgEvent>>{
  'csc': [
    OrgEvent(
      title: 'Intro to Flutter Workshop',
      date: 'November 12, 2026 · 1:00 PM',
      location: 'CICT Computer Laboratory',
    ),
    OrgEvent(
      title: 'Campus Code Challenge',
      date: 'November 20, 2026 · 9:00 AM',
      location: 'CICT AVR',
    ),
  ],
  'itso': [
    OrgEvent(
      title: 'Build Your First Website',
      date: 'November 14, 2026 · 10:00 AM',
      location: 'CICT Computer Laboratory',
    ),
  ],
  'robotics': [
    OrgEvent(
      title: 'Robotics Open Lab',
      date: 'November 15, 2026 · 2:00 PM',
      location: 'Engineering Workshop',
    ),
  ],
  'ballers': [
    OrgEvent(
      title: 'Intramurals Tryouts',
      date: 'November 13, 2026 · 4:00 PM',
      location: 'WVSU Gymnasium',
    ),
  ],
  'shuttle': [
    OrgEvent(
      title: 'Saturday Badminton Rally',
      date: 'November 21, 2026 · 8:00 AM',
      location: 'WVSU Gymnasium',
    ),
  ],
  'pixel': [
    OrgEvent(
      title: 'Digital Art Jam',
      date: 'November 17, 2026 · 1:00 PM',
      location: 'CICT Media Room',
    ),
  ],
  'tunog': [
    OrgEvent(
      title: 'Acoustic Night',
      date: 'November 19, 2026 · 5:00 PM',
      location: 'University Amphitheater',
    ),
  ],
  'tabang': [
    OrgEvent(
      title: 'Community Digital Skills Day',
      date: 'November 22, 2026 · 8:00 AM',
      location: 'La Paz Community Center',
    ),
  ],
};

const boothSchedule = <BoothSlot>[
  BoothSlot(time: '8:00 AM', booth: 'A1', orgAcronym: 'CSC'),
  BoothSlot(time: '8:00 AM', booth: 'A2', orgAcronym: 'CB'),
  BoothSlot(time: '9:00 AM', booth: 'A1', orgAcronym: 'ITSO'),
  BoothSlot(time: '9:00 AM', booth: 'A2', orgAcronym: 'PAG'),
  BoothSlot(time: '10:00 AM', booth: 'B1', orgAcronym: 'CRC'),
  BoothSlot(time: '10:00 AM', booth: 'B2', orgAcronym: 'TC'),
  BoothSlot(time: '1:00 PM', booth: 'B1', orgAcronym: 'SS'),
  BoothSlot(time: '1:00 PM', booth: 'B2', orgAcronym: 'TV'),
];
