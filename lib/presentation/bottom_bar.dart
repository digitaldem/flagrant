import 'dart:ui';
import 'package:flutter/material.dart';

import './sheets/about.dart';
import './sheets/executive_order.dart';
import './sheets/settings.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.bottomNavigationBarTheme.backgroundColor,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<SheetType>(
                  tooltip: 'Menu',
                  icon: const Icon(Icons.more_vert, size: 30),
                  itemBuilder:
                      (_) => [
                        PopupMenuItem(value: SheetType.about, child: Text(SheetType.about.title)),
                        PopupMenuItem(value: SheetType.executiveOrder, child: Text(SheetType.executiveOrder.title)),
                        PopupMenuItem(value: SheetType.settings, child: Text(SheetType.settings.title)),
                      ],
                  onSelected: (value) => showBottomSheet(context, sheetType: value),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<T?> showBottomSheet<T>(BuildContext context, {required SheetType sheetType}) {
    final theme = Theme.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),
                  Container(width: 40, height: 4, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(sheetType.title, style: theme.textTheme.titleLarge)),
                        IconButton(tooltip: 'Close', icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: theme.dividerColor),
                  // Body
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: sheetType.sheet)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum SheetType {
  about(1),
  executiveOrder(2),
  settings(3);

  final int value;
  const SheetType(this.value);

  String get title {
    switch (value) {
      case 1:
        return 'About';
      case 2:
        return 'Executive Order';
      case 3:
        return 'Settings';
      default:
        return '';
    }
  }

  Widget? get sheet {
    switch (value) {
      case 1:
        return const AboutSheet();
      case 2:
        return const ExecutiveOrderSheet();
      case 3:
        return const SettingsSheet();
      default:
        return null;
    }
  }

  static SheetType? fromInt(int v) {
    return SheetType.values.where((e) => e.value == v).firstOrNull;
  }
}
