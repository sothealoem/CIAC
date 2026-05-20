import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';

class ActivityController extends GetxController {
  final RxBool isSubmittingActivity = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isDetailLoading = false.obs;
  final RxList<ClassActivityItem> activities = <ClassActivityItem>[].obs;
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxInt perPage = 10.obs;
  final RxInt total = 0.obs;

  bool get isTeacherRole => !UserRepository.shared.isDriver;
  bool get hasMorePages => currentPage.value < lastPage.value;

  @override
  void onInit() {
    super.onInit();
    fetchClassActivities();
  }

  Future<void> fetchClassActivities({bool reset = true}) async {
    if (reset) {
      if (isLoading.value) return;
    } else {
      if (isLoading.value || isLoadingMore.value || !hasMorePages) return;
    }

    try {
      if (reset) {
        isLoading.value = true;
        currentPage.value = 1;
      } else {
        isLoadingMore.value = true;
      }

      final res = await Get.find<ApiService>().get(
        EndPoints.classActivities,
        queryParameters: <String, dynamic>{'page': currentPage.value},
        isShowLoading: false,
      );

      if (res.data is! Map) {
        if (reset) {
          activities.clear();
        }
        return;
      }

      final root = Map<String, dynamic>.from(res.data as Map);
      final data = root['data'];
      if (data is! Map) {
        if (reset) {
          activities.clear();
        }
        return;
      }

      final list = data['data'];
      if (list is! List) {
        if (reset) {
          activities.clear();
        }
        return;
      }

      currentPage.value = (data['current_page'] as num?)?.toInt() ?? 1;
      lastPage.value =
          (data['last_page'] as num?)?.toInt() ?? currentPage.value;
      perPage.value = (data['per_page'] as num?)?.toInt() ?? perPage.value;
      total.value = (data['total'] as num?)?.toInt() ?? list.length;

      final List<ClassActivityItem> parsed =
          list.whereType<dynamic>().map((e) {
            if (e is Map<String, dynamic>) {
              return ClassActivityItem.fromJson(e);
            }
            if (e is Map) {
              return ClassActivityItem.fromJson(Map<String, dynamic>.from(e));
            }
            return const ClassActivityItem(
              id: 0,
              title: '',
              image: '',
              description: '',
              timeText: '',
            );
          }).where((e) => e.image.isNotEmpty || e.title.isNotEmpty).toList();

      if (reset) {
        activities.assignAll(parsed);
      } else {
        activities.addAll(
          parsed.where(
            (item) => !activities.any((existing) => existing.id == item.id),
          ),
        );
      }
    } catch (e) {
      ExceptionHandler.handleException(e);
      if (reset) {
        activities.clear();
      }
    } finally {
      if (reset) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMoreActivities() async {
    if (!hasMorePages) return;
    currentPage.value += 1;
    await fetchClassActivities(reset: false);
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

  Future<ClassActivityItem?> createActivity({
    required String title,
    required String description,
    String imagePath = '',
  }) async {
    final trimmedTitle = title.trim();
    final trimmedDescription = description.trim();
    final trimmedImagePath = imagePath.trim();

    if (trimmedTitle.isEmpty) {
      throw Exception('Activity title is required');
    }

    final formMap = <String, dynamic>{
      'title': trimmedTitle,
      'description': trimmedDescription,
    };

    if (trimmedImagePath.isNotEmpty) {
      final file = await d.MultipartFile.fromFile(trimmedImagePath);
      formMap['image'] = file;
      formMap['file'] = file;
    }

    final payload = d.FormData.fromMap(formMap);

    try {
      isSubmittingActivity.value = true;
      final res = await Get.find<ApiService>().post(
        EndPoints.teacherActivities,
        payload,
        isShowLoading: false,
      );

      final rawData = getPropertyFromJson(res.data, 'data');
      if (rawData is Map) {
        final created = ClassActivityItem.fromJson(
          Map<String, dynamic>.from(rawData),
        );
        await fetchClassActivities();
        return created;
      }

      await fetchClassActivities();
      return null;
    } finally {
      isSubmittingActivity.value = false;
    }
  }
}

class ClassActivityItem {
  const ClassActivityItem({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.timeText,
  });

  final int id;
  final String title;
  final String image;
  final String description;
  final String timeText;

  factory ClassActivityItem.fromJson(Map<String, dynamic> json) {
    return ClassActivityItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString().trim(),
      image: (json['image'] ?? '').toString().trim(),
      description: (json['description'] ?? '').toString().trim(),
      timeText: _firstNonEmpty(<dynamic>[
        json['time'],
        json['time_text'],
        json['activity_time'],
        json['created_at'],
        json['createdAt'],
        json['create_date'],
        json['created_date'],
        json['updated_at'],
        json['updatedAt'],
        json['update_date'],
        json['date'],
        json['publish_date'],
      ]),
    );
  }

  static String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = (value ?? '').toString().trim();
      if (text.isNotEmpty && text.toLowerCase() != 'null') {
        return text;
      }
    }
    return '';
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
