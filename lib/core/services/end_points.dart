class EndPoints {
  static String get login => '/api/v1/login';
  static String get profile => 'your-profile';
  static String get dashboard => 'dashboard';
  static String get payment => 'payment';
  static String get paymentDetail => 'payment-details';
  static String get customerPaymentDetail => 'customer/payment';
  static String get updateProfile => 'your-profile';
  static String get scanCard => '/api/v1/student/staff/scan-card';
  static String get attendanceRecord => '/api/v1/attendance-log/list';
  static String get attendanceSummary => '/api/v1/parent/attendance-summary';
  static String get parentProfile => '/api/v1/parent/profile';
  static String get sampleBooking => 'customer/booking-listing';
  static String get createBooking => 'customer/booking';
  static String get zone => 'customer/zone-listing';
  static String get bookingDetails => 'customer/booking';
  static String get contactUs => 'support';
  static String get tracking => '/api/v1/student/attendance/trackings';
  static String get sliders => '/api/v1/setting/sliders';
  static String get generalSetting => '/api/v1/setting/general';
  static String get classActivities => '/api/v1/setting/class/activities';
  static String classActivityDetails(int id) =>
      '/api/v1/setting/class/activities/$id/details';
  static String get deleteAccount => 'disable-user';
}
