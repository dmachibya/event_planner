import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  BannerCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int pageIndex = 0;

  List<String> items = ["Book at a easy", "Available for your events"];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.width;

    double bannerWidth = MediaQuery.of(context).size.width - 34;
    double bannerHeight = bannerWidth * (283 / 380);

    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (context, index, pageIndex) => Container(
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.bottomLeft,
              width: bannerWidth,
              height: bannerHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/pattern.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: bannerWidth * (44 / 380) +
                      (screenWidth > screenHeight ? 40 : 0),
                  bottom: screenWidth > screenHeight
                      ? 40
                      : bannerHeight * (78 / 283),
                ),
                child: Text(
                  items[index],
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            options: CarouselOptions(
              initialPage: 0,
              height: screenWidth > screenHeight ? 150 : (bannerHeight + 20),
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  pageIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: screenWidth > screenHeight ? 40 : bannerHeight * (50 / 303),
            left: 33,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  items.length,
                  (index) => AnimatedContainer(
                    margin: const EdgeInsets.only(right: 6),
                    duration: const Duration(milliseconds: 400),
                    width: index == pageIndex ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == pageIndex ? Colors.purple : Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(100),
                    ),
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
