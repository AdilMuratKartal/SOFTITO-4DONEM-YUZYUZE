import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable //soyut snınflardandır değiştirilemez abstract yaparken yaparız. değiştirilemez sadasd
abstract class CuzdanEvent {
  const CuzdanEvent();
}

class CuzdanYukleEvent extends CuzdanEvent {
  const CuzdanYukleEvent();
}

class ParaYukleEvent extends CuzdanEvent {
  final String baslik;
  final double miktar;

  const ParaYukleEvent({required this.baslik, required this.miktar});
}

class ParaHarcaEvent extends CuzdanEvent {
  final String baslik;
  final double miktar;

  const ParaHarcaEvent({required this.baslik, required this.miktar});
}
