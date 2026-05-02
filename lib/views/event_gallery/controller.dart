import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';

class ActivityController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isDetailLoading = false.obs;
  final RxList<ClassActivityItem> activities = <ClassActivityItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClassActivities();
  }

  Future<void> fetchClassActivities() async {
    try {
      isLoading.value = true;

      final res = await Get.find<ApiService>().get(
        EndPoints.classActivities,
        isShowLoading: false,
      );

      if (res.data is! Map) {
        activities.clear();
        return;
      }

      final root = Map<String, dynamic>.from(res.data as Map);
      final data = root['data'];
      if (data is! Map) {
        activities.clear();
        return;
      }

      final list = data['data'];
      if (list is! List) {
        activities.clear();
        return;
      }

      final parsed =
          list.whereType<dynamic>().map((e) {
            if (e is Map<String, dynamic>) {
              return ClassActivityItem.fromJson(e);
            }
            if (e is Map) {
              return ClassActivityItem.fromJson(Map<String, dynamic>.from(e));
            }
            return const ClassActivityItem(id: 0, title: '', image: '');
          }).where((e) => e.image.isNotEmpty || e.title.isNotEmpty).toList();

      activities.assignAll(parsed);
    } catch (e) {
      ExceptionHandler.handleException(e);
      activities.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<ClassActivityDetailItem?> fetchClassActivityDetail(int id) async {
    isDetailLoading.value = true;
    try {
      final res = await Get.find<ApiService>().get(
        EndPoints.classActivityDetails(id),
        isShowLoading: false,
      );

      if (res.data is! Map) return null;
      final map = Map<String, dynamic>.from(res.data as Map);
      final data = map['data'];
      if (data is! Map) return null;

      return ClassActivityDetailItem.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      ExceptionHandler.handleException(e);
      return null;
    } finally {
      isDetailLoading.value = false;
    }
  }
}

class ClassActivityItem {
  const ClassActivityItem({
    required this.id,
    required this.title,
    required this.image,
  });

  final int id;
  final String title;
  final String image;

  factory ClassActivityItem.fromJson(Map<String, dynamic> json) {
    return ClassActivityItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString().trim(),
      image: (json['image'] ?? '').toString().trim(),
    );
  }
}

class ClassActivityDetailItem {
  const ClassActivityDetailItem({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  final int id;
  final String title;
  final String image;
  final String description;

  factory ClassActivityDetailItem.fromJson(Map<String, dynamic> json) {
    return ClassActivityDetailItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString().trim(),
      image: (json['image'] ?? '').toString().trim(),
      description: (json['description'] ?? '').toString().trim(),
    );
  }
}
