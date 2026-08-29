part of '../../settings_imports.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettings());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<SettingsBloc, BaseState<UserSettingsModel>>(
        listener: (context, state) {
          if (state.metadata['action'] == 'logout') {
            // Navigate to login — wire to your router
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => getIt<LoginBloc>(),
                  child: const LoginScreen(),
                ),
              ),
            );
          }
          if (state.metadata['action'] == 'reset_activation') {
            // Navigate to activation screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) {
                    final bloc = getIt<ActivationBloc>();
                    bloc.initDevice(context);
                    return bloc;
                  },
                  child: const ActivationScreen(),
                ),
              ),
            );

            showCustomSnackBar(context, 'settings.reset_success'.tr());

          }
        },
        builder: (context, state) {
          final user = state.items.isNotEmpty
              ? state.items.first
              : const UserSettingsModel();
          const systemInfo = SystemInfoModel(
            appVersion: 'v2.5.1',
            buildNumber: '20260307',
            lastSync: 'منذ ٥ دقائق',
            isConnected: true,
          );

          return CustomScrollView(
            slivers: [
              HomeAppBar(isOnline: context.read<HomeBloc>().isOnline),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Page title ──
                      Text(
                        'settings.title'.tr(),
                        style: AppTextTheme.heading1.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'settings.subtitle'.tr(),
                        style: AppTextTheme.body2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── User profile card ──
                      UserProfileCard(user: user),
                      SizedBox(height: 20.h),

                      // ── Account section ──
                      SettingsSection(
                        title: 'settings.account'.tr(),
                        tiles: [
                          SettingsTile(
                            icon: Icons.person_outline_rounded,
                            iconColor: AppColors.mainAppColor,
                            title: 'settings.user_info'.tr(),
                            subtitle: user.fullName,
                            onTap: () {},
                          ),
                          SettingsTile(
                            icon: Icons.storefront_outlined,
                            iconColor: AppColors.green,
                            title: 'settings.branch'.tr(),
                            subtitle: user.branch,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── System section ──
                      SettingsSection(
                        title: 'settings.system'.tr(),
                        tiles: [
                          SettingsTile(
                            icon: Icons.storage_rounded,
                            iconColor: AppColors.purple,
                            title: 'settings.update_database'.tr(),
                            onTap: () => context.read<SettingsBloc>().add(
                              const UpdateDatabase(),
                            ),
                          ),
                          SettingsTile(
                            icon: Icons.restart_alt_rounded,
                            iconColor: Colors.orange,
                            title: 'settings.reset_activation'.tr(),
                            subtitle: 'settings.reset_activation_subtitle'.tr(),
                            onTap: () => _showResetActivationDialog(context),
                          ),
                          SettingsTile(
                            icon: Icons.notifications_outlined,
                            iconColor: AppColors.secondaryColor,
                            title: 'settings.notifications'.tr(),
                            subtitle: 'settings.notifications_enabled'.tr(),
                            onTap: () => context.read<SettingsBloc>().add(
                              const ToggleNotifications(),
                            ),
                          ),
                          SettingsTile(
                            icon: Icons.print_outlined,
                            iconColor: AppColors.mainAppColor,
                            title: 'settings.print_settings'.tr(),
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── Info section ──
                      SettingsSection(
                        title: 'settings.information'.tr(),
                        tiles: [
                          SettingsTile(
                            icon: Icons.info_outline_rounded,
                            iconColor: AppColors.grey,
                            title: 'settings.about_app'.tr(),
                            subtitle: systemInfo.appVersion,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── System info card ──
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'settings.system_info'.tr(),
                          style: AppTextTheme.body2Bold.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SystemInfoCard(info: systemInfo),
                      SizedBox(height: 24.h),

                      // ── App branding ──
                      _AppBranding(),
                      SizedBox(height: 16.h),

                      // ── Logout button ──
                      _LogoutButton(onTap: () => _showLogoutDialog(context)),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        'common.logout_confirmation'.tr(),
        textAlign: TextAlign.center,
        style: AppTextTheme.body2Bold.copyWith(color: AppColors.black),
      ),
      content: Icon(Icons.logout_rounded, size: 48.sp, color: AppColors.red),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'common.cancel'.tr(),
                  style: AppTextTheme.body2.copyWith(color: AppColors.grey),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => BlocProvider(
                        create: (_) => getIt<LoginBloc>(),
                        child: const LoginScreen(),
                      )));

                },
                child: Text(
                  'common.confirm'.tr(),
                  style: AppTextTheme.body2Bold.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
void _showResetActivationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.all(24.w),
        title: Column(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restart_alt_rounded,
                color: Colors.orange,
                size: 34.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'settings.reset_activation_title'.tr(),
              textAlign: TextAlign.center,
              style: AppTextTheme.body1Bold.copyWith(
                color: AppColors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'settings.reset_activation_message'.tr(),
          textAlign: TextAlign.center,
          style: AppTextTheme.body2.copyWith(
            color: AppColors.grey,
            height: 1.5,
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(
          16.w,
          0,
          16.w,
          16.h,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.backgroundColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 13.h,
                    ),
                  ),
                  child: Text(
                    'common.cancel'.tr(),
                    style: AppTextTheme.body2Bold.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    context.read<SettingsBloc>().add(
                      const ResetActivationRequested(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 13.h,
                    ),
                  ),
                  child: Text(
                    'settings.reset'.tr(),
                    style: AppTextTheme.body2Bold.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
// ── App Branding ─────────────────────────────────────────────────────────────
class _AppBranding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(AppAssets.appLogo),
              fit: BoxFit.contain,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.tealAccentColor, width: 3),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'The One POS',
          style: AppTextTheme.titleSmallBold.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 4.h),
        Text(
          'home.pos_subtitle'.tr(),
          style: AppTextTheme.body2.copyWith(color: AppColors.grey),
        ),
        SizedBox(height: 4.h),
        Text(
          'settings.app_description'.tr(),
          style: AppTextTheme.caption.copyWith(color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Divider(color: AppColors.backgroundColor, thickness: 1),
        SizedBox(height: 8.h),
        Text(
          'settings.copyright'.tr(),
          style: AppTextTheme.caption.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}

// ── Logout Button ─────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.redBg,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.red, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'settings.logout'.tr(),
              style: AppTextTheme.body2Bold.copyWith(color: AppColors.red),
            ),
          ],
        ),
      ),
    );
  }
}
