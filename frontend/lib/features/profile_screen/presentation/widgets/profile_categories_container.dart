import 'package:flutter/material.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_category_item.dart';

class ProfileCategoriesContainer extends StatelessWidget {
  final List<ProfileCategoryItem> categories;

  const ProfileCategoriesContainer({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          if (categories.isNotEmpty)
            for (int i = 0; i < categories.length; i++) ...[
              categories[i],
              if (i < categories.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Divider(height: 1, color: Color(0xFFE9EAF1)),
                ),
            ],

          if (categories.isEmpty)
            Text(
              "Категорії відсутні",
              style: TextStyle(
                backgroundColor: const Color(0xFFF1F0FB),
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}
