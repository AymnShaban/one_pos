import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/services/service_locator/services_imports.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../../../core/constant/custom_bottom.dart';
import '../../../../../../../core/widgets/language_toggle_button.dart';
import '../../../../main/home/home_imports.dart';
import '../../../bloc/log_in_bloc/log_in_bloc.dart';
import '../../../bloc/log_in_bloc/log_in_event.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey         = GlobalKey<FormState>();
  final _phoneController    = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 170),

                  const LanguageDropdownSection(),
                  const SizedBox(height: 70),

                  Text(
                    'auth.welcome_back'.tr(),
                    style: AppTextTheme.heading1,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'auth.shop_easily_and_enjoy_special_offers'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextTheme.body2,
                  ),
                  const SizedBox(height: 30),

                  CustomTextFormField(
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'auth.phone_number'.tr(),
                    prefixIcon: Icons.phone_iphone_outlined,
                    fillColor: Colors.white,
                    validator: (v) => v == null || v.isEmpty
                        ? 'auth.enter_your_phone_number'.tr()
                        : null,
                  ),
                  SizedBox(height: 12.h),

                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: 'auth.password'.tr(),
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    fillColor: Colors.white,
                    validator: (v) => v == null || v.isEmpty
                        ? 'auth.enter_your_password'.tr()
                        : null,
                  ),
                  SizedBox(height: 24.h),

                  BlocProvider(
                    create: (context) => getIt<LoginBloc>(),
                    child: BlocConsumer<LoginBloc, BaseState>(
                      listener: (context, state) {
                        if (state.isSuccess) {
                          showCustomSnackBar(
                            context,
                            'auth.login_success'.tr(),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (_) =>
                                    getIt<HomeBloc>()..add(const InitHome()),
                                  ),
                                  BlocProvider(
                                    create: (_) => getIt<NavBloc>(),
                                  ),
                                ],
                                child: const MainScreen(),
                              ),
                            ),
                                (route) => false,
                          );
                        }
                        if (state.isFailure) {
                          showCustomSnackBar(
                            context,
                            'auth.please_check_your_phone_number_and_password'
                                .tr(),
                          );
                        }
                      },
                      builder: (context, state) {
                        return state.isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                          text:     'auth.log_in'.tr(),
                          width:    227.w,
                          height:   38.h,
                          fontSize: 14.sp,
                          color:    AppColors.mainAppColor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginSubmitted(
                                  phone:    _phoneController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}