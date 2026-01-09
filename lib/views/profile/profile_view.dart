import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authController = Get.find<AuthController>();

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

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
      page: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
      section: EdgeInsets.only(top: h * 0.02),
    );
    final sizes = _LocalSizes(
      logo: h * 0.07,
      icon: h * 0.04,
      socialIcon: h * 0.03,
      textSmall: h * 0.016,
    );

    final double profileSize = MediaQuery.of(context).size.height * 0.12;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.m),
            child: const Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(spacing.xs),
          child: Divider(
            height: spacing.xs,
            thickness: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      // No bottom navigation bar
      body: SingleChildScrollView(
        child: Padding(
          padding: padding.page,
          child: Column(
            children: [
              // PROFILE IMAGE
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: profileSize,
                      height: profileSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://i.pravatar.cc/300?img=5',
                          ),
                        ),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.withOpacity(0.7)
                              : Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 4,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing.s),

              Text(
                user?.displayName ?? " ",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: spacing.xs),

              Text(
                "ID : ${user?.uid ?? " "}",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                ),
              ),

              SizedBox(height: spacing.l),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCard(
                    context,
                    "120h",
                    "Study Time",
                    spacing,
                    sizes,
                    icon: Icons.timer_outlined,
                  ),
                  SizedBox(height: spacing.s),
                  _buildCard(
                    context,
                    "15",
                    "Goals Met",
                    spacing,
                    sizes,
                    icon: Icons.outlined_flag,
                  ),
                ],
              ),

              SizedBox(height: spacing.s),

              _buildCard(
                context,
                "4.0",
                "GPA",
                spacing,
                sizes,
                icon: Icons.school_outlined,
              ),

              SizedBox(height: spacing.l),

              _buildInfoCard(context, spacing, sizes),

              SizedBox(height: spacing.m),

              _buildPrimaryButton(
                context,
                spacing,
                sizes,
                icon: Icons.edit,
                label: "Edit Profile",
                color: Theme.of(context).colorScheme.primary,
                onTap: () {},
              ),

              SizedBox(height: spacing.s),

              _buildLogoutButton(context, spacing, sizes),
              SizedBox(height: spacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CARDS (RESPONSIVE) =================
  Widget _buildCard(
    BuildContext context,
    String h1,
    String h2,
    _LocalSpacing spacing,
    _LocalSizes sizes, {
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: spacing.l * 1.1,
        horizontal: spacing.xl * 1.1,
      ),
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          Colors.white,
          0.05,
        )!,
        borderRadius: BorderRadius.circular(spacing.m),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            h1,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: sizes.icon * 0.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black,
                ),
                SizedBox(width: spacing.s),
              ],
              Text(
                h2.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    _LocalSpacing spacing,
    _LocalSizes sizes,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: spacing.m, horizontal: spacing.m),
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          Colors.white,
          0.05,
        )!,
        borderRadius: BorderRadius.circular(spacing.m),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfo(
            context,
            "Email",
            "student@uni.edu.tr",
            spacing,
            sizes,
            icon: Icons.mail_outline,
          ),
          Divider(color: Colors.grey.withOpacity(0.5)),
          _buildInfo(
            context,
            "Department",
            "Computer Science",
            spacing,
            sizes,
            icon: Icons.business,
          ),
          Divider(color: Colors.grey.withOpacity(0.5)),
          _buildInfo(
            context,
            "Class",
            "Class of 2023",
            spacing,
            sizes,
            icon: Icons.school_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    BuildContext context,
    String h1,
    String h2,
    _LocalSpacing spacing,
    _LocalSizes sizes, {
    IconData? icon,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.s),
            decoration: BoxDecoration(
              color: Color.lerp(
                Theme.of(context).scaffoldBackgroundColor,
                Colors.white,
                0.1,
              )!,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: sizes.icon * 0.5,
            ),
          ),
          SizedBox(width: spacing.m),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(h1, style: Theme.of(context).textTheme.bodySmall),
              Text(
                h2,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BUTTONS (RESPONSIVE) =================
  Widget _buildPrimaryButton(
    BuildContext context,
    _LocalSpacing spacing,
    _LocalSizes sizes, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(spacing.m),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: sizes.icon * 0.7),
            SizedBox(width: spacing.s),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    _LocalSpacing spacing,
    _LocalSizes sizes,
  ) {
    return GestureDetector(
      onTap: () {
        authController.logout();
        Get.toNamed('/login');
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.lerp(
            Theme.of(context).scaffoldBackgroundColor,
            Colors.white,
            0.05,
          )!,
          borderRadius: BorderRadius.circular(spacing.m),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: sizes.icon * 0.7),
            SizedBox(width: spacing.s),
            Text(
              "Log Out",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.redAccent),
            ),
          ],
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
