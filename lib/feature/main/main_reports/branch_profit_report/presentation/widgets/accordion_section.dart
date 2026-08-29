import 'package:flutter/material.dart';
import '../../../../../../core/constant/app_colors.dart';

class AccordionSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  /// Matches the beige "مبيعات يومية" highlighted card in the design.
  final bool sand;

  const AccordionSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.sand = false,
  });

  @override
  State<AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<AccordionSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final background = widget.sand ? AppColors.sand : Colors.white;
    final borderColor = widget.sand ? AppColors.sandLine : AppColors.lineColor;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: AppColors.navyMid,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: _expanded ? AppColors.gold : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
