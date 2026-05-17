part of 'homework_widget.dart';

class _ParentHomeworkDashboard extends GetView<HomeworkController> {
  const _ParentHomeworkDashboard();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isAssignmentsLoading.value) {
          return const _StudentHomeworkLoadingView();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            Text(
              'All Assign Homework',
              style: AppTextStyle.largePrimaryBold.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            if (controller.assignedHomeworkItems.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _onlineClassBorder),
                ),
                child: Text(
                  'No homework assigned yet.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.smallGreyRegular.copyWith(
                    color: _homeworkMutedText,
                  ),
                ),
              )
            else
              ...controller.assignedHomeworkItems.map(
                (item) => _StudentAssignedHomeworkCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _StudentHomeworkLoadingView extends StatelessWidget {
  const _StudentHomeworkLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: _onlineClassAccent,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Loading homework...',
              style: AppTextStyle.mediumPrimaryBold.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please wait while we load assigned homework.',
              textAlign: TextAlign.center,
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

class _StudentAssignedHomeworkCard extends StatelessWidget {
  const _StudentAssignedHomeworkCard({required this.item});

  final HomeworkAssignment item;

  @override
  Widget build(BuildContext context) {
    final accentColor = _homeworkAccentFor(item.id);
    final hasSubmissionStats = item.total > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _onlineClassBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(width: 8, child: ColoredBox(color: accentColor)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.largePrimaryBold.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.normalPrimaryRegular.copyWith(
                        color: _homeworkMutedText,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _StudentHomeworkInfo(
                    icon: Icons.bookmark_rounded,
                    label: 'Class:',
                    text: item.className,
                  ),
                  const SizedBox(height: 8),
                  _StudentHomeworkInfo(
                    icon: Icons.calendar_month_rounded,
                    label: 'Deadline:',
                    text: item.deadline,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      final controller = Get.find<HomeworkController>();
                      final isSubmitted = controller.isStudentSubmitted(item.id);
                      final isSubmitting = controller.isStudentSubmitting(
                        item.id,
                      );

                      return OutlinedButton.icon(
                        onPressed:
                            isSubmitting
                                ? null
                                : () => _openStudentHomeworkSubmitSheet(
                                  context,
                                  item,
                                ),
                        icon:
                            isSubmitting
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _onlineClassAccent,
                                  ),
                                )
                                : Icon(
                                  isSubmitted
                                      ? Icons.check_circle_rounded
                                      : Icons.attach_file_rounded,
                                  size: 18,
                                ),
                        label: Text(
                          isSubmitting
                              ? 'Submitting...'
                              : isSubmitted
                              ? 'Submitted'
                              : 'Attach Image & Submit',
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      );
                    }),
                  ),
                  if (hasSubmissionStats) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF8F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item.submitted}/${item.total} Submitted',
                        style: AppTextStyle.normalPrimaryBold.copyWith(
                          color: const Color(0xFF2A9D71),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openStudentHomeworkSubmitSheet(
  BuildContext context,
  HomeworkAssignment item,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _StudentHomeworkSubmitSheet(item: item),
  );
}

class _StudentHomeworkSubmitSheet extends StatefulWidget {
  const _StudentHomeworkSubmitSheet({required this.item});

  final HomeworkAssignment item;

  @override
  State<_StudentHomeworkSubmitSheet> createState() =>
      _StudentHomeworkSubmitSheetState();
}

class _StudentHomeworkSubmitSheetState
    extends State<_StudentHomeworkSubmitSheet> {
  final TextEditingController _answerCtl = TextEditingController();
  XFile? _selectedImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _answerCtl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (!mounted || image == null) return;
      setState(() => _selectedImage = image);
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
  }

  Future<void> _submit() async {
    final answer = _answerCtl.text.trim();
    final imagePath = _selectedImage?.path.trim() ?? '';
    if (answer.isEmpty && imagePath.isEmpty) {
      ExceptionHandler.handleException('Please add an answer or attach an image');
      return;
    }

    try {
      setState(() => _isSubmitting = true);
      await Get.find<HomeworkController>().submitStudentHomeworkAnswer(
        homeworkId: widget.item.id,
        answerText: answer,
        attachmentPath: imagePath.isEmpty ? null : imagePath,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      Get.snackbar(
        'Success',
        'Homework submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      ExceptionHandler.handleException(e);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.item.title,
                  style: AppTextStyle.largePrimaryBold.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add your answer and attach an image before submitting.',
                  style: AppTextStyle.smallGreyRegular.copyWith(
                    color: _homeworkMutedText,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _answerCtl,
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Write your answer here',
                    filled: true,
                    fillColor: const Color(0xFFF9F5F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _onlineClassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _onlineClassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _onlineClassAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _isSubmitting ? null : _pickImage,
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _onlineClassBorder),
                      color: const Color(0xFFFFFBFC),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _onlineClassAccentSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            color: _onlineClassAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedImage == null
                                    ? 'Attach image'
                                    : _selectedImage!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.normalPrimaryBold.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _selectedImage == null
                                    ? 'Tap to choose from gallery'
                                    : 'Ready to upload',
                                style: AppTextStyle.smallGreyRegular.copyWith(
                                  color: _homeworkMutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_selectedImage != null)
                          IconButton(
                            onPressed:
                                _isSubmitting
                                    ? null
                                    : () => setState(() => _selectedImage = null),
                            icon: const Icon(Icons.close_rounded),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _onlineClassAccent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFF2B8BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        _isSubmitting
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                            : const Text('Submit Homework'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentHomeworkInfo extends StatelessWidget {
  const _StudentHomeworkInfo({
    required this.icon,
    required this.label,
    required this.text,
  });

  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _onlineClassAccent, size: 16),
        const SizedBox(width: 5),
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: AppTextStyle.normalPrimaryBold.copyWith(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: AppTextStyle.normalPrimaryRegular.copyWith(
                    color: _homeworkMutedText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
