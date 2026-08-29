import 'package:flutter/material.dart';
import '../../../../../../core/constant/app_colors.dart';


class AppGradientBar extends StatelessWidget {
  final int selectedIndex; // 0 = فلتر, 1 = نتائج
  final ValueChanged<int> onTabChanged;
  final VoidCallback? onBack;

  const AppGradientBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.navyGradient,
        border: Border(bottom: BorderSide(color: AppColors.gold, width: 3)),
      ),
      padding: EdgeInsets.fromLTRB(18, MediaQuery.of(context).padding.top + 8, 18, 16),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: onBack ?? () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                ),
              ),
              Expanded(
                child: Column(
                  children: const [
                    Text(
                      'صافي أرباح الفروع',
                      style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'تقرير الأرباح حسب الفرع',
                      style: TextStyle(color: Color(0xFFB9C6E0), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.bar_chart_rounded, color: AppColors.goldLight, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: 'الفلتر',
                  selected: selectedIndex == 0,
                  onTap: () => onTabChanged(0),
                ),
                const SizedBox(width: 3),
                _TabButton(
                  label: 'النتائج',
                  selected: selectedIndex == 1,
                  onTap: () => onTabChanged(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? AppColors.navyDark : const Color(0xFFD7DEEC),
            ),
          ),
        ),
      ),
    );
  }
}
