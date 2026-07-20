import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import 'auth_state_provider.dart';

enum AuthMode {
  onboarding,
  welcome,
  login,
  register,
  otp,
  forgotPassword,
  resetPassword,
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  AuthMode _currentMode = AuthMode.onboarding;
  final PageController _pageController = PageController();
  int _onboardingPageIndex = 0;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'client@lumiere.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  String _selectedRole = 'customer'; // 'customer' or 'owner'
  bool _agreeToTerms = true;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _changeMode(AuthMode mode) {
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentMode) {
      case AuthMode.onboarding:
        return _buildOnboardingView();
      case AuthMode.welcome:
        return _buildWelcomeView();
      case AuthMode.login:
        return _buildLoginView();
      case AuthMode.register:
        return _buildRegisterView();
      case AuthMode.otp:
        return _buildOtpView();
      case AuthMode.forgotPassword:
        return _buildForgotPasswordView();
      case AuthMode.resetPassword:
        return _buildResetPasswordView();
    }
  }

  // 1. Onboarding Slides Carousel View
  Widget _buildOnboardingView() {
    final slides = [
      {
        'title': 'AI Skincare Analysis',
        'desc': 'Scan your face using our smart camera viewfinder to measure hydration indices, skin texture grid lines, and receive personalized routine recommendations.',
        'icon': Icons.qr_code_scanner_outlined,
      },
      {
        'title': 'Professional Salons & Stylists',
        'desc': 'Book premium bio-active facials, hair coloring balayage, or holistic treatments from highly rated specialists in your neighborhood.',
        'icon': Icons.storefront_outlined,
      },
      {
        'title': 'Companion Dashboard',
        'desc': 'For salon owners, manage booking confirmations, schedules, payout history, and access insights on local client demands in real time.',
        'icon': Icons.analytics_outlined,
      },
    ];

    return Padding(
      key: const ValueKey('onboarding'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => _changeMode(AuthMode.welcome),
              child: Text(
                'Skip',
                style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (idx) {
                setState(() {
                  _onboardingPageIndex = idx;
                });
              },
              itemCount: slides.length,
              itemBuilder: (context, index) {
                final slide = slides[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        slide['icon'] as IconData,
                        size: 80,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    AppSpacing.gapXL,
                    Text(
                      slide['title'] as String,
                      style: AppTextStyles.h2(color: AppColors.primaryDark),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapMD,
                    Text(
                      slide['desc'] as String,
                      style: AppTextStyles.bodyMedium(color: AppColors.textMedium).copyWith(height: 1.45),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          // Dot Indicators & Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(slides.length, (idx) {
                  final isCurrent = idx == _onboardingPageIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 6),
                    width: isCurrent ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primaryDark : AppColors.textLight,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_onboardingPageIndex < slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    _changeMode(AuthMode.welcome);
                  }
                },
                child: Text(_onboardingPageIndex == slides.length - 1 ? 'Get Started' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Welcome View
  Widget _buildWelcomeView() {
    return Padding(
      key: const ValueKey('welcome'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 64,
            color: AppColors.primaryDark,
          ),
          AppSpacing.gapMD,
          Text(
            'Beauty Personalized by AI',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1(color: AppColors.primaryDark).copyWith(fontWeight: FontWeight.normal),
          ),
          AppSpacing.gapSM,
          Text(
            ' companion application ',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
          ),
          AppSpacing.gapXL,
          ElevatedButton(
            onPressed: () => _changeMode(AuthMode.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Sign In to Account'),
          ),
          AppSpacing.gapMD,
          OutlinedButton(
            onPressed: () => _changeMode(AuthMode.register),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryDark),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: const Text('Create New Account'),
          ),
          AppSpacing.gapXL,
          GestureDetector(
            onTap: () {
              // Explore as Guest
              ref.read(authStateProvider.notifier).loginAsCustomer();
            },
            child: Text(
              'Explore as Guest Client',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.primaryDark).copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Login View
  Widget _buildLoginView() {
    return SingleChildScrollView(
      key: const ValueKey('login'),
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _changeMode(AuthMode.welcome),
            ),
            AppSpacing.gapMD,
            Text('Welcome Back', style: AppTextStyles.h2(color: AppColors.primaryDark)),
            Text('Sign in to continue personalized treatment planning', style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
            AppSpacing.gapXL,

            // Email Input
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
            ),
            AppSpacing.gapMD,

            // Password Input
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (val) => val == null || val.length < 6 ? 'Password too short' : null,
            ),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _changeMode(AuthMode.forgotPassword),
                child: const Text('Forgot Password?'),
              ),
            ),
            AppSpacing.gapSM,

            // Role selection buttons (demo utility)
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Customer')),
                    selected: _selectedRole == 'customer',
                    selectedColor: AppColors.primaryLight,
                    onSelected: (val) => setState(() => _selectedRole = 'customer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Salon Owner')),
                    selected: _selectedRole == 'owner',
                    selectedColor: AppColors.primaryLight,
                    onSelected: (val) => setState(() => _selectedRole = 'owner'),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLG,

            // Sign In Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Navigate to OTP check for secure feeling
                  _changeMode(AuthMode.otp);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Registration View
  Widget _buildRegisterView() {
    return SingleChildScrollView(
      key: const ValueKey('register'),
      padding: const EdgeInsets.all(24.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _changeMode(AuthMode.welcome),
            ),
            AppSpacing.gapMD,
            Text('Create Account', style: AppTextStyles.h2(color: AppColors.primaryDark)),
            Text('Join Beauty Personalized by AI companion app', style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
            AppSpacing.gapLG,

            // Full Name Input
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            AppSpacing.gapMD,

            // Email Input
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            AppSpacing.gapMD,

            // Password Input
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            AppSpacing.gapMD,

            // Role Select dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Select Profile Role',
                prefixIcon: Icon(Icons.people_outline),
              ),
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('Customer Client')),
                DropdownMenuItem(value: 'owner', child: Text('Salon Owner / Manager')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedRole = val;
                  });
                }
              },
            ),
            AppSpacing.gapSM,

            // Agree to Terms
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  activeColor: AppColors.primaryDark,
                  onChanged: (val) => setState(() => _agreeToTerms = val ?? true),
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service & Privacy policies.',
                    style: AppTextStyles.bodySmall(color: AppColors.textMedium),
                  ),
                ),
              ],
            ),
            AppSpacing.gapMD,

            // Register Button
            ElevatedButton(
              onPressed: _agreeToTerms
                  ? () {
                // Navigate to OTP Check
                _changeMode(AuthMode.otp);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  // 5. OTP Verification View
  Widget _buildOtpView() {
    return Padding(
      key: const ValueKey('otp'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sms_outlined, size: 64, color: AppColors.primaryDark),
          AppSpacing.gapMD,
          Text(
            'Security Verification',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2(color: AppColors.primaryDark),
          ),
          AppSpacing.gapSM,
          Text(
            'We\'ve simulated sending a 4-digit code. Enter any numbers below to authenticate securely.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
          ),
          AppSpacing.gapXL,

          // OTP field input
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2().copyWith(letterSpacing: 24),
            maxLength: 4,
            decoration: const InputDecoration(
              counterText: '',
              hintText: '••••',
            ),
          ),
          AppSpacing.gapLG,

          ElevatedButton(
            onPressed: () {
              // Sign in depending on selected role
              if (_selectedRole == 'owner') {
                ref.read(authStateProvider.notifier).loginAsOwner();
              } else {
                ref.read(authStateProvider.notifier).loginAsCustomer();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Verify & Proceed'),
          ),
          TextButton(
            onPressed: () => _changeMode(AuthMode.login),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  // 6. Forgot Password
  Widget _buildForgotPasswordView() {
    return Padding(
      key: const ValueKey('forgotPassword'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_reset, size: 64, color: AppColors.primaryDark),
          AppSpacing.gapMD,
          Text('Forgot Password', style: AppTextStyles.h2(color: AppColors.primaryDark), textAlign: TextAlign.center),
          AppSpacing.gapSM,
          const Text('Enter your registered email address and we\'ll send a mock code to reset your credentials.', textAlign: TextAlign.center),
          AppSpacing.gapXL,

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          AppSpacing.gapLG,

          ElevatedButton(
            onPressed: () => _changeMode(AuthMode.resetPassword),
            child: const Text('Send Reset Request'),
          ),
          TextButton(
            onPressed: () => _changeMode(AuthMode.login),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  // 7. Reset Password
  Widget _buildResetPasswordView() {
    return Padding(
      key: const ValueKey('resetPassword'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 64, color: AppColors.primaryDark),
          AppSpacing.gapMD,
          Text('Reset Password', style: AppTextStyles.h2(color: AppColors.primaryDark), textAlign: TextAlign.center),
          AppSpacing.gapXL,

          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          AppSpacing.gapMD,
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          AppSpacing.gapLG,

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully! Please login.')),
              );
              _changeMode(AuthMode.login);
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }
}
