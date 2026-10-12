
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/category_use_case.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/category_modal/section_title.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/category_modal/color_picker.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/category_modal/icon_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CategoryModal extends StatefulWidget {
  final CategoryUseCase categoryUseCase;
  final FlutterSecureStorage storage;
  final List<Map> categories;
  final void Function(Map category)? addCategory;

  const CategoryModal({
    required this.categoryUseCase,
    required this.storage,
    required this.categories,
    required this.addCategory,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  // Form
  final _formKey = GlobalKey<FormState>();

  String? _nameError;
  String? _iconError;

  // Other
  static const Color _accent = Color(0xFF8E8BBE);

  bool _isSubmitting = false;

  bool _iconErrorFlag = false;

  static const List<Color> _colors = [
    Color(0xFF4A86F7),
    Color(0xFF6EDC50),
    Color(0xFFF5A83D),
    Color(0xFFDB4B45),
    Color(0xFFA62BE8),
    Color(0xFF66D8CE),
    Color(0xFFE07CF2),
    Color(0xFFC4C6DE),
  ];

  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Color _selectedColor = _colors.first;
  String? _selectedIcon;
  late final Future<List<String>> _iconsFuture;

  @override
  void initState() {
    super.initState();
    _iconsFuture = _loadIcons();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введіть назву';
    }

    return null;
  }

  // Подгружает пути всех SVG из assets/categories_icons/light/
  Future<List<String>> _loadIcons() async {
    // информация обо всех ассетах, который Flutter включил в приложение (те, что указаны в pubspec.yaml)
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    // rootBundle - стандартный Flutter-объект,
    // через который приложение получает доступ к ресурсам

    // manifest.listAssets() - получение путей всех ассетов
    // .where() - фильтрация тех путей, который содержат «assets/categories_icons/light/» и «.svg»
    final icons =
        manifest
            .listAssets()
            .where(
              (p) =>
                  p.startsWith('assets/categories_icons/light/') &&
                  p.endsWith('.svg'),
            )
            .toList()
          ..sort(); // вызов .sort() у только что созданного списка (созданного через .toList())
    return icons;
  }

  String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty && _selectedIcon != null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _iconErrorFlag = _selectedIcon == null);
      return;
    }

    if (_selectedIcon == null) {
      setState(() => _iconErrorFlag = true);
      return;
    }

    if (_isSubmitting) return;

    setState(() => _iconErrorFlag = false);
    setState(() => _isSubmitting = true);

    final session = await widget.storage.read(key: "session");

    final enteredData = {
      "color": colorToHex(_selectedColor),
      "name": _nameController.text.trim(),
      "icon": _selectedIcon!.split("/").last,
    };

    final result = await widget.categoryUseCase.sendCreateCategoryRequest(enteredData, session);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result["success"] == true) {
      final categoryData = {
        "id": result["data"]["id"],
        "color": result["data"]["color"],
        "name": result["data"]["name"],
        "icon": result["data"]["icon"],
      };

      widget.addCategory?.call(categoryData);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } else if (result.keys.contains("error") && result.keys.contains("field")) {
      if (result["field"] == "name") {
        setState(() {
          _nameError = result["error"];
        });
      } else if (result["field"] == "icon") {
        setState(() {
          _iconError = result["error"];
          _iconErrorFlag = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = (screenHeight - 150).clamp(200.0, double.infinity);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight), 
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Скроллируемая часть
                Flexible(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(right: 8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Створіть категорію',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const SectionTitle('Колір'),
                            const SizedBox(height: 10),
                            ColorPicker(
                              colors: _colors,
                              selected: _selectedColor,
                              onSelected: (c) =>
                                  setState(() => _selectedColor = c),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              validator: _validateName,
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Назва',
                                labelStyle: const TextStyle(color: _accent),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0DEEA),
                                  ),
                                ),
                                errorText: _nameError,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0DEEA),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _accent),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const SectionTitle('Іконка'),
                                if (_iconErrorFlag) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    _iconError ?? 'Оберіть іконку',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder<List<String>>(
                              future: _iconsFuture,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox(height: 80);
                                }
                                return IconPicker(
                                  icons: snapshot.data!,
                                  selected: _selectedIcon,
                                  selectedColor: Colors.deepOrange,
                                  // i - выбранная иконка (путь)
                                  onSelected: (i) =>
                                      setState(() => _selectedIcon = i),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Кнопки (закреплены внизу)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: _accent,
                          side: const BorderSide(color: _accent, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Скасувати'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _canSubmit ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _accent.withValues(
                            alpha: 0.7,
                          ),
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Готово'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
