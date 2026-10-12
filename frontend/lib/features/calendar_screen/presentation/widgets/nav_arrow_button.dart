import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final String path;

  const NavArrowButton({
    super.key,
    required this.onTap,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: SizedBox(
          width: 16,
          height: 16,
          child: SvgPicture.asset(path),
        ),
      ),
    );
  }
}
