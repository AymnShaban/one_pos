import 'package:easy_localization/easy_localization.dart';
import '../../core/extension/context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/helper.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phoneNumber) async {
    // Remove leading zero and add country code (Egypt +20)
    final whatsappNumber = phoneNumber.startsWith('0')
        ? '2${phoneNumber.substring(1)}'
        : phoneNumber;

    final Uri whatsappUri = Uri.parse('https://wa.me/$whatsappNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'could_not_launch_whatsapp'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                size: 100,
                color: AppColors.mainAppColor,
              ),
              SizedBox(height: 25),
              Text(
                'support_contact_number'.tr(),
                style: AppTextTheme.headlineMedium
              ),
              SizedBox(height: 20),
              Text(
                '01159099087',
                style: AppTextTheme.headlineMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,

              ),
              SizedBox(height: 25),

              // Call Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await _makePhoneCall('01159099087');
                    } catch (e) {
                      if (context.mounted) {
                        context.showTopSnackBar(
                          child:Text( 'call_failed'.tr()),
                          backgroundColor: AppColors.red,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.phone, size: 24),
                  label: Text(
                    'call_now'.tr(),
                    style: AppTextTheme.body1.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),

            SizedBox(height: 20),

              // WhatsApp Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await _openWhatsApp(context, '01159099087');
                    } catch (e) {
                      if (context.mounted) {
                        context.showTopSnackBar(
                          child: Text('unable_to_open_whatsapp'.tr(),),
                          backgroundColor: AppColors.secondaryColor
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.chat, size: 24),
                  label: Text(
                    'contact_via_whatsapp'.tr(),
                    style: AppTextTheme.body1.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp green
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}