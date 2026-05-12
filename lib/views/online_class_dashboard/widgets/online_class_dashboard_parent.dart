part of 'online_class_dashboard_widget.dart';

class _ParentClassDashboard extends StatelessWidget {
  const _ParentClassDashboard();

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
        const SizedBox(height: 8),
        _Panel(
          title: LocaleKeys.onlineClassLatestUpdates.tr,
          children: [
            _TaskRow(
              icon: Icons.notifications_active_rounded,
              title: LocaleKeys.onlineClassReceiveNotifications.tr,
              subtitle: LocaleKeys.onlineClassNewAnnouncement.tr,
            ),
            const Divider(height: 20),
            _TaskRow(
              icon: Icons.cloud_done_rounded,
              title: LocaleKeys.onlineClassUploadHomeworkSubmission.tr,
              subtitle: LocaleKeys.onlineClassReadyToUpload.tr,
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeworkProgressCard extends StatelessWidget {
  const _HomeworkProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _onlineClassAccentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
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
                    color: _onlineClassAccent,
                  ),
                ),
              ),
              Text(
                LocaleKeys.onlineClassHomeworkDone.tr,
                style: AppTextStyle.normalPrimaryBold.copyWith(
                  color: _onlineClassAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.66,
              minHeight: 8,
              backgroundColor: _onlineClassAccentSoft,
              valueColor: AlwaysStoppedAnimation<Color>(_onlineClassAccent),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.onlineClassHomeworkNeedsSubmission.tr,
            style: AppTextStyle.smallGreyRegular,
          ),
        ],
      ),
    );
  }
}
