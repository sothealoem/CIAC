part of 'online_class_dashboard_widget.dart';

class _TeacherClassDashboard extends StatelessWidget {
  const _TeacherClassDashboard();

  static const _actions = [
    _DashboardAction(
      Icons.class_rounded,
      LocaleKeys.onlineClassActionClassDetail,
      LocaleKeys.onlineClassActionViewClassInfo,
    ),
    _DashboardAction(
      Icons.assignment_add,
      LocaleKeys.onlineClassActionAssignHomework,
      LocaleKeys.onlineClassActionCreateTask,
    ),
    _DashboardAction(
      Icons.notifications_active_rounded,
      LocaleKeys.onlineClassActionNotifyClass,
      LocaleKeys.onlineClassActionSendMessage,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        const Padding(padding: EdgeInsets.only(top: 15)),
        _HeroPanel(
          title: LocaleKeys.onlineClassTeacherWorkbench.tr,
          subtitle: LocaleKeys.onlineClassTeacherWorkbenchSubtitle.tr,
          icon: Icons.school_rounded,
        ),
        const SizedBox(height: 14),
        const _TeacherMetricGrid(),
        const SizedBox(height: 18),
        Text(
          LocaleKeys.onlineClassTeachingTools.tr,
          style: AppTextStyle.mediumPrimaryBold.copyWith(
            color: _onlineClassAccent,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 132,
          child: Row(
            children: [
              Expanded(
                child: _ActionTile(
                  action: _actions[0],
                  onTap:
                      () => _openDetail(
                        context,
                        title: LocaleKeys.onlineClassActionClassDetail.tr,
                        child: const _ClassDetailPanel(),
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  action: _actions[1],
                  onTap:
                      () => _openDetail(
                        context,
                        title: LocaleKeys.onlineClassActionAssignHomework.tr,
                        child: const _AssignHomeworkPanel(),
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  action: _actions[2],
                  onTap:
                      () => _openDetail(
                        context,
                        title: LocaleKeys.onlineClassActionNotifyClass.tr,
                        child: const _NotificationSubmissionPanel(),
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _AllSubmitPanel(),
      ],
    );
  }

  void _openDetail(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _TeacherActionDetailScreen(title: title, child: child),
      ),
    );
  }
}

class _TeacherMetricGrid extends StatelessWidget {
  const _TeacherMetricGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.05,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MetricBox(
          icon: Icons.fact_check_rounded,
          value: '56',
          label: LocaleKeys.onlineClassSubmissions.tr,
        ),
        _MetricBox(
          icon: Icons.class_rounded,
          value: '4',
          label: LocaleKeys.onlineClassTotalClass.tr,
        ),
        _MetricBox(
          icon: Icons.groups_rounded,
          value: '180',
          label: LocaleKeys.onlineClassStudents.tr,
        ),
        _MetricBox(
          icon: Icons.today_rounded,
          value: '3',
          label: LocaleKeys.onlineClassDueToday.tr,
          accentColor: _onlineClassWarmRed,
        ),
      ],
    );
  }
}

class _TeacherActionDetailScreen extends StatelessWidget {
  const _TeacherActionDetailScreen({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(title),
        backgroundColor: _onlineClassAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: _onlineClassAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [child],
      ),
    );
  }
}
