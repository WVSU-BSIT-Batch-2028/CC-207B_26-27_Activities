class Officer {
  const Officer(this.name, this.role);

  final String name;
  final String role;
}

class ScheduleSlot {
  const ScheduleSlot(this.time, this.booth, this.orgId);

  final String time;
  final String booth;
  final String orgId;
}

const Map<String, List<Officer>> officersByOrg = {
  'csc': [
    Officer('Andrea Villanueva', 'President'),
    Officer('Mark Gonzales', 'Vice President'),
    Officer('Lea Panes', 'Secretary'),
  ],
  'itso': [
    Officer('Paolo Reyes', 'President'),
    Officer('Kim Salazar', 'Treasurer'),
  ],
  'robotics': [
    Officer('Gian Tolentino', 'Captain'),
    Officer('Ria Sumagaysay', 'Lead Builder'),
  ],
  'ballers': [
    Officer('Jose Ledesma', 'Team Captain'),
    Officer('Carlo Tan', 'Manager'),
  ],
  'shuttle': [
    Officer('Bea Javellana', 'President'),
    Officer('Nico Lim', 'Coach'),
  ],
  'pixel': [
    Officer('Ysa Montinola', 'President'),
    Officer('Dan Espinosa', 'Creative Director'),
    Officer('Mia Gerochi', 'Photo Lead'),
  ],
  'tunog': [
    Officer('Rafa Delgado', 'Band Leader'),
    Officer('Joy Araneta', 'Choir Director'),
  ],
  'tabang': [
    Officer('Ana Locsin', 'Coordinator'),
    Officer('Ben Siason', 'Volunteer Lead'),
  ],
};

const List<ScheduleSlot> boothSchedule = [
  ScheduleSlot('8:00 AM', 'A1', 'csc'),
  ScheduleSlot('8:00 AM', 'A2', 'ballers'),
  ScheduleSlot('9:00 AM', 'A1', 'itso'),
  ScheduleSlot('9:00 AM', 'A2', 'pixel'),
  ScheduleSlot('10:00 AM', 'B1', 'robotics'),
  ScheduleSlot('10:00 AM', 'B2', 'tunog'),
  ScheduleSlot('1:00 PM', 'B1', 'shuttle'),
  ScheduleSlot('1:00 PM', 'B2', 'tabang'),
];
