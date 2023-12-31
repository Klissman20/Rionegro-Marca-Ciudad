import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ImageSlideShow extends StatelessWidget {
  final List<Image> imageList;

  const ImageSlideShow({super.key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Swiper(
        loop: false,
        viewportFraction: 1,
        scale: 0.9,
        autoplay: false,
        duration: 1200,
        curve: Curves.easeInOutCubic,
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          final image = imageList[index];
          return _Slide(image: image);
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Image image;
  const _Slide({required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(0, 8))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                  image: image.image,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    return (loadingProgress != null)
                        ? const DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black12))
                        : FadeIn(child: child);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/logo.png');
                  }),
            )));
  }
}
