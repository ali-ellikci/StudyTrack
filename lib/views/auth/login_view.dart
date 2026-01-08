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
final authController = Get.find<AuthController>();

class LoginView extends StatelessWidget {
  LoginView({super.key});

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
        child: Padding(
          padding: padding.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: spacing.xl),

              /// LOGO
              Center(
                child: Container(
                  width: sizes.logo,
                  height: sizes.logo,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(spacing.m),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: sizes.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: spacing.l),

              /// TITLE
              Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: spacing.s),

              /// SUBTITLE
              Text(
                "Log in to continue your streak and reach your goals",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),

              SizedBox(height: spacing.xl),

              /// EMAIL LABEL
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: spacing.xs),

              CustomTextField(
                controller: emailController,
                hintText: 'student@university.edu',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: spacing.m),

              /// PASSWORD LABEL
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: spacing.xs),

              CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: spacing.xs),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: spacing.m),

              /// LOGIN BUTTON
              CustomButton(
                text: 'Log In',
                onPressed: () async {
                  print('[LOGIN BTN] Pressed');
                  final email = emailController.text.trim();
                  final maskedEmail = email.isEmpty ? '<empty>' : email;
                  print('[LOGIN BTN] Email: ' + maskedEmail);
                  final ok = await authController.login(
                    email,
                    passwordController.text.trim(),
                  );
                  if (ok) {
                    print('[LOGIN BTN] Login success → navigate to /dashboard');
                    Get.offAllNamed('/dashboard');
                  } else {
                    print('[LOGIN BTN] Login failed, staying on LoginView');
                  }
                },
                isLoading: false,
              ),

              SizedBox(height: spacing.xl),

              /// DIVIDER
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.s),
                    child: Text(
                      'Or continue with',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: spacing.l),

              /// SOCIAL BUTTONS
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
                        size: sizes.socialIcon,
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

              /// REGISTER REDIRECT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed("/register"),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
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
