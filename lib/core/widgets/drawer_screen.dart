import '../helper/helper.dart';
import '../services/service_locator/services_imports.dart';
import 'language_toggle_button.dart';


class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ColoredBox(
        color: AppColors.white,
        child: Column(
          children: [

            SizedBox(height: 40.h),
            getIt<IUserCache>().getProfileImage() != null
                ? CircleAvatar(
                    radius: 50.r,
                    backgroundImage:
                        FileImage(File(getIt<IUserCache>().getProfileImage()!)),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(AppAssets.appLogo, height: 100)),

            // 66206215
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const Divider(height: 32, thickness: 1),
                  LanguageDropdownSection(),
                  const Divider(height: 32, thickness: 1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Version 1.0.0",
                    style: AppTextTheme.captionBold.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDrawerItem(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String title,
  //   required Color iconColor,
  //   required VoidCallback onTap,
  // }) {
  //   return ListTile(
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
  //     leading: Icon(icon, color: iconColor, size: 24),
  //     title: Text(
  //       title,
  //       style: AppTextTheme.body1.copyWith(color: AppColors.mainAppColor),
  //     ),
  //     onTap: onTap,
  //   );
  // }
}
