import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SmallPhotoSlider extends StatelessWidget {
  final List<String> imgList = [
    'asset/caru_slider/caru1.png',
    'asset/caru_slider/caru2.png',
    'asset/caru_slider/caru3.png',
    'asset/caru_slider/caru4.png',
    'asset/caru_slider/caru5.png',
    'asset/caru_slider/caru6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(milliseconds: 2000), // Adjust the interval as needed
        aspectRatio: 3,
        enlargeCenterPage: true,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
      ),
      items: imgList.map((item) => Container(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
            child: Image.asset(item, fit: BoxFit.cover, width: 1300),
          ),
        ),
      )).toList(),
    );
  }
}