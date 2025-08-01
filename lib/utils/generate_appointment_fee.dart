double generateAppointmentFee(String specialization) {
  //randomly generate appointment fee based on specialization
  switch (specialization) {
    case 'Allergist':
      return 50 + (100 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Anesthesiologist':
      return 100 + (150 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Cardiologist':
      return 120 + (180 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Dermatologist':
      return 70 + (130 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Endocrinologist':
      return 80 + (140 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Gastroenterologist':
      return 90 + (160 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Hematologist':
      return 110 + (170 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Disease Specialist':
      return 60 + (120 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Internist':
      return 75 + (135 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Medical Geneticist':
      return 85 + (145 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Nephrologist':
      return 95 + (155 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Neurologist':
      return 105 + (165 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Gynecologist':
      return 65 + (125 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Oncologist':
      return 130 + (190 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Ophthalmologist':
      return 115 + (175 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Orthopedic Surgeon':
      return 140 + (200 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Otolaryngologist':
      return 125 + (185 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Pediatrician':
      return 55 + (115 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Physiatrist':
      return 135 + (195 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Plastic Surgeon':
      return 150 + (210 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    case 'Podiatrist':
      return 145 + (205 * (0.5 + (0.5 * (DateTime.now().second % 2))));
    default:
      return 50 + (100 * (0.5 + (0.5 * (DateTime.now().second % 2))));
  }
}
