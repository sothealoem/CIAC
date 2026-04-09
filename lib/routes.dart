import 'package:get/get.dart';
import 'package:swis_school/views/dashboard/biding.dart';
import 'package:swis_school/views/student_document/view.dart';
import 'package:swis_school/views/views.dart';

class Routes {
  static const String root = '/';
  static const String start = '/start';
  static const String language = '/language';
  static const String termCondition = '/termCondition';
  static const String contactUs = '/contactUs';
  static const String paymentDetail = '/payment-detail';
  static const String changePassword = '/change-password';
  static const String login = '/login';
  static const String loginVaiEmail = '/login-via-email';
  static const String register = '/register';
  static const String finishDelivery = '/finish-delivery';
  static const String notification = '/notification';
  static const String createSampleBooking = '/create-sample-booking';
  static const String createPackagesBooking = '/create-packages-booking';
  static const String successfulRegisterd = '/successful-registerd';
  static const String bookingDetails = '/booking-details';
  static const String paymentCollection = '/payment_collection';
  static const String requestLeave = '/request_leave';
  static const String standings = '/standings';
  static const String schedule = '/schedule';
  static const String attendance = '/attendance';
  static const String studentInforation = '/studentInforation';
  static const String studentDocument = '/studentDocument';
  static const String onlineCourses = '/onlineCourses';
  static const String eventGallery = '/eventGallery';
  static const String dashbord = '/dashbord';

  static List<GetPage> pages = [
    GetPage(
      name: root,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: start,
      page: () => const StartView(),
      binding: StartBinding(),
    ),
    GetPage(
      name: language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(name: termCondition, page: () => const TermConditionView()),
    GetPage(
      name: contactUs,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: changePassword,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: paymentCollection,
      page: () => const PaymentCollectionView(),
      binding: PaymentCollectionBinding(),
    ),
    GetPage(
      name: requestLeave,
      page: () => const RequestLeaveView(),
      binding: RequestLeaveBinding(),
    ),
    GetPage(
      name: standings,
      page: () => const StandingsView(),
      binding: StandingsBinding(),
    ),
    GetPage(
      name: schedule,
      page: () => const ScheduleView(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: attendance,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: studentDocument,
      page: () => const StudentDocumentView(),
      binding: StudentInformationBinding(),
    ),
    GetPage(
      name: onlineCourses,
      page: () => const OnlineCoursesView(),
      binding: OnlineCoursesBinding(),
    ),
    GetPage(
      name: eventGallery,
      page: () => const EventGalleryView(),
      binding: EventGalleryBinding(),
    ),
    GetPage(
      name: dashbord,
      page: () => const DashboardView(),
      binding: DashbordBinding(),
    ),
  ];
}
