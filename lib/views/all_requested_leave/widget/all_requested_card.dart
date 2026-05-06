import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/resources/locales.g.dart';
import 'package:schoolapp/models/requestleave/model.dart';
import 'package:schoolapp/views/all_requested_leave/widget/custom_tab.dart';
import 'package:schoolapp/views/request_leave/controller.dart';
import 'package:schoolapp/views/request_leave/view.dart';

class AllRequestedCard extends StatefulWidget {
  const AllRequestedCard({super.key});

  @override
  State<AllRequestedCard> createState() => _AllRequestedCardState();
}

class _AllRequestedCardState extends State<AllRequestedCard> {
  int selectedIndex = 0;
  int _tabMotion = 1;
  final controller =
      Get.isRegistered<RequestLeaveController>()
          ? Get.find<RequestLeaveController>()
          : Get.put(RequestLeaveController());

  @override
  void initState() {
    super.initState();
    controller.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity.abs() < 120) {
              return;
            }
            if (velocity < 0) {
              _changeTab(selectedIndex + 1);
            } else {
              _changeTab(selectedIndex - 1);
            }
          },
          child: Column(
            children: [
              CustomTopTabBar(
                selectedIndex: selectedIndex,
                onChanged: _changeTab,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingRequests.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<RequestLeaveModel> list = [];

                  if (selectedIndex == 0) {
                    list = controller.requests.toList();
                  } else if (selectedIndex == 1) {
                    list =
                        controller.requests
                            .where((e) => _statusOf(e) == LocaleKeys.pending.tr)
                            .toList();
                  } else if (selectedIndex == 2) {
                    list =
                        controller.requests
                            .where((e) => _statusOf(e) == 'approved')
                            .toList();
                  } else {
                    list =
                        controller.requests
                            .where((e) => _statusOf(e) == 'rejected')
                            .toList();
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final beginX = _tabMotion > 0 ? 0.08 : -0.08;
                      final offset = Tween<Offset>(
                        begin: Offset(beginX, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(position: offset, child: child),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey<int>(selectedIndex),
                      child: RefreshIndicator(
                        onRefresh: controller.fetchRequests,
                        child:
                            list.isEmpty
                                ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(top: 120),
                                  children: const [
                                    Center(child: Text('No data')),
                                  ],
                                )
                                : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount: list.length,
                                  itemBuilder:
                                      (context, index) =>
                                          _buildCard(list[index]),
                                ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF0F6B5B),
            onPressed: () async {
              final result = await Get.to(() => const RequestLeaveView());
              if (!mounted) {
                return;
              }
              if (result is RequestLeaveModel) {
                if (!_hasSameRequest(result)) {
                  controller.requests.insert(0, result);
                }
                setState(() => selectedIndex = 1);
                return;
              }
              if (result == 'pending') {
                setState(() => selectedIndex = 1);
                return;
              }
              await controller.fetchRequests();
            },
            label: const Text(
              "ស្នើសុំច្បាប់",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(RequestLeaveModel item) {
    final status = _statusOf(item);
    final statusColor = _statusColor(status);
    final statusBg = _statusBackground(status);
    final statusLabel = _statusLabel(status);
    final fallbackName = controller.studentNameText.value.trim();
    final fallbackGrade = controller.studentGradeText.value.trim();
    final rawName = (item.name ?? '').trim();
    final rawGrade = (item.grade ?? '').trim();
    final name =
        _isPlaceholderName(rawName)
            ? (fallbackName.isEmpty ? 'Student' : fallbackName)
            : rawName;
    final grade = _isValidGrade(rawGrade) ? rawGrade : fallbackGrade;
    final showGrade = _isValidGrade(grade);
    final titleText = showGrade ? '$name - $grade' : name;
    final start = (item.dateStart ?? '').trim();
    final end = (item.dateEnd ?? '').trim();
    final reason = (item.reason ?? '').trim();
    final reasonText = reason.isEmpty ? '-' : reason;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  titleText.isEmpty ? 'Student' : titleText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Battambang',
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$start  ដល់  $end',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Battambang',
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFF0F8A80)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  reasonText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    border: Border.all(color: const Color(0xFF0F8A80)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'មូលហេតុ',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF065F5B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'approved') {
      return const Color(0xFF2E7D32);
    }
    if (status == 'rejected') {
      return const Color(0xFFC62828);
    }
    return const Color(0xFFB7791F);
  }

  Color _statusBackground(String status) {
    if (status == 'approved') {
      return const Color(0xFFE8F5E9);
    }
    if (status == 'rejected') {
      return const Color(0xFFFFEBEE);
    }
    return const Color(0xFFFFF7E6);
  }

  String _statusLabel(String status) {
    if (status == 'approved') {
      return 'អនុម័ត';
    }
    if (status == 'rejected') {
      return 'បដិសេធ';
    }
    return 'កំពុងរង់ចាំ';
  }

  bool _isValidGrade(String value) {
    final v = value.trim().toLowerCase();
    if (v.isEmpty) {
      return false;
    }
    return v != 'n/a' && v != 'na' && v != 'null' && v != '-';
  }

  bool _isPlaceholderName(String value) {
    final v = value.trim().toLowerCase();
    if (v.isEmpty) {
      return true;
    }
    return v == 'student' || v == 'n/a' || v == 'na' || v == 'null' || v == '-';
  }

  String _statusOf(RequestLeaveModel model) {
    final raw = (model.status ?? '').toLowerCase().trim();
    if (raw.contains('pending') || raw == '0' || raw.contains('wait')) {
      return 'pending';
    }
    if (raw.contains('approve') || raw == '1') {
      return 'approved';
    }
    if (raw.contains('reject') || raw == '2' || raw.contains('deny')) {
      return 'rejected';
    }
    return raw;
  }

  bool _hasSameRequest(RequestLeaveModel target) {
    for (final item in controller.requests) {
      final sameDate =
          (item.dateStart ?? '') == (target.dateStart ?? '') &&
          (item.dateEnd ?? '') == (target.dateEnd ?? '');
      final sameReason =
          (item.reason ?? '').trim() == (target.reason ?? '').trim();
      final sameStatus = _statusOf(item) == _statusOf(target);
      if (sameDate && sameReason && sameStatus) {
        return true;
      }
    }
    return false;
  }

  void _changeTab(int index) {
    final next = index.clamp(0, 3);
    if (next == selectedIndex) {
      return;
    }
    setState(() {
      _tabMotion = next > selectedIndex ? 1 : -1;
      selectedIndex = next;
    });
  }
}
