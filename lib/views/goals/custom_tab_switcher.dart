import 'package:flutter/material.dart';

class CustomTabSwitcher extends StatelessWidget {
  final bool isGeneralSelected; // Hangi tab aktif?
  final Function(bool) onTabChanged; // Tıklanınca ne olsun?

  const CustomTabSwitcher({
    super.key,
    required this.isGeneralSelected,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              )
            : Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.black,
                0.1,
              ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildTabItem(context, "General", isGeneralSelected),
          SizedBox(width: 5),
          _buildTabItem(context, "Subjects", !isGeneralSelected),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(title == "General"),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
