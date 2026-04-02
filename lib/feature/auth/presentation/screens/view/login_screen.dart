import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../../../core/constant/custom_bottom.dart';
import '../../../../../../../core/widgets/language_toggle_button.dart';
import '../../../bloc/log_in_bloc/log_in_bloc.dart';
import '../../../bloc/log_in_bloc/log_in_event.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
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
                    "welcome_back".tr(),
                    style: AppTextTheme.heading1,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "shop_easily_and_enjoy_special_offers".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextTheme.body2,
                  ),
                  const SizedBox(height: 30),

                  CustomTextFormField(
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'phone_number'.tr(),
                    prefixIcon: Icons.phone_iphone_outlined,
                    fillColor: Colors.white,
                    validator: (v) => v == null || v.isEmpty
                        ? 'enter_your_phone_number'.tr()
                        : null,
                  ),
                  SizedBox(height: 12.h),

                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: 'password'.tr(),
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    fillColor: Colors.white,
                    validator: (v) => v == null || v.isEmpty
                        ? 'enter_your_password'.tr()
                        : null,
                  ),

                  SizedBox(height: 24.h),

                  BlocProvider(
                    create: (context) => getIt<LoginBloc>(),
                    child: BlocConsumer<LoginBloc, BaseState>(
                      listener: (context, state) {
                        if (state.isSuccess) {
                          showCustomSnackBar(context, "login_success".tr());
                        }
                        if (state.isFailure) {
                          showCustomSnackBar(
                            context,
                            'please_check_your_phone_number_and_password'.tr(),
                          );
                        }
                      },
                      builder: (context, state) {
                        return state.isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: "log_in".tr(),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        phone: _phoneController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                width: 227.w,
                                height: 38.h,
                                fontSize: 14.sp,
                                color: AppColors.mainAppColor,
                              );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                          thickness: 1
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "or".tr(),
                          style: TextStyle(
                            color: AppColors.secondaryAppColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color:Colors.grey.shade400,
                          thickness: 1
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(onPressed: (){
                  }, child: Text('enter_as_visitor'.tr(),style: AppTextTheme.caption.copyWith(
                      color: AppColors.black
                  ),)),
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
