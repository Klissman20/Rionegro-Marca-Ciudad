import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/map/map_screen.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/map/image_slideshow.dart';

class DialogDetails extends ConsumerStatefulWidget {
  final MarkerEntity marker;
  final Routes selectedRoute;
  final int category;
  final Future<void> Function(MarkerEntity) getPolyline;
  final Future<void> Function(PointLatLng?) setLocation;
  final Function(String) onInstagramSelected;
  final Function(String, String?) onWhatsappSelected;

  const DialogDetails(
      {super.key,
      required this.marker,
      required this.selectedRoute,
      required this.category,
      required this.getPolyline,
      required this.setLocation,
      required this.onInstagramSelected,
      required this.onWhatsappSelected});

  @override
  _DialogDetailsState createState() => _DialogDetailsState();
}

class _DialogDetailsState extends ConsumerState<DialogDetails> {

  late PointLatLng myLocation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 85.0, right: 20, left: 20, top: 30),
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 10),
                    ImageSlideShow(imageList: [
                      widget.marker.image ?? Image.asset('assets/logo.png')
                    ]),
                    Text(
                      widget.marker.description,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ]),
                )),
          ),
        ),
        Positioned(
            top: 75,
            left: 90,
            right: 80,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: widget.selectedRoute.color,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(widget.marker.name,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            )),
        Positioned(top: 60, left: 20, child: widget.selectedRoute.logo),
        Positioned(
            top: 80,
            right: 20,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: widget.selectedRoute.color),
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
        Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (widget.category == 1)
                      ? InkWell(
                          onTap: () async {
                            await widget.onInstagramSelected(
                                widget.marker.urlInstagram ?? '');
                          },
                          child: CustomDialogButton(
                              marker: widget.marker,
                              selectedRoute: widget.selectedRoute,
                              name: 'Instagram'),
                        )
                      : const SizedBox(),
                  (widget.category == 1)
                      ? InkWell(
                          onTap: () async {
                            if (widget.marker.celphone != 0) {
                              await widget.onWhatsappSelected(
                                  widget.marker.celphone.toString(), null);
                            }
                            return;
                          },
                          child: CustomDialogButton(
                              marker: widget.marker,
                              selectedRoute: widget.selectedRoute,
                              name: 'WhatsApp'),
                        )
                      : const SizedBox()
                ],
              ),
            )),
        Positioned(
            bottom: (widget.category == 1) ? 110 : 130,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied) {
                          // Permissions are denied, next time you could try
                          // requesting permissions again (this is also where
                          // Android's shouldShowRequestPermissionRationale
                          // returned true. According to Android guidelines
                          // your App should show an explanatory UI now.
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: 'Location permissions are denied',
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return const Center(
                                child: Text(
                                  'Location permissions are denied',
                                )
                              );
                            }
                          );
                        }
                      }

                      if (permission == LocationPermission.deniedForever) {
                        // Permissions are denied forever, handle appropriately.
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
              
                          barrierLabel: 'Location permissions are permanently denied, we cannot request permissions.',
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return AlertDialog(
                              title: Text('Aviso!'),
                              content: Text(
                                'Se necesitan permisos de ubicación para continuar. Ve a ajustes y habilita los permisos de ubicación'
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok'))
                              ]
                            );
                              
                          }
                        );
                      }

                      //myLocation = ref.read(userCurrentLocationProvider);
                      //await widget.setLocation(myLocation);
                      // When we reach here, permissions are granted and we can
                      // continue accessing the position of the device.
                      const LocationSettings locationSettings = LocationSettings(
                        accuracy: LocationAccuracy.high,
                        //distanceFilter: 100,
                      );

                      await widget.getPolyline(widget.marker).then((value) {
                        Navigator.of(context).pop();
                      });
                      setState(() {});
                    },
                    child: CustomDialogButton(
                      name: 'Cómo llegar',
                      marker: widget.marker,
                      selectedRoute: widget.selectedRoute,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class CustomDialogButton extends StatelessWidget {
  final String name;
  final MarkerEntity marker;
  final Routes selectedRoute;
  const CustomDialogButton(
      {super.key,
      required this.marker,
      required this.selectedRoute,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      decoration: BoxDecoration(
          color: selectedRoute.color,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            selectedRoute.minilogo,
            Text(name,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
