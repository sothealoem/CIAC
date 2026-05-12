part of 'online_class_dashboard_widget.dart';

class _AssignHomeworkPanel extends StatelessWidget {
  const _AssignHomeworkPanel({
    this.title,
    this.description,
    this.className,
    this.deadline,
  });

  final String? title;
  final String? description;
  final String? className;
  final String? deadline;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: LocaleKeys.onlineClassActionAssignHomework.tr,
      children: [
        if (className != null) ...[
          _StaticInput(
            icon: Icons.class_rounded,
            label: LocaleKeys.classLabel.tr,
            initialValue: className,
          ),
          const SizedBox(height: 10),
        ],
        _StaticInput(
          icon: Icons.title_rounded,
          label: LocaleKeys.onlineClassHomeworkTitle.tr,
          initialValue: title,
        ),
        const SizedBox(height: 10),
        _StaticInput(
          icon: Icons.notes_rounded,
          label: LocaleKeys.onlineClassHomeworkDescription.tr,
          minHeight: 78,
          initialValue: description,
        ),
        if (deadline != null) ...[
          const SizedBox(height: 10),
          _StaticInput(
            icon: Icons.event_rounded,
            label: LocaleKeys.onlineClassDeadline.tr,
            initialValue: deadline,
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _UploadButton(
                icon: Icons.attach_file_rounded,
                label: LocaleKeys.onlineClassUploadFile.tr,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _UploadButton(
                icon: Icons.add_photo_alternate_rounded,
                label: LocaleKeys.onlineClassUploadPicture.tr,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send_rounded, size: 18),
            label: Text(LocaleKeys.submit.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: _onlineClassAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassDetailPanel extends StatelessWidget {
  const _ClassDetailPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: LocaleKeys.onlineClassActionClassDetail.tr,
      children: [
        _DropdownPreview(
          label: LocaleKeys.onlineClassSelectClass.tr,
          value: 'Grade 4A',
        ),
        const SizedBox(height: 12),
        _SummaryPair(
          leftValue: '36',
          leftLabel: LocaleKeys.onlineClassStudents.tr,
          rightValue: '12',
          rightLabel: LocaleKeys.onlineClassSubmissions.tr,
        ),
        const SizedBox(height: 12),
        Text(
          LocaleKeys.onlineClassStudentList.tr,
          style: AppTextStyle.normalPrimaryBold,
        ),
        const SizedBox(height: 8),
        const _StudentSubmissionRow(
          name: 'Sokha',
          statusKey: LocaleKeys.onlineClassSubmitted,
        ),
        const Divider(height: 16),
        const _StudentSubmissionRow(
          name: 'Dara',
          statusKey: LocaleKeys.onlineClassPending,
        ),
        const Divider(height: 16),
        const _StudentSubmissionRow(
          name: 'Malis',
          statusKey: LocaleKeys.onlineClassSubmitted,
        ),
      ],
    );
  }
}

class _NotificationSubmissionPanel extends StatelessWidget {
  const _NotificationSubmissionPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: LocaleKeys.onlineClassActionNotifyClass.tr,
      children: [
        _StaticInput(
          icon: Icons.message_rounded,
          label: LocaleKeys.onlineClassMessageToStudents.tr,
          minHeight: 78,
        ),
        const SizedBox(height: 10),
        _TaskRow(
          icon: Icons.groups_rounded,
          title: LocaleKeys.onlineClassNotificationStudents.tr,
          subtitle: LocaleKeys.onlineClassActionSendMessage.tr,
        ),
        const Divider(height: 20),
        _TaskRow(
          icon: Icons.fact_check_rounded,
          title: LocaleKeys.onlineClassAllStudentSubmissions.tr,
          subtitle: LocaleKeys.onlineClassViewEachStudent.tr,
        ),
      ],
    );
  }
}

class _AllSubmitPanel extends StatelessWidget {
  const _AllSubmitPanel();

  static const _items = [
    _SubmitItem(
      title: 'Math worksheet chapter 4',
      className: 'Grade 4A',
      deadline: '12 May 2026',
      submitted: 24,
      total: 36,
      description: 'Complete all questions on multiplication practice.',
    ),
    _SubmitItem(
      title: 'Khmer reading summary',
      className: 'Grade 5B',
      deadline: '14 May 2026',
      submitted: 31,
      total: 35,
      description: 'Write a short summary from today reading lesson.',
    ),
    _SubmitItem(
      title: 'Science plant observation',
      className: 'Grade 3A',
      deadline: '16 May 2026',
      submitted: 18,
      total: 32,
      description: 'Upload one photo and write three observation notes.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Panel(
          title: LocaleKeys.onlineClassActionAllSubmit.tr,
          children: [
            _SummaryPair(
              leftValue: '${_items.length}',
              leftLabel: LocaleKeys.onlineClassTotalClass.tr,
              rightValue: '73',
              rightLabel: LocaleKeys.onlineClassSubmitted.tr,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SubmitCard(
              item: item,
              onEdit:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => _TeacherActionDetailScreen(
                            title: LocaleKeys.onlineClassEdit.tr,
                            child: _AssignHomeworkPanel(
                              title: item.title,
                              description: item.description,
                              className: item.className,
                              deadline: item.deadline,
                            ),
                          ),
                    ),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitCard extends StatelessWidget {
  const _SubmitCard({required this.item, required this.onEdit});

  final _SubmitItem item;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF305B8D).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _IconBox(
                icon: Icons.assignment_turned_in_rounded,
                backgroundColor: Color(0xFFEAF3FF),
                iconColor: Color(0xFF2F6FBD),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyle.normalPrimaryBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.submitted}/${item.total} ${LocaleKeys.onlineClassSubmitted.tr}',
                      style: AppTextStyle.smallGreyRegular,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, size: 16),
                label: Text(LocaleKeys.onlineClassEdit.tr),
                style: TextButton.styleFrom(
                  foregroundColor: _onlineClassAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SubmitMeta(
                  icon: Icons.class_rounded,
                  label: LocaleKeys.classLabel.tr,
                  value: item.className,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SubmitMeta(
                  icon: Icons.event_rounded,
                  label: LocaleKeys.onlineClassDeadline.tr,
                  value: item.deadline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubmitMeta extends StatelessWidget {
  const _SubmitMeta({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1EAF5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _onlineClassAccent, size: 17),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.smallGreyRegular),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: AppTextStyle.smallPrimaryBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitItem {
  const _SubmitItem({
    required this.title,
    required this.className,
    required this.deadline,
    required this.submitted,
    required this.total,
    required this.description,
  });

  final String title;
  final String className;
  final String deadline;
  final int submitted;
  final int total;
  final String description;
}

class _StaticInput extends StatelessWidget {
  const _StaticInput({
    required this.icon,
    required this.label,
    this.minHeight = 48,
    this.initialValue,
  });

  final IconData icon;
  final String label;
  final double minHeight;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final lines = minHeight > 60 ? 3 : 1;

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: _onlineClassAccentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
      ),
      child: TextFormField(
        initialValue: initialValue,
        minLines: lines,
        maxLines: lines,
        style: AppTextStyle.normalPrimaryRegular,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyle.smallGreyRegular,
          prefixIcon: Icon(icon, color: _onlineClassAccent, size: 20),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: _onlineClassAccent,
        side: const BorderSide(color: _onlineClassBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }
}

class _DropdownPreview extends StatelessWidget {
  const _DropdownPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _onlineClassAccentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.class_rounded, color: _onlineClassAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.smallGreyRegular),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyle.normalPrimaryBold),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.darkGrey,
          ),
        ],
      ),
    );
  }
}

class _SummaryPair extends StatelessWidget {
  const _SummaryPair({
    required this.leftValue,
    required this.leftLabel,
    required this.rightValue,
    required this.rightLabel,
  });

  final String leftValue;
  final String leftLabel;
  final String rightValue;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MetricBox(value: leftValue, label: leftLabel)),
        const SizedBox(width: 10),
        Expanded(child: _MetricBox(value: rightValue, label: rightLabel)),
      ],
    );
  }
}

class _StudentSubmissionRow extends StatelessWidget {
  const _StudentSubmissionRow({required this.name, required this.statusKey});

  final String name;
  final String statusKey;

  @override
  Widget build(BuildContext context) {
    final isPending = statusKey == LocaleKeys.onlineClassPending;

    return Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: _onlineClassAccentSoft,
          child: Text(
            name.characters.first,
            style: AppTextStyle.normalPrimaryBold.copyWith(
              color: _onlineClassWarmRed,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyle.normalPrimarySemiBold),
              const SizedBox(height: 2),
              Text(
                statusKey.tr,
                style: AppTextStyle.smallGreyRegular.copyWith(
                  color: isPending ? _onlineClassWarmRed : AppColor.darkGrey,
                  fontWeight: isPending ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(LocaleKeys.onlineClassView.tr),
        ),
      ],
    );
  }
}
