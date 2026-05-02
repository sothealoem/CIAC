import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:shimmer/shimmer.dart';
import 'package:schoolapp/views/dashboard/widgets/slide_image.dart';

class DashboardSliderSection extends StatefulWidget {
  const DashboardSliderSection({super.key, required this.height});

  final double height;

  @override
  State<DashboardSliderSection> createState() => _DashboardSliderSectionState();
}

class _DashboardSliderSectionState extends State<DashboardSliderSection> {
  bool _isLoading = true;
  List<String> _images = const [];

  @override
  void initState() {
    super.initState();
    _loadSliderImages();
  }

  Future<void> _loadSliderImages() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final d.Response res = await Get.find<ApiService>().get(
        EndPoints.sliders,
        isShowLoading: false,
      );

      if (res.data is! Map) {
        if (!mounted) return;
        setState(() {
          _images = const [];
          _isLoading = false;
        });
        return;
      }

      final map = Map<String, dynamic>.from(res.data as Map);
      final rawData = map['data'];
      if (rawData is! List) {
        if (!mounted) return;
        setState(() {
          _images = const [];
          _isLoading = false;
        });
        return;
      }

      final urls = rawData
          .whereType<dynamic>()
          .map((e) {
            if (e is Map<String, dynamic>) {
              return (e['banner'] ?? '').toString().trim();
            }
            if (e is Map) {
              final item = Map<String, dynamic>.from(e);
              return (item['banner'] ?? '').toString().trim();
            }
            return '';
          })
          .where((e) => e.isNotEmpty)
          .toList(growable: false);

      if (!mounted) return;
      setState(() {
        _images = urls;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _images = const [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE3E8EE),
          highlightColor: const Color(0xFFF5F7FA),
          child: Container(
            height: widget.height,
            color: Colors.white,
          ),
        ),
      );
    }

    if (_images.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFE9EEF2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: IconButton(
          tooltip: 'Reload banners',
          icon: const Icon(Icons.refresh, color: Colors.grey),
          onPressed: _loadSliderImages,
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: PremiumSlider(imagesList: _images),
    );
  }
}
