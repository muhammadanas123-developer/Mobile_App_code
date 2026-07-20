import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../data/ai_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/service_model.dart';
import 'package:fyp_project/features/booking/booking_state_provider.dart';

enum ScanStep { permission, viewfinder, scanning, processing, results }

class AIScanFlowScreen extends ConsumerStatefulWidget {
  final String scanType; // 'skin', 'hair', 'face_shape', 'makeup', 'beard'

  const AIScanFlowScreen({
    super.key,
    required this.scanType,
  });

  @override
  ConsumerState<AIScanFlowScreen> createState() => _AIScanFlowScreenState();
}

class _AIScanFlowScreenState extends ConsumerState<AIScanFlowScreen>
    with SingleTickerProviderStateMixin {
  ScanStep _currentStep = ScanStep.permission;
  File? selectedImage;
  Map<String, dynamic>? analysis;
  bool _isLoadingAnalysis = false;
  final AIService _aiService = AIService();

  late AnimationController _scannerController;
  late Animation<double> _laserAnimation;

  Timer? _processingTimer;
  int _processingTextIndex = 0;

  final List<String> _processingTexts = [
    'Initializing advanced dermis matching...',
    'Analyzing pore density & oil indexes...',
    'Evaluating structural elasticity margins...',
    'Synthesizing botanical treatment suggestions...'
  ];

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _processingTimer?.cancel();
    super.dispose();
  }

  void _grantPermission() {
    setState(() {
      _currentStep = ScanStep.viewfinder;
    });
  }

  Future<void> _capturePhoto() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) return;

      setState(() {
        selectedImage = File(image.path);
        _currentStep = ScanStep.processing;
        _isLoadingAnalysis = true;
      });

      _startProcessingCycle();

      // TODO: Supabase/Firebase/Auth token yahan lagana hai
      const token = 'YOUR_TOKEN';

      if (widget.scanType == 'skin') {
        analysis = await _aiService.analyzeSkin(
          File(image.path),
          token,
        );
      } else if (widget.scanType == 'hair') {
        analysis = await _aiService.analyzeHair(
          File(image.path),
          token,
        );
      } else {
        analysis = await _aiService.analyzeFace(
          File(image.path),
          token,
        );
      }

      if (!mounted) return;

      setState(() {
        _isLoadingAnalysis = false;
        _processingTimer?.cancel();
        _currentStep = ScanStep.results;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingAnalysis = false;
        _processingTimer?.cancel();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis failed: $e'),
        ),
      );
    }
  }

  void _startProcessingCycle() {
    _processingTimer = Timer.periodic(
      const Duration(milliseconds: 1200),
          (timer) {
        if (_processingTextIndex < _processingTexts.length - 1) {
          setState(() {
            _processingTextIndex++;
          });
        } else {
          timer.cancel();
          setState(() {
            _currentStep = ScanStep.results;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentStep == ScanStep.viewfinder ||
          _currentStep == ScanStep.scanning
          ? Colors.black
          : Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: _currentStep == ScanStep.viewfinder ||
            _currentStep == ScanStep.scanning
            ? Colors.black
            : Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: _currentStep == ScanStep.viewfinder ||
              _currentStep == ScanStep.scanning
              ? AppColors.surface
              : AppColors.textDark,
        ),
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (widget.scanType) {
      case 'skin':
        return 'Skin Analysis';
      case 'hair':
        return 'Hair Integrity';
      case 'face_shape':
        return 'Face Shape Detection';
      case 'makeup':
        return 'Makeup Try-on';
      case 'beard':
        return 'Beard Styling';
      default:
        return 'AI Analysis';
    }
  }

  Widget _buildBody() {
    switch (_currentStep) {
      case ScanStep.permission:
        return _buildPermissionView();
      case ScanStep.viewfinder:
        return _buildViewfinderView();
      case ScanStep.scanning:
        return _buildScanningView();
      case ScanStep.processing:
        return _buildProcessingView();
      case ScanStep.results:
        return _buildResultsView();
    }
  }

  Widget _buildPermissionView() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 72,
              color: AppColors.primaryDark,
            ),
          ),
          AppSpacing.gapLG,
          Text(
            'Camera Access Required',
            style: AppTextStyles.h2(),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSM,
          Text(
            'To run personalized analysis scans on your skin, scalp, and face shape, Beauty Personalized by AI needs access to your device camera.',
            style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXL,
          ElevatedButton(
            onPressed: _grantPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Grant Camera Permission'),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildViewfinderView() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mock background camera stream
              Image.asset(
                AppAssets.faceScan,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              // Viewfinder overlay guides
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryAccent.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                margin: const EdgeInsets.all(40),
              ),
              // Oval helper face guide
              Container(
                width: 260,
                height: 340,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.surface, width: 1.5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Positioned(
                top: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: AppRadius.borderMD,
                  ),
                  child: Text(
                    'Position your face within the guide oval',
                    style: AppTextStyles.bodySmall(color: AppColors.surface),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Camera action tray
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.flash_off, color: Colors.white, size: 28),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: _capturePhoto,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 4),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScanningView() {
    return Stack(
      children: [
        Image.asset(
          AppAssets.faceScan,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withValues(alpha: 0.25),
        ),
        AnimatedBuilder(
          animation: _laserAnimation,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.7 * _laserAnimation.value,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.8),
                      blurRadius: 16,
                      spreadRadius: 4,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 60,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: AppRadius.borderLG,
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryAccent,
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Running AI Scan...',
                  style: AppTextStyles.titleSmall(color: AppColors.surface),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              color: AppColors.primaryDark,
              strokeWidth: 4,
            ),
          ),
          AppSpacing.gapLG,
          Text(
            'Processing Results',
            style: AppTextStyles.h2(),
          ),
          AppSpacing.gapSM,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _processingTexts[_processingTextIndex],
              key: ValueKey(_processingTextIndex),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image result block
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderLG,
              image: DecorationImage(
                image: selectedImage != null
                    ? FileImage(selectedImage!)
                    : const AssetImage(AppAssets.faceScan) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: AppRadius.borderSM,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, color: AppColors.success, size: 8),
                        const SizedBox(width: 6),
                        Text(
                          'Analysis Profile Completed',
                          style: AppTextStyles.label(color: AppColors.surface),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapLG,

          // Dermal Metrics
          Text('Key Diagnostic Scores', style: AppTextStyles.titleLarge()),
          AppSpacing.gapSM,

          if (widget.scanType == 'skin') ...[
            _buildResultRow('Hydration Index', '82% (Optimal)', 0.82, AppColors.success),
            _buildResultRow('Elasticity Level', '74% (Healthy)', 0.74, AppColors.primaryDark),
            _buildResultRow('Pore Texture Grid', '58% (Irregular)', 0.58, AppColors.errorText),
            _buildResultRow('Sensitivity Profile', '88% (High)', 0.88, AppColors.errorText),
          ] else if (widget.scanType == 'hair') ...[
            _buildResultRow('Strand Thickness', '68% (Fine)', 0.68, AppColors.primaryDark),
            _buildResultRow('Scalp Moisture', '45% (Dry)', 0.45, AppColors.errorText),
            _buildResultRow('Follicle Integrity', '90% (Excellent)', 0.90, AppColors.success),
          ] else ...[
            _buildResultRow('Structural Balance', '85% (Balanced)', 0.85, AppColors.success),
            _buildResultRow('Symmetry Match', '92% (Optimal)', 0.92, AppColors.success),
          ],

          AppSpacing.gapLG,

          // AI Suggestion Text Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: AppRadius.borderLG,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'AI RECOMMENDATION',
                      style: AppTextStyles.label(color: AppColors.primaryAccent)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                AppSpacing.gapSM,
                Text(
                  _getAIRecommendationText(),
                  style: AppTextStyles.bodyMedium(color: AppColors.surface),
                ),
              ],
            ),
          ),

          AppSpacing.gapLG,

          // Book Recommended Treatment Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.borderLG,
              border: Border.all(color: AppColors.primaryAccent, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Matching Treatment',
                  style: AppTextStyles.label(color: AppColors.primaryDark)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _getRecommendedTreatmentName(),
                  style: AppTextStyles.titleMedium(),
                ),
                const SizedBox(height: 8),
                Text(
                  _getTreatmentDescription(),
                  style: AppTextStyles.bodyMedium(color: AppColors.textMedium),
                ),
                AppSpacing.gapMD,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(selectedServiceProvider.notifier).state = ServiceModel(
                        id: 's_rec',
                        name: _getRecommendedTreatmentName(),
                        description: _getTreatmentDescription(),
                        durationMinutes: 90,
                        price: 145.0,
                        category: 'Facial',
                      );
                      context.push(Routes.bookingFlow);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.surface,
                    ),
                    child: const Text('Book Recommended Treatment'),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapXL,
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, double percent, Color progressColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyMedium()),
              Text(value, style: AppTextStyles.titleSmall().copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: AppRadius.borderSM,
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              color: progressColor,
              backgroundColor: AppColors.cardBg,
            ),
          ),
        ],
      ),
    );
  }

  String _getAIRecommendationText() {
    if (analysis != null && analysis!['recommendation'] != null) {
      return analysis!['recommendation'].toString();
    }

    switch (widget.scanType) {
      case 'skin':
        return 'We noticed high oil-margins in the T-zone and dryness near the eyes. Avoid harsh chemical face cleansers. We recommend focusing on hyaluronic hydration serums and planning a organic enzyme peel session.';
      case 'hair':
        return 'Your scalp hydration is low. This might lead to dry strands. Focus on scalp masks weekly and apply jojoba-based oils. Avoid high-heat blowdrying.';
      case 'beard':
        return 'Based on your square face shape, a trimmed corporate beard style with sharp jaw contours will enhance your outline structure. Use sandalwood beard oil daily.';
      default:
        return 'Your profile is highly balanced. Maintaining your current botanical cleanser and hydration routine will support these optimal values.';
    }
  }

  String _getRecommendedTreatmentName() {
    if (analysis != null && analysis!['treatment'] != null) {
      return analysis!['treatment'].toString();
    }

    switch (widget.scanType) {
      case 'skin':
        return 'Bio-Active Glow Facial';
      case 'hair':
        return 'Botanical Scalp Detox';
      default:
        return 'Premium Facial Hydration';
    }
  }

  String _getTreatmentDescription() {
    if (analysis != null && analysis!['description'] != null) {
      return analysis!['description'].toString();
    }

    switch (widget.scanType) {
      case 'skin':
        return 'Deep pore cleansing and enzymatic hydration therapy designed to balance skin texture.';
      case 'hair':
        return 'Exfoliating mint and organic tea tree scalp treatment that triggers hair root density growth.';
      default:
        return 'Custom tailored skin care treatment utilizing natural floral distillates.';
    }
  }
}