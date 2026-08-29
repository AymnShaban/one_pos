
import '../helper/helper.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final Widget? accentIcon;

  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions = const [],
    this.accentIcon,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 56.h : 72.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 14.h),
          child: Row(
            children: [
              if (onBack != null)
                _CircleIconButton(icon: Icons.arrow_back_ios_new, onTap: onBack!)
              else
                SizedBox(width: 34.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (accentIcon != null) accentIcon! else SizedBox(width: 34.w),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? background;
  const _CircleIconButton({required this.icon, required this.onTap, this.background});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: background ?? Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: Colors.white, size: 16.sp),
      ),
    );
  }
}

/// زر أيقونة دائري شفاف يستخدم كأزرار إجراءات (طباعة، قائمة...) داخل الشريط.
class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? background;
  const AppBarIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: _CircleIconButton(icon: icon, onTap: onTap, background: background),
    );
  }
}
