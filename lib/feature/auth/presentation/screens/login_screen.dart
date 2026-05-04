import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/services/service_locator/services_imports.dart';
import '../../../main/home/home_imports.dart';
import '../../manager/login_bloc/login_bloc.dart';
import '../../manager/login_bloc/login_event.dart';
import '../../models/customer_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey            = GlobalKey<FormState>();
  final _phoneController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword     = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<LoginBloc, BaseState<CustomerModel>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            showCustomSnackBar(context, 'auth.login_success'.tr());
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
          if (state.status == Status.failure) {
            showCustomSnackBar(
              context,
              state.errorMessage == 'no_configuration_found'
                  ? 'auth.no_configuration_found'.tr()
                  : 'auth.please_check_your_phone_number_and_password'.tr(),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),

                  // Logo
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.mainAppColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.apps_rounded,
                      color: AppColors.white,
                      size: 40.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'The One POS',
                    style: AppTextTheme.titleSmallBold
                        .copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 48.h),

                  // Title
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'auth.welcome_back'.tr(),
                      style: AppTextTheme.heading1
                          .copyWith(color: AppColors.black),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'auth.shop_easily_and_enjoy_special_offers'.tr(),
                      style: AppTextTheme.body2.copyWith(color: AppColors.grey),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Username / Phone
                  _buildField(
                    controller: _phoneController,
                    hint:       'auth.username'.tr(),
                    icon:       Icons.person_outline_rounded,
                    validator:  (v) => v == null || v.isEmpty
                        ? 'auth.enter_username'.tr()
                        : null,
                  ),
                  SizedBox(height: 12.h),

                  // Password
                  _buildField(
                    controller: _passwordController,
                    hint:       'auth.password'.tr(),
                    icon:       Icons.lock_outline_rounded,
                    obscure:    _obscurePassword,
                    validator:  (v) => v == null || v.isEmpty
                        ? 'auth.enter_your_password'.tr()
                        : null,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Login button
                  BlocBuilder<LoginBloc, BaseState<CustomerModel>>(
                    builder: (context, state) {
                      if (state.status == Status.loading) {
                        return CircularProgressIndicator(
                          color: AppColors.mainAppColor,
                        );
                      }
                      return SizedBox(
                        width:  double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginSubmitted(
                                  phone:    _phoneController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainAppColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'auth.log_in'.tr(),
                            style: AppTextTheme.body2Bold
                                .copyWith(color: AppColors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller:  controller,
      obscureText: obscure,
      validator:   validator,
      textAlign:   TextAlign.right,
      style: AppTextTheme.body2.copyWith(color: AppColors.black),
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: AppTextTheme.body2.copyWith(color: AppColors.grey),
        prefixIcon: Icon(icon, color: AppColors.mainAppColor, size: 20.sp),
        suffixIcon: suffix,
        filled:     true,
        fillColor:  AppColors.whiteColor,
        isDense:    true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: AppColors.mainAppColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.red),
        ),
      ),
    );
  }
}