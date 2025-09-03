import 'package:meta/meta.dart';

import '../domain/effigy.dart';

@immutable
class Effigy implements IEffigy {
  @override
  final String image;
  @override
  final String lottie;
  @override
  final double xScale;
  @override
  final double yScale;
  @override
  final bool showBottomBar;

  const Effigy({required this.image, required this.lottie, required this.xScale, required this.yScale, required this.showBottomBar});

  Effigy copyWith({String? image, String? lottie, double? xScale, double? yScale, bool? showBottomBar}) {
    return Effigy(
      image: image ?? this.image,
      lottie: lottie ?? this.lottie,
      xScale: xScale ?? this.xScale,
      yScale: yScale ?? this.yScale,
      showBottomBar: showBottomBar ?? this.showBottomBar,
    );
  }

  @override
  String toString() => 'Effigy(image: $image, lottie: $lottie, xScale: $xScale, yScale: $yScale, showBottomBar: $showBottomBar)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Effigy &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          lottie == other.lottie &&
          xScale == other.xScale &&
          yScale == other.yScale &&
          showBottomBar == other.showBottomBar;

  @override
  int get hashCode => image.hashCode ^ lottie.hashCode ^ xScale.hashCode ^ yScale.hashCode ^ showBottomBar.hashCode;
}
