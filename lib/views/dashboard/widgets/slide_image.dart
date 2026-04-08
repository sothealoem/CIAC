import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/app_style.dart';

class PremiumSlider extends StatefulWidget {
  const PremiumSlider({super.key, required this.imagesList});
  final List<String> imagesList;
  @override
  State<PremiumSlider> createState() => _PremiumSliderState();
}

class _PremiumSliderState extends State<PremiumSlider> {
  int _current = 0;
  final CarouselSliderController _sliderRef = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders =
        widget.imagesList.asMap().entries.map((entry) {
          String item = entry.value;
          int index = entry.key + 1;

          return GestureDetector(
            onTap: () {
              // Get.toNamed('/promos/$index');
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.cover,
                    height: 350,

                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => const ShimmerPreloader(),
                    errorWidget:
                        (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                    // Optional: fade in/out for better UX
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    // Optional: image cache options
                    cacheKey: item,
                    useOldImageOnUrlChange: true,
                  ),
                ],
              ),
            ),
          );
        }).toList();

    return Column(
      children: [
        /// TITLE

        /// CAROUSEL SLIDER IMAGES
        SizedBox(
          // height: 180,
          child: ClipRRect(
            child: CarouselSlider(
              items: imageSliders,
              carouselController: _sliderRef,
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 10),
                initialPage: 0,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                pauseAutoPlayOnTouch: true,
                // height: 180,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.imagesList.asMap().entries.map((entry) {
                int curSlide = entry.key;
                return GestureDetector(
                  onTap: () => _sliderRef.animateToPage(curSlide),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: _current == curSlide ? 30 : 12,
                    height: 11.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 2.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.primary.withValues(
                        alpha: _current == curSlide ? 0.9 : 0.2,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class ShimmerPreloader extends StatelessWidget {
  const ShimmerPreloader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.white),
    );
  }
}
