import 'package:flutter/material.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/map/map_screen.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/map/image_slideshow.dart';

class DialogDetails extends StatefulWidget {
  final MarkerEntity marker;
  final Routes selectedRoute;
  final int category;
  final Future<void> Function(MarkerEntity) getPolyline;
  final Function(String) onInstagramSelected;

  const DialogDetails(
      {super.key,
      required this.marker,
      required this.selectedRoute,
      required this.category,
      required this.getPolyline,
      required this.onInstagramSelected});

  @override
  State<DialogDetails> createState() => _DialogDetailsState();
}

class _DialogDetailsState extends State<DialogDetails> {
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
                    bottom: 65.0, right: 20, left: 20, top: 30),
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
            top: 95,
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
        Positioned(top: 80, left: 20, child: widget.selectedRoute.logo),
        Positioned(
            top: 100,
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
            bottom: 140,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await widget.getPolyline(widget.marker).then((value) {
                      setState(() {});
                      Navigator.of(context).pop();
                    });
                  },
                  child: CustomDialogButton(
                    name: 'Cómo llegar',
                    marker: widget.marker,
                    selectedRoute: widget.selectedRoute,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
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
                    : const SizedBox()
              ],
            ))
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
