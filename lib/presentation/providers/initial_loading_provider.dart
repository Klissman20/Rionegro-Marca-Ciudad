import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/google_map_provider.dart';

final initialLoadingProvider = Provider((ref) {
  var step1 = ref.watch(userCurrentLocationProvider).latitude == 0;
  var step2 = ref.watch(markersListProvider).isEmpty;

  if (step1 || step2) return true;

  return false;
});
