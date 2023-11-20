import 'package:flutter/material.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/map/map_screen.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/map/image_slideshow.dart';

class DialogDetails extends StatelessWidget {
  final MarkerEntity marker;
  final Routes selectedRoute;

  const DialogDetails(
      {super.key, required this.marker, required this.selectedRoute});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, right: 20, left: 20, top: 30),
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 10),
                    ImageSlideShow(imageList: [Image.asset('assets/logo.png')]),
                    const SizedBox(height: 10),
                    Text(
                      marker.description,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ]),
                )),
          ),
        ),
        Positioned(
            top: 95,
            left: 90,
            right: 80,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: selectedRoute.color,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(marker.name,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            )),
        Positioned(top: 80, left: 20, child: selectedRoute.logo),
        Positioned(
            top: 100,
            right: 20,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: selectedRoute.color),
              child: Center(
                child: IconButton(
                    color: Colors.white,
                    iconSize: 20,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded)),
              ),
            )),
      ],
    );
  }
}
