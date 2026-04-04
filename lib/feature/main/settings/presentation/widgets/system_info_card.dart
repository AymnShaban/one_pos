part of '../../settings_imports.dart';

class SystemInfoCard extends StatelessWidget {
  final SystemInfoModel info;
  const SystemInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            label: 'settings.app_version'.tr(),
            value: info.appVersion,
            valueColor: AppColors.black,
          ),
          SizedBox(height: 10.h),
          _InfoRow(
            label: 'settings.build_number'.tr(),
            value: info.buildNumber,
            valueColor: AppColors.black,
          ),
          SizedBox(height: 10.h),
          _InfoRow(
            label: 'settings.last_sync'.tr(),
            value: info.lastSync.isEmpty
                ? 'settings.few_minutes_ago'.tr()
                : info.lastSync,
            valueColor: AppColors.green,
          ),
          SizedBox(height: 10.h),
          _InfoRow(
            label: 'settings.connection_status'.tr(),
            value: info.isConnected
                ? 'settings.online'.tr()
                : 'settings.offline'.tr(),
            valueColor: info.isConnected ? AppColors.green : AppColors.red,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [ Text(
        label,
        style: AppTextTheme.body2.copyWith(color: AppColors.grey),
      ),
        Text(
          value,
          style: AppTextTheme.body2Bold.copyWith(color: valueColor),
        ),

      ],
    );
  }
}