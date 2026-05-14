part of 'homework_widget.dart';

class _ParentHomeworkDashboard extends GetView<HomeworkController> {
  const _ParentHomeworkDashboard();

  static const _actions = [
    _DashboardAction(
      Icons.photo_library_rounded,
      LocaleKeys.onlineClassActionActivities,
      LocaleKeys.onlineClassActionClassMoments,
    ),
    _DashboardAction(
      Icons.assignment_rounded,
      LocaleKeys.onlineClassActionHomework,
      LocaleKeys.onlineClassActionViewTasks,
    ),
    _DashboardAction(
      Icons.edit_note_rounded,
      LocaleKeys.onlineClassActionComplete,
      LocaleKeys.onlineClassActionDoHomework,
    ),
    _DashboardAction(
      Icons.cloud_upload_rounded,
      LocaleKeys.onlineClassActionSubmit,
      LocaleKeys.onlineClassActionUploadWork,
    ),
    _DashboardAction(
      Icons.notifications_none_rounded,
      LocaleKeys.onlineClassActionNotifications,
      LocaleKeys.onlineClassActionMessages,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _HeroPanel(
          title: LocaleKeys.onlineClassParentOverview.tr,
          subtitle: LocaleKeys.onlineClassParentOverviewSubtitle.tr,
          icon: Icons.family_restroom_rounded,
        ),
        const SizedBox(height: 14),
        const _HomeworkProgressCard(),
        const SizedBox(height: 18),
        Text(
          LocaleKeys.onlineClassQuickActions.tr,
          style: AppTextStyle.mediumPrimaryBold.copyWith(
            color: _onlineClassAccent,
          ),
        ),
        const SizedBox(height: 10),
        ..._actions.map((action) => _WideActionTile(action: action)),
        const SizedBox(height: 18),
        Text(
          LocaleKeys.onlineClassActionHomework.tr,
          style: AppTextStyle.mediumPrimaryBold.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Column(
            children:
                controller.assignedHomeworkItems
                    .map(
                      (item) => _StudentHomeworkCard(
                        item: item,
                        isSubmitted: controller.isStudentSubmitted(item.id),
                        onSubmit:
                            () => controller.submitStudentHomework(item.id),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _HomeworkProgressCard extends GetView<HomeworkController> {
  const _HomeworkProgressCard();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _onlineClassAccentLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _onlineClassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.assignment_turned_in_rounded,
                  color: _onlineClassAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    LocaleKeys.onlineClassHomeworkStatus.tr,
                    style: AppTextStyle.mediumPrimaryBold.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${controller.submittedAssignments}/${controller.totalAssignments}',
                  style: AppTextStyle.normalPrimaryBold.copyWith(
                    color: _onlineClassAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: controller.homeworkProgress,
                minHeight: 8,
                backgroundColor: _onlineClassAccentSoft,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  _onlineClassAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              controller.pendingAssignments == 0
                  ? LocaleKeys.onlineClassHomeworkDone.tr
                  : '${controller.pendingAssignments} homework pending',
              style: AppTextStyle.smallGreyRegular.copyWith(
                color: _homeworkMutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentHomeworkCard extends StatelessWidget {
  const _StudentHomeworkCard({
    required this.item,
    required this.isSubmitted,
    required this.onSubmit,
  });

  final HomeworkAssignment item;
  final bool isSubmitted;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    final accentColor = _homeworkAccentFor(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _onlineClassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(width: 8, child: ColoredBox(color: accentColor)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _onlineClassAccentSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_rounded,
                          color: _onlineClassAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.normalPrimaryBold.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.smallGreyRegular.copyWith(
                                color: _homeworkMutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StudentHomeworkInfo(
                        icon: Icons.class_rounded,
                        text: item.className,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StudentHomeworkInfo(
                          icon: Icons.calendar_month_rounded,
                          text: item.deadline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: isSubmitted ? null : onSubmit,
                      icon: Icon(
                        isSubmitted
                            ? Icons.check_circle_rounded
                            : Icons.cloud_upload_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isSubmitted
                            ? LocaleKeys.onlineClassSubmitted.tr
                            : LocaleKeys.onlineClassActionSubmit.tr,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            isSubmitted
                                ? const Color(0xFF14925A)
                                : _onlineClassAccent,
                        side: BorderSide(
                          color:
                              isSubmitted
                                  ? const Color(0xFFBDE8D1)
                                  : _onlineClassAccent,
                        ),
                        backgroundColor:
                            isSubmitted
                                ? const Color(0xFFEFF8F3)
                                : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentHomeworkInfo extends StatelessWidget {
  const _StudentHomeworkInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _onlineClassAccent, size: 16),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.smallGreyRegular.copyWith(
              color: _homeworkMutedText,
            ),
          ),
        ),
      ],
    );
  }
}
