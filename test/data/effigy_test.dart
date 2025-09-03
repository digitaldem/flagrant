import 'package:flutter_test/flutter_test.dart';
import 'package:flagrant/data/effigy.dart';

void main() {
  group('Effigy', () {
    const base = Effigy(image: 'assets/images/flag.png', lottie: 'assets/lottie/fire.json', xScale: 1.0, yScale: 1.0, showBottomBar: true);

    test('constructs with given fields', () {
      expect(base.image, 'assets/images/flag.png');
      expect(base.lottie, 'assets/lottie/fire.json');
      expect(base.xScale, 1.0);
      expect(base.yScale, 1.0);
      expect(base.showBottomBar, isTrue);
    });

    test('copyWith returns a new instance with overrides', () {
      final copy = base.copyWith(image: 'assets/images/alt.png', xScale: 0.75, showBottomBar: false);

      // Ensure immutability
      expect(base.image, 'assets/images/flag.png');
      expect(base.xScale, 1.0);
      expect(base.showBottomBar, isTrue);

      // Check new object has selected updates
      expect(copy.image, 'assets/images/alt.png');
      expect(copy.lottie, 'assets/lottie/fire.json'); // preserved
      expect(copy.xScale, 0.75);
      expect(copy.yScale, 1.0); // preserved
      expect(copy.showBottomBar, isFalse);

      // Ensure not the same reference
      expect(identical(base, copy), isFalse);
    });

    test('copyWith with no args returns an equal (but distinct) object', () {
      final copy = base.copyWith();
      expect(copy, equals(base));
      expect(identical(copy, base), isFalse);
    });

    test('equality uses all fields', () {
      const a = Effigy(image: 'img', lottie: 'lot', xScale: 1.2, yScale: 0.8, showBottomBar: false);
      const b = Effigy(image: 'img', lottie: 'lot', xScale: 1.2, yScale: 0.8, showBottomBar: false);
      const c = Effigy(image: 'img2', lottie: 'lot', xScale: 1.2, yScale: 0.8, showBottomBar: false);

      // Reflexive equality
      expect(a, equals(a));
      expect(b, equals(a));
      expect(identical(a, b), isTrue);

      // Inequality
      expect(a == c, isFalse);

      // Compare to other types
      expect(a == Object(), isFalse);
    });

    test('hashCode matches equality', () {
      const a = Effigy(image: 'img', lottie: 'lot', xScale: 1.2, yScale: 0.8, showBottomBar: false);
      const b = Effigy(image: 'img', lottie: 'lot', xScale: 1.2, yScale: 0.8, showBottomBar: false);
      const c = Effigy(image: 'img', lottie: 'lot', xScale: 1.21, yScale: 0.8, showBottomBar: false);

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode == c.hashCode, isFalse);
    });

    test('toString contains all fields in expected format', () {
      const e = Effigy(image: 'i', lottie: 'l', xScale: 2.0, yScale: 3.0, showBottomBar: true);

      // Pre-defined format
      expect(e.toString(), 'Effigy(image: i, lottie: l, xScale: 2.0, yScale: 3.0, showBottomBar: true)');
    });
  });
}
