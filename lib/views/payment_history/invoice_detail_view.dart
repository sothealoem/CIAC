import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:schoolapp/core/configs/app_style.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/flavor.dart';
import 'package:schoolapp/models/payment_history/invoice_details_model.dart';
import 'package:schoolapp/views/payment_history/controller.dart';

class InvoiceDetailView extends GetView<PaymentHistoryController> {
  const InvoiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Details')),
      body: Obx(() {
        if (controller.isLoadingInvoice.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.invoiceError.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.invoiceError.value,
              style: AppTextStyle.normalRedRegular,
            ),
          );
        }
        final data = controller.selectedInvoice.value?.data;
        if (data == null) {
          return const Center(child: Text('No invoice details found.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1. Student payment information',
                style: AppTextStyle.mediumPrimaryBoldText,
              ),
              10.height,
              _studentCard(data),
              18.height,
              const Text(
                '2. Payment history',
                style: AppTextStyle.mediumPrimaryBoldText,
              ),
              8.height,
              Card.outlined(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildHeaderRow(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.details.length,
                      itemBuilder: (context, index) {
                        final line = data.details[index];
                        final isEven = index % 2 == 0;
                        final rowColor =
                            isEven ? AppColor.primaryColor : Colors.white;
                        final textColor =
                            isEven ? Colors.white : AppColor.primary;
                        return Container(
                          color: rowColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 6,
                          ),
                          child: Row(
                            children: [
                              _buildCell('${index + 1}', 1, textColor, true),
                              _buildCell(line.itemName, 4, textColor, false),
                              _buildCell(
                                _formatDate(line.paidDate),
                                2,
                                textColor,
                                false,
                                shiftX: -15,
                              ),
                              _buildCell(
                                _statusText(data.invoice),
                                2,
                                textColor,
                                false,
                              ),
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.file_download_outlined,
                                  size: 16,
                                  color:
                                      isEven ? Colors.white : AppColor.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              18.height,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Total amount: ${data.invoice.grandTotal}\$',
                    style: AppTextStyle.mendiumPrimaryBoldwhite,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _studentCard(ParentInvoiceDetailsData data) {
    final lines = data.details.take(3).toList();
    final studentName =
        data.student.nameKh.trim().isNotEmpty
            ? data.student.nameKh
            : data.student.nameEn;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _childImage(),
              ),
              const SizedBox(height: 6),
              Text(studentName, style: AppTextStyle.regularPrimaryBoldblack),
              const Text('Student', style: AppTextStyle.smallPrimarytextgrey),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children:
                  lines
                      .map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.itemName.isEmpty
                                          ? '-'
                                          : line.itemName,
                                      style:
                                          AppTextStyle.regularPrimarytextblack,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            line.feetype.isEmpty
                                                ? '-'
                                                : line.feetype,
                                            style:
                                                AppTextStyle
                                                    .smallPrimarytextgrey,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        _dateTag(_formatDate(line.paidDate)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_formatAmount(line.amount)}\$',
                                style: AppTextStyle.regularPrimarytextPrimary,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTag(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        date,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Battambang',
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      color: Colors.white,
      child: Row(
        children: [
          _headerCell('No', 1, true),
          _headerCell('Type', 4, false),
          _headerCell('Date', 2, false, shiftX: -6),
          _headerCell('Status', 2, false),
          _headerCell('Invoice', 2, true),
        ],
      ),
    );
  }

  Widget _headerCell(String text, int flex, bool center, {double shiftX = 0}) {
    return Expanded(
      flex: flex,
      child: Transform.translate(
        offset: Offset(shiftX, 0),
        child: Text(
          text,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Battambang',
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    String text,
    int flex,
    Color color,
    bool center, {
    double shiftX = 0,
  }) {
    return Expanded(
      flex: flex,
      child: Transform.translate(
        offset: Offset(shiftX, 0),
        child: Text(
          text,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontFamily: 'Battambang',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _statusText(ParentInvoice invoice) {
    final due = num.tryParse(invoice.dueAmount.trim()) ?? 0;
    return due <= 0 ? 'Paid' : 'Unpaid';
  }

  String _formatDate(String raw) {
    final dt = DateTime.tryParse(raw.trim());
    if (dt == null) return raw;
    return DateFormat('dd/MM/yy').format(dt);
  }

  String _formatAmount(String raw) {
    final value = num.tryParse(raw.trim()) ?? 0;
    return value.toStringAsFixed(2);
  }

  Widget _childImage() {
    const width = 88.0;
    const height = 96.0;
    final raw =
        (Get.find<PaymentHistoryController>().selectedChildAvatar.value).trim();
    final candidates = _resolveProfileUrlCandidates(raw);
    if (candidates.isEmpty) {
      return Image.asset(
        'assets/images/studentprofile.jpg',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
    final first = candidates.first;
    if (_isNetworkUrl(first)) {
      return _networkChildImage(candidates, 0, width, height);
    }
    return Image.asset(
      first,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder:
          (_, __, ___) => Image.asset(
            'assets/images/studentprofile.jpg',
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
    );
  }

  Widget _networkChildImage(
    List<String> urls,
    int index,
    double width,
    double height,
  ) {
    if (index >= urls.length) {
      return Image.asset(
        'assets/images/studentprofile.jpg',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: urls[index],
      width: width,
      height: height,
      fit: BoxFit.cover,
      memCacheWidth: 176,
      memCacheHeight: 192,
      maxWidthDiskCache: 176,
      maxHeightDiskCache: 192,
      httpHeaders: _imageHeaders() ?? const <String, String>{},
      useOldImageOnUrlChange: true,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      placeholder:
          (_, __) => Image.asset(
            'assets/images/studentprofile.jpg',
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
      errorWidget:
          (_, __, ___) => _networkChildImage(urls, index + 1, width, height),
    );
  }

  Map<String, String>? _imageHeaders() {
    final token = AppConfig.shared.authorizationToken.trim();
    if (token.isEmpty) return null;
    return <String, String>{'Authorization': token, 'Accept': 'image/*'};
  }

  List<String> _resolveProfileUrlCandidates(String rawValue) {
    final value = rawValue.trim().replaceAll('\\', '/');
    final lower = value.toLowerCase();
    if (value.isEmpty ||
        lower == 'n/a' ||
        lower == 'null' ||
        lower == 'undefined' ||
        lower == 'false' ||
        value == '{}') {
      return const <String>[];
    }

    final unquoted = value.replaceAll('"', '').replaceAll("'", '');
    if (unquoted.startsWith('assets/')) {
      return <String>[unquoted];
    }
    if (_isNetworkUrl(unquoted)) {
      return _networkUrlVariants(unquoted);
    }
    if (unquoted.startsWith('//')) {
      return <String>['https:$unquoted'];
    }

    final base = AppConfig.shared.baseUrl.trim();
    if (base.isEmpty) return const <String>[];
    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    final path = unquoted.startsWith('/') ? unquoted.substring(1) : unquoted;

    final rawCandidates = <String>[
      path,
      if (path.startsWith('storage/')) 'public/$path',
      if (path.startsWith('uploads/')) 'public/$path',
      if (path.startsWith('images/')) 'public/$path',
      if (!path.startsWith('storage/')) 'storage/$path',
      if (!path.startsWith('uploads/')) 'uploads/$path',
      if (!path.startsWith('public/')) 'public/$path',
    ];

    final seen = <String>{};
    final resolved = <String>[];
    for (final candidate in rawCandidates) {
      final url = baseUri.resolve(candidate.replaceAll('//', '/')).toString();
      if (seen.add(url)) resolved.add(url);
    }
    return resolved;
  }

  List<String> _networkUrlVariants(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return <String>[url];

    final normalizedPath = uri.path.replaceAll('\\', '/');
    final variants = <String>[
      uri
          .replace(
            path: normalizedPath.replaceFirst('/uploads/uploads/', '/uploads/'),
          )
          .toString(),
      uri
          .replace(
            path: normalizedPath.replaceFirst('/public/public/', '/public/'),
          )
          .toString(),
      uri
          .replace(
            path: normalizedPath.replaceFirst('/storage/storage/', '/storage/'),
          )
          .toString(),
      uri.toString(),
    ];

    final seen = <String>{};
    return variants.where((v) => seen.add(v)).toList();
  }

  bool _isNetworkUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
