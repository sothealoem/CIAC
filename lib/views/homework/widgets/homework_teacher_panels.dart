part of 'homework_widget.dart';

class _AssignHomeworkPanel extends StatefulWidget {
  const _AssignHomeworkPanel({
    this.id,
    this.title,
    this.description,
    this.className,
    this.deadline,
    this.submitted = 0,
    this.total = 0,
    this.onSubmit,
    this.showTitle = true,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? className;
  final String? deadline;
  final int submitted;
  final int total;
  final ValueChanged<HomeworkAssignment>? onSubmit;
  final bool showTitle;

  @override
  State<_AssignHomeworkPanel> createState() => _AssignHomeworkPanelState();
}

class _AssignHomeworkPanelState extends State<_AssignHomeworkPanel> {
  late final TextEditingController _titleCtl;
  late final TextEditingController _descriptionCtl;
  late final TextEditingController _deadlineCtl;
  String _selectedClass = '';
  final List<XFile> _selectedImages = <XFile>[];

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.title ?? '');
    _descriptionCtl = TextEditingController(text: widget.description ?? '');
    _deadlineCtl = TextEditingController(text: widget.deadline ?? '');
    _selectedClass = (widget.className ?? '').trim();
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descriptionCtl.dispose();
    _deadlineCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeworkController>();
    return Obx(() {
      final classOptions =
          controller.teacherClassOptions
              .map((option) => option.name)
              .where((name) => name.trim().isNotEmpty)
              .toList();
      final selectedValue =
          classOptions.contains(_selectedClass)
              ? _selectedClass
              : classOptions.isNotEmpty
              ? classOptions.first
              : '';
      if (_selectedClass != selectedValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _selectedClass = selectedValue);
        });
      }

      return _Panel(
        title: LocaleKeys.onlineClassActionAssignHomework.tr,
        showTitle: widget.showTitle,
        children: [
          _FieldLabel(title: LocaleKeys.onlineClassSelectClass.tr),
          const SizedBox(height: 8),
          _ClassDropdownField(
            value: selectedValue,
            options: classOptions,
            onChanged: (value) => setState(() => _selectedClass = value),
          ),
          if (classOptions.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'No class list available yet.',
              style: AppTextStyle.smallGreyRegular.copyWith(
                color: _homeworkMutedText,
              ),
            ),
          ],
          const SizedBox(height: 22),
          _FieldLabel(title: LocaleKeys.onlineClassHomeworkTitle.tr),
          const SizedBox(height: 8),
          _StaticInput(
            icon: Icons.title_rounded,
            label: 'Enter homework title',
            controller: _titleCtl,
          ),
          const SizedBox(height: 22),
          _FieldLabel(title: LocaleKeys.onlineClassHomeworkDescription.tr),
          const SizedBox(height: 8),
          _StaticInput(
            icon: Icons.notes_rounded,
            label: 'Enter instruction or description',
            minHeight: 78,
            controller: _descriptionCtl,
          ),
          const SizedBox(height: 22),
          _FieldLabel(title: LocaleKeys.onlineClassDeadline.tr),
          const SizedBox(height: 8),
          _DeadlinePickerField(controller: _deadlineCtl, onTap: _pickDeadline),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _UploadButton(
                  icon: Icons.attach_file_rounded,
                  label: LocaleKeys.onlineClassUploadFile.tr,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _UploadButton(
                  icon: Icons.add_photo_alternate_rounded,
                  label:
                      _selectedImages.isEmpty
                          ? LocaleKeys.onlineClassUploadPicture.tr
                          : '${_selectedImages.length} image(s) selected',
                  onPressed: _pickImages,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 66,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF3345), Color(0xFFD80F23)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33D80F23),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isSubmittingAssignment.value ? null : _submit,
                  icon:
                      controller.isSubmittingAssignment.value
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.send_rounded, size: 22),
                  label: Text(
                    controller.isSubmittingAssignment.value
                        ? 'Submitting...'
                        : LocaleKeys.submit.tr,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _submit() async {
    final title = _titleCtl.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        LocaleKeys.error.tr,
        '${LocaleKeys.onlineClassHomeworkTitle.tr} ${LocaleKeys.cannotBeEmpty.tr}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<HomeworkController>();
    HomeworkClassOption? selectedOption;
    for (final option in controller.teacherClassOptions) {
      if (option.name == _selectedClass) {
        selectedOption = option;
        break;
      }
    }
    if (selectedOption == null) {
      Get.snackbar(
        LocaleKeys.error.tr,
        'Please select a class.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedOption.id == null || selectedOption.id! <= 0) {
      Get.snackbar(
        LocaleKeys.error.tr,
        'This class is missing its class ID.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    HomeworkAssignment item;
    try {
      if ((widget.id ?? '').trim().isEmpty) {
        item = await controller.createAssignment(
          title: title,
          classId: selectedOption.id,
          className: _selectedClass,
          deadline: _deadlineCtl.text,
          description: _descriptionCtl.text.trim(),
          imagePaths: _selectedImages.map((image) => image.path).toList(),
        );
      } else {
        item = controller.buildAssignment(
          id: widget.id,
          classId: selectedOption.id,
          title: title,
          className: _selectedClass,
          deadline: _deadlineCtl.text,
          description: _descriptionCtl.text.trim(),
          submitted: widget.submitted,
          total: widget.total,
        );
        widget.onSubmit?.call(item);
      }
    } catch (e) {
      ExceptionHandler.handleException(e);
      return;
    }

    if (widget.showTitle) {
      controller.requestAssignmentsLoading();
      Navigator.of(context).pushReplacement(
        _homeworkRoute(
          _TeacherActionDetailScreen(
            title: LocaleKeys.onlineClassActionAllAssignHomework.tr,
            child: const _AllAssignedHomeworkPanel(),
          ),
        ),
      );
      return;
    }

    controller.requestAssignmentsLoading();
    Navigator.of(context).pop(item);
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    _deadlineCtl.text = Get.find<HomeworkController>().formatDeadline(picked);
  }

  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage(imageQuality: 90);
      if (!mounted || images.isEmpty) return;
      setState(() {
        _selectedImages
          ..clear()
          ..addAll(images);
      });
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
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
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: _ClassInfoStat(
                icon: Icons.groups_rounded,
                value: '36',
                label: 'Students',
                color: Color(0xFF10A850),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ClassInfoStat(
                icon: Icons.book_rounded,
                value: '6',
                label: 'Subjects',
                color: Color(0xFFF3B51B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _ClassDetailTile(
          icon: Icons.person_rounded,
          title: 'Homeroom Teacher',
          value: 'Teacher Sokha',
        ),
        const SizedBox(height: 10),
        const _ClassDetailTile(
          icon: Icons.meeting_room_rounded,
          title: 'Room',
          value: 'Building A - Room 204',
        ),
        const SizedBox(height: 10),
        const _ClassDetailTile(
          icon: Icons.schedule_rounded,
          title: 'Class Time',
          value: 'Monday - Friday, 8:00 AM - 11:30 AM',
        ),
        const SizedBox(height: 10),
        const _ClassDetailTile(
          icon: Icons.event_note_rounded,
          title: 'Current Term',
          value: 'Term 2, Academic Year 2026',
        ),
      ],
    );
  }
}

class _AllAssignedHomeworkPanel extends GetView<HomeworkController> {
  const _AllAssignedHomeworkPanel();

  @override
  Widget build(BuildContext context) {
    if (controller.shouldShowAssignmentsLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.shouldShowAssignmentsLoading = false;
        controller.fetchTeacherHomeworks();
      });
    }

    return Obx(() {
      final items = controller.assignedHomeworkItems;
      if (controller.isAssignmentsLoading.value) {
        return const SizedBox(
          height: 320,
          child: Center(
            child: SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: _onlineClassAccent,
                backgroundColor: _onlineClassAccentSoft,
              ),
            ),
          ),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...items.map(
            (item) => _AssignedHomeworkAttendanceCard(
              item: item,
              onTap:
                  () => Navigator.of(context).push(
                    _homeworkRoute(
                      _TeacherActionDetailScreen(
                        title: LocaleKeys.onlineClassActionAllAssignHomework.tr,
                        child: _AssignedHomeworkDetailPanel(item: item),
                      ),
                    ),
                  ),
              onEdit:
                  () => Navigator.of(context).push(
                    _homeworkRoute(
                      _TeacherActionDetailScreen(
                        title: LocaleKeys.onlineClassEdit.tr,
                        child: _AssignedHomeworkEditPanel(item: item),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      );
    });
  }
}

class _ClassInfoStat extends StatelessWidget {
  const _ClassInfoStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.mediumPrimaryBold.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
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
    );
  }
}

class _ClassDetailTile extends StatelessWidget {
  const _ClassDetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _onlineClassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _onlineClassAccentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _onlineClassAccent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.smallGreyRegular.copyWith(
                    color: _homeworkMutedText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.normalPrimaryBold.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignedHomeworkDetailPanel extends StatefulWidget {
  const _AssignedHomeworkDetailPanel({required this.item});

  final HomeworkAssignment item;

  @override
  State<_AssignedHomeworkDetailPanel> createState() =>
      _AssignedHomeworkDetailPanelState();
}

class _AssignedHomeworkDetailPanelState
    extends State<_AssignedHomeworkDetailPanel> {
  String _selectedStatus = LocaleKeys.onlineClassSubmitted;
  late final Future<HomeworkAssignmentDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = Get.find<HomeworkController>().fetchTeacherHomeworkDetail(
      widget.item.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeworkAssignmentDetail>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 320,
            child: Center(
              child: SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: _onlineClassAccent,
                  backgroundColor: _onlineClassAccentSoft,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _Panel(
            title: widget.item.title,
            children: [
              Text(
                'Unable to load homework detail',
                style: AppTextStyle.smallGreyRegular.copyWith(
                  color: _homeworkMutedText,
                ),
              ),
            ],
          );
        }

        final detail = snapshot.data!;
        final item = detail.assignment;
        final filtered =
            detail.students
                .where(
                  (submission) =>
                      _statusKeyFor(submission.status) == _selectedStatus,
                )
                .toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AssignedHomeworkSummaryPanel(item: item),
            const SizedBox(height: 14),
            _Panel(
              title: LocaleKeys.onlineClassAllStudentSubmissions.tr,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _submissionMetricBox(
                        value: '${item.submitted}',
                        label: LocaleKeys.onlineClassSubmitted.tr,
                        statusKey: LocaleKeys.onlineClassSubmitted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _submissionMetricBox(
                        value: '${item.total - item.submitted}',
                        label: LocaleKeys.onlineClassPending.tr,
                        statusKey: LocaleKeys.onlineClassPending,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (filtered.isEmpty)
                  Text(
                    'No student submissions',
                    style: AppTextStyle.smallGreyRegular.copyWith(
                      color: _homeworkMutedText,
                    ),
                  ),
                ...filtered.expand(
                  (submission) => [
                    _StudentSubmissionRow(
                      name: submission.name,
                      statusKey: _statusKeyFor(submission.status),
                    ),
                    if (submission != filtered.last) const Divider(height: 16),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _statusKeyFor(String status) {
    return status.toLowerCase() == 'submitted'
        ? LocaleKeys.onlineClassSubmitted
        : LocaleKeys.onlineClassPending;
  }

  Widget _submissionMetricBox({
    required String value,
    required String label,
    required String statusKey,
  }) {
    final selected = _selectedStatus == statusKey;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _selectedStatus = statusKey),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              selected
                  ? Border.all(color: _onlineClassAccent, width: 1.4)
                  : null,
        ),
        child: _MetricBox(value: value, label: label),
      ),
    );
  }
}

class _AssignedHomeworkEditPanel extends StatelessWidget {
  const _AssignedHomeworkEditPanel({required this.item});

  final HomeworkAssignment item;

  @override
  Widget build(BuildContext context) {
    return _AssignHomeworkPanel(
      id: item.id,
      title: item.title,
      description: item.description,
      className: item.className,
      deadline: item.deadline,
      submitted: item.submitted,
      total: item.total,
      showTitle: false,
      onSubmit: Get.find<HomeworkController>().updateAssignment,
    );
  }
}

class _AssignedHomeworkSummaryPanel extends StatelessWidget {
  const _AssignedHomeworkSummaryPanel({required this.item});

  final HomeworkAssignment item;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: item.title,
      children: [
        if (item.description.isNotEmpty) ...[
          Text(
            item.description,
            style: AppTextStyle.normalPrimaryRegular.copyWith(
              color: _homeworkMutedText,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
        ],
        const Divider(height: 1, color: _onlineClassBorder),
        const SizedBox(height: 14),
        _HomeworkDetailPair(
          leftLabel: LocaleKeys.classLabel.tr,
          leftValue: item.className,
          rightLabel: LocaleKeys.onlineClassDeadline.tr,
          rightValue: item.deadline,
        ),
        const SizedBox(height: 14),
        // Row(
        //   children: [
        //     Expanded(
        //       child: _MetricBox(
        //         value: '${item.submitted}',
        //         label: LocaleKeys.onlineClassSubmitted.tr,
        //         accentColor: const Color(0xFF14925A),
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     Expanded(
        //       child: _MetricBox(
        //         value: '${item.total - item.submitted}',
        //         label: LocaleKeys.onlineClassPending.tr,
        //         accentColor: _onlineClassAccent,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class _HomeworkDetailPair extends StatelessWidget {
  const _HomeworkDetailPair({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HomeworkDetailText(label: leftLabel, value: leftValue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _HomeworkDetailText(
            label: rightLabel,
            value: rightValue,
            crossAxisAlignment: CrossAxisAlignment.end,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _HomeworkDetailText extends StatelessWidget {
  const _HomeworkDetailText({
    required this.label,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textAlign = TextAlign.left,
  });

  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: AppTextStyle.smallGreyRegular.copyWith(
            color: _homeworkMutedText,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: AppTextStyle.normalPrimaryBold.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}

class _AssignedHomeworkAttendanceCard extends StatelessWidget {
  const _AssignedHomeworkAttendanceCard({
    required this.item,
    required this.onTap,
    required this.onEdit,
  });

  final HomeworkAssignment item;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final accentColor = _homeworkAccentFor(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _onlineClassBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 18,
            offset: Offset(0, 8),
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
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.normalPrimaryBold.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                          height: 1.25,
                        ),
                      ),
                      if (item.description.isNotEmpty) ...[
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
                      const SizedBox(height: 5),
                      _infoRow(
                        Icons.bookmark_rounded,
                        LocaleKeys.classLabel.tr,
                        item.className,
                      ),
                      const SizedBox(height: 5),
                      _infoRow(
                        Icons.calendar_month_rounded,
                        LocaleKeys.onlineClassDeadline.tr,
                        item.deadline,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _submissionChip,
                          const Spacer(),
                          _AssignedHomeworkEditButton(onTap: onEdit),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: _onlineClassAccent, size: 16),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: AppFontFamily.localized,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
          ),
        ),
      ],
    );
  }

  Widget get _submissionChip {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${item.submitted}/${item.total} ${LocaleKeys.onlineClassSubmitted.tr}',
        style: AppTextStyle.smallPrimaryBold.copyWith(
          color: const Color(0xFF14925A),
        ),
      ),
    );
  }
}

class _AssignedHomeworkEditButton extends StatelessWidget {
  const _AssignedHomeworkEditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: _onlineClassAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.edit_rounded,
                color: _onlineClassAccent,
                size: 16,
              ),
              const SizedBox(width: 7),
              Text(
                LocaleKeys.onlineClassEdit.tr,
                style: AppTextStyle.smallPrimaryBold.copyWith(
                  color: _onlineClassAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.normalPrimaryBold.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }
}

class _StaticInput extends StatelessWidget {
  const _StaticInput({
    required this.icon,
    required this.label,
    this.minHeight = 48,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final double minHeight;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lines = minHeight > 60 ? 3 : 1;

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        minLines: lines,
        maxLines: lines,
        style: AppTextStyle.normalPrimaryRegular,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyle.smallGreyRegular.copyWith(
            color: _homeworkMutedText.withOpacity(0.78),
          ),
          prefixIcon: Container(
            width: 52,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              // color: Color(0xFFFFF7F8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              border: Border(right: BorderSide(color: _onlineClassBorder)),
            ),
            child: Icon(icon, color: _onlineClassAccent, size: 20),
          ),
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

class _ClassDropdownField extends StatelessWidget {
  const _ClassDropdownField({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options =
        LinkedHashSet<String>.from(
          this.options.where((option) => option.trim().isNotEmpty),
        ).toList();
    final selectedValue =
        options.contains(value)
            ? value
            : options.isNotEmpty
            ? options.first
            : LocaleKeys.classLabel.tr;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _onlineClassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7F8),
                border: Border(right: BorderSide(color: _onlineClassBorder)),
              ),
              child: const Icon(
                Icons.bookmark_rounded,
                color: _onlineClassAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: options.isEmpty ? null : selectedValue,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColor.darkGrey,
                  ),
                  style: AppTextStyle.normalPrimaryRegular,
                  items:
                      options
                          .map(
                            (option) => DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      options.isEmpty
                          ? null
                          : (selected) {
                            if (selected != null) onChanged(selected);
                          },
                ),
              ),
            ),
          ],
        ),
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

class _DeadlinePickerField extends StatelessWidget {
  const _DeadlinePickerField({required this.controller, required this.onTap});

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _StaticInput(
      icon: Icons.event_rounded,
      label: 'Select deadline',
      controller: controller,
      readOnly: true,
      onTap: onTap,
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: _onlineClassAccent,
        side: const BorderSide(color: _onlineClassBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                  color: isPending ? _onlineClassWarmRed : AppColor.green,
                  fontWeight: isPending ? FontWeight.w700 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isPending)
          TextButton(
            onPressed: () {},
            child: Text(
              LocaleKeys.onlineClassView.tr,
              style: AppTextStyle.smallPrimaryBold.copyWith(
                color: _onlineClassAccent,
              ),
            ),
          ),
      ],
    );
  }
}
