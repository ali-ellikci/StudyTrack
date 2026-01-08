import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:get/get.dart';

import 'widgets/custom_text_field.dart';
import 'widgets/custom_button.dart';
import 'widgets/social_button.dart';
import '../../controllers/auth_controller.dart';

// Local UI metrics (moved from core/ui)

final emailController = TextEditingController();
final passwordController = TextEditingController();
final fullNameController = TextEditingController();
final confirmPasswordController = TextEditingController();
final authController = Get.find<AuthController>();

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final spacing = _LocalSpacing(
      xs: h * 0.006,
      s: h * 0.01,
      m: h * 0.014,
      l: h * 0.02,
      xl: h * 0.028,
    );
    final padding = _LocalPadding(
      page: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: spacing.s),
      section: EdgeInsets.only(top: spacing.l),
    );
    final sizes = _LocalSizes(
      logo: h * 0.07,
      icon: h * 0.04,
      socialIcon: h * 0.03,
      textSmall: h * 0.016,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: spacing.s),

              // LOGO
              Container(
                width: sizes.logo,
                height: sizes.logo,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(spacing.s),
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: sizes.icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              SizedBox(height: spacing.l),

              Text(
                "Create an Account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: spacing.xs),

              Text(
                "Join the StudyTrack community! Start tracking your success today.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),

              SizedBox(height: spacing.l),

              // FULL NAME
              _label(context, "Full Name"),
              SizedBox(height: spacing.xs),
              CustomTextField(
                controller: fullNameController,
                hintText: 'John Doe',
                prefixIcon: Icons.person_outlined,
              ),

              SizedBox(height: spacing.m),

              //  EMAIL
              _label(context, "Email"),
              SizedBox(height: spacing.xs),
              CustomTextField(
                controller: emailController,
                hintText: 'student@university.edu',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: spacing.m),

              //  PASSWORD
              _label(context, "Password"),
              SizedBox(height: spacing.xs),
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: spacing.m),

              // CONFIRM PASSWORD
              _label(context, "Confirm Password"),
              SizedBox(height: spacing.xs),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm your password',
                prefixIcon: Icons.restart_alt,
                isPassword: true,
              ),

              SizedBox(height: spacing.l),

              // REGISTER BUTTON
              CustomButton(
                text: 'Register',
                onPressed: () async {
                  final ok = await authController.register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    fullNameController.text.trim(),
                  );
                  if (ok) {
                    Get.offAllNamed('/dashboard');
                  }
                },
                isLoading: false,
              ),

              SizedBox(height: spacing.l),

              // DIVIDER
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.s),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: sizes.textSmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              SizedBox(height: spacing.m),

              //  SOCIAL LOGIN
              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      label: 'Google',
                      icon: Brand(Brands.google, size: sizes.socialIcon),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: spacing.s),
                  Expanded(
                    child: SocialButton(
                      label: 'Apple',
                      icon: Icon(
                        Icons.apple,
                        size: sizes.socialIcon + 4,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.l),

              //  LOGIN REDIRECT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed("/login"),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: sizes.textSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _LocalSpacing {
  final double xs, s, m, l, xl;
  _LocalSpacing({required this.xs, required this.s, required this.m, required this.l, required this.xl});
}

class _LocalPadding {
  final EdgeInsets page, section;
  _LocalPadding({required this.page, required this.section});
}

class _LocalSizes {
  final double logo, icon, socialIcon, textSmall;
  _LocalSizes({required this.logo, required this.icon, required this.socialIcon, required this.textSmall});
}
