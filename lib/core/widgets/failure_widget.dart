import 'package:easy_localization/easy_localization.dart';

import '../helper/helper.dart';
import '../theme/app_text_theme.dart';

class FailureWidget extends StatelessWidget {

  final BaseState state;
  final Function() onRetry;
  final String errorMessage;

  const FailureWidget({
    super.key, required this.state, required this.onRetry, required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.errorMessage ?? errorMessage,
            style: AppTextTheme.body1.copyWith(
              color: AppColors.red,
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(
              'Retry'.tr(),
              style: AppTextTheme.body1,
            ),
          ),
        ],
      ),
    );
  }
}