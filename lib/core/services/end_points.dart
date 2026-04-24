class EndPoints {
  static String get login => '/api/v1/login';
  static String get profile => 'your-profile';
  static String get dashboard => 'dashboard';
  static String get payment => 'payment';
  static String get paymentDetail => 'payment-details';
  static String get customerPaymentDetail => 'customer/payment';
  static String get delivery => 'delivery-listing';
  static String get finishDelivery => 'delivery/payment-at-confirm';
  static String get reason => 'delivery/reason/kh';
  static String get updateProfile => 'your-profile';
  static String get scanGetProduct => 'delivery/scan/get-product';
  static String get scanComplete => 'delivery/scan/completed';
  static String get scanCard => '/api/v1/student/staff/scan-card';
  static String get attendanceRecord => '/api/v1/attendance-log/list';
  static String get customerDelivery => 'customer/delivery-list';
  static String get sampleBooking => 'customer/booking-listing';
  static String get createBooking => 'customer/booking';
  static String get zone => 'customer/zone-listing';
  static String get bookingDetails => 'customer/booking';
  static String get contactUs => 'support';
  static String get tracking => 'delivery-tracking';
  static String get deleteAccount => 'disable-user';
}
