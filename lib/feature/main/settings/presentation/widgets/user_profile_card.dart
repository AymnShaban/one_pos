part of '../../settings_imports.dart';

class UserProfileCard extends StatelessWidget {
  final UserSettingsModel user;
  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mainAppColor, AppColors.tealAccentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Top row: name + avatar
          Row(
            children: [
              // Avatar
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.25),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.white,
                  size: 36.sp,
                ),
              ),
              SizedBox(width: 16.w),
              // Name + role + branch
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: AppTextTheme.titleSmallBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      user.role,
                      style: AppTextTheme.body2.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      user.branch,
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Divider
          Divider(color: AppColors.white.withValues(alpha: 0.3), height: 1),
          SizedBox(height: 14.h),

          // Bottom row: last login + online badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings.last_login'.tr(),
                    style: AppTextTheme.labelMedium11.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    user.lastLogin,
                    style: AppTextTheme.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Online toggle badge
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user.isOnline
                            ? AppColors.green
                            : AppColors.redDynamic,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      user.isOnline
                          ? 'settings.online'.tr()
                          : 'settings.offline'.tr(),
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Last login

            ],
          ),
        ],
      ),
    );
  }
}