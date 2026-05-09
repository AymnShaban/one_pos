import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/helper/helper.dart';

class AvailableContainer extends StatelessWidget {
  const AvailableContainer({super.key, required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 30,
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.mainAppColor : AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          isAvailable ? 'available'.tr() : 'unavailable'.tr(),
          style: AppTextTheme.labelSmall.copyWith(color: AppColors.white1),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}