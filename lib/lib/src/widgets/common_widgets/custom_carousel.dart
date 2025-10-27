import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel<T> extends StatelessWidget {
  final List<T> items;
  final double height;
  final bool isHorizontal;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const CustomCarousel({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.height = 200,
    this.isHorizontal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, index, realIndex) {
        return itemBuilder(context, items[index], index);
      },
      options: CarouselOptions(
        height: height,

        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        enlargeCenterPage: true, // makes center bigger
        viewportFraction: 0.5, // 3 items visible at a time
        enableInfiniteScroll: false,
      ),
    );
  }
}
