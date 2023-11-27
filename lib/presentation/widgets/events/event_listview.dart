import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/event_repository_provider.dart';

class EventsListView extends StatelessWidget {
  final List<EventEntity> events;

  EventsListView({super.key, required this.events});

  final scrollConstroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollConstroller,
      itemCount: events.length,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return FadeInRight(child: _Slide(event: events[index]));
      },
    );
  }
}

class _Slide extends ConsumerWidget {
  final EventEntity event;
  const _Slide({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(eventRepositoryProvider).getUrlImage(event.name);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, right: 20, left: 20, top: 30),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 10),
                  Image.network(imageUrl, fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                    return (loadingProgress != null)
                        ? const DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black12))
                        : FadeIn(child: child);
                  }, errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/logo.png');
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Fecha: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        event.date,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Lugar: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          event.place,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Hora: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        event.hour ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ])),
          ),
        ),
        Positioned(
            left: 10,
            right: 150,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: AppTheme.colorApp5,
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(event.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
