import 'dart:math';

import 'package:flutter/material.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/category_use_case.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/category_modal/category_modal.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/event_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HudRadialMenu extends StatefulWidget {
  final FlutterSecureStorage storage;

  // Categories
  final void Function(Map category)? addCategory;
  final List<Map> categories;
  final CategoryUseCase categoryUseCase;
  
  // Events
  final MainScreenEventUseCase mainScreenEventUseCase;
  final List<Map> events;
  final void Function(Map event)? addEvent;

  // User data
  final Map userData;

  const HudRadialMenu({
    required this.categoryUseCase,
    required this.mainScreenEventUseCase,
    required this.storage,
    required this.categories,
    required this.addCategory,
    required this.addEvent,
    required this.events,
    required this.userData,
    super.key,
  });

  @override
  State<HudRadialMenu> createState() => _HudRadialMenuState();
}

class _HudRadialMenuState extends State<HudRadialMenu> {
  bool _isOpen = false;

  final double _radius = 75;
  final itemSize = 40.0;
  late List _items;

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  void initState() {
    super.initState();

    _items = [
      {
        "label": "Категорія",
        "icon": Icons.category,
        "on_pressed": () => showDialog(
          context: context,
          builder: (context) {
            return CategoryModal(
              categoryUseCase: widget.categoryUseCase,
              storage: widget.storage,
              categories: widget.categories,
              addCategory: widget.addCategory,
            );
          },
        ),
      },
      {
        "label": "Подія",
        "icon": Icons.event,
        "on_pressed": () => showDialog(
          context: context,
          builder: (context) {
            return EventModal(
              categories: widget.categories,
              events: widget.events,
              mainScreenEventUseCase: widget.mainScreenEventUseCase,
              storage: widget.storage,
              addEvent: widget.addEvent,
              userData: widget.userData,
            );
          },
        ),
      },
    ];
  }

  double _calculateMenuSize() {
    return _radius * 2 + itemSize;
  }

  @override
  Widget build(BuildContext context) {
    final step = 180 / _items.length;

    final menuSize = _calculateMenuSize();

    return Positioned(
      right: -60,
      bottom: 15,
      child: SizedBox(
        width: menuSize,
        height: menuSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isOpen)
              for (int i = 0; i < _items.length; i++)
                _buildItem(
                  label: _items[i]["label"] as String,
                  icon: _items[i]["icon"] as IconData,
                  angle: step * i,
                  onPressed: _items[i]["on_pressed"],
                ),
            SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                shape: CircleBorder(),
                onPressed: _toggleMenu,
                backgroundColor: const Color(0xFFFF6B00),
                foregroundColor: Colors.white,
                child: Icon(_isOpen ? Icons.close : Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String label,
    required IconData icon,
    required double angle,
    VoidCallback? onPressed,
  }) {
    final radians = angle * pi / 180;

    double x = -_radius * sin(radians);
    double y = -_radius * cos(radians);

    return Positioned(
      right: _radius - x,
      bottom: _radius - y,
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: FloatingActionButton(onPressed: onPressed, child: Icon(icon)),
      ),
    );
  }
}
