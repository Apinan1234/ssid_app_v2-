import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../services/mock_ai_service.dart';
import 'package:intl/intl.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as AnalysisResult;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Score Card
                _buildOverallScoreCard(result),
                
                const SizedBox(height: 24),
                
                // Detailed Metrics
                _buildDetailedMetrics(result),
                
                const SizedBox(height: 24),
                
                // Feedback Section
                _buildFeedbackSection(result),
                
                const SizedBox(height: 24),
                
                // Step-by-Step Analysis
                _buildStepAnalysis(result),
                
                const SizedBox(height: 24),
                
                // Action Buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(AnalysisResult result) {
    final score = result.overallScore.round();
    final isExcellent = score >= 85;
    final isGood = score >= 70;
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Overall Score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 12,
                  backgroundColor: AppColors.greyLighter,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isExcellent
                        ? AppColors.success
                        : isGood
                            ? AppColors.warning
                            : AppColors.error,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: isExcellent
                          ? AppColors.success
                          : isGood
                              ? AppColors.warning
                              : AppColors.error,
                    ),
                  ),
                  const Text(
                    'POINTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: (isExcellent ? AppColors.success : isGood ? AppColors.warning : AppColors.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isExcellent ? 'EXCELLENT' : isGood ? 'GOOD' : 'NEEDS IMPROVEMENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isExcellent ? AppColors.success : isGood ? AppColors.warning : AppColors.error,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(result.analyzedAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics(AnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildMetricBar('Suturing Technique', result.suturingTechnique, AppColors.primary),
          const SizedBox(height: 16),
          _buildMetricBar('Hand Movement', result.handMovement, AppColors.info),
          const SizedBox(height: 16),
          _buildMetricBar('Tool Handling', result.toolHandling, AppColors.warning),
          const SizedBox(height: 16),
          _buildMetricBar('Time Efficiency', result.timeEfficiency, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildMetricBar(String label, double value, Color color) {
    final percentage = value.round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 8,
            backgroundColor: AppColors.greyLighter,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection(AnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.lightbulb,
                  color: AppColors.info,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            result.feedback,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepAnalysis(AnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step-by-Step Analysis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        
        const SizedBox(height: 16),
        
        ...result.stepBreakdown.map((step) => _buildStepCard(step)),
      ],
    );
  }

  Widget _buildStepCard(StepAnalysis step) {
    final score = step.score.round();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (step.isPassed ? AppColors.success : AppColors.warning)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.isPassed ? LucideIcons.check : LucideIcons.alertCircle,
                  size: 18,
                  color: step.isPassed ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.stepName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: step.isPassed ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            step.feedback,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(LucideIcons.home),
            label: const Text(
              'Back to Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.white, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(LucideIcons.upload, color: AppColors.white),
            label: const Text(
              'Analyze Another Video',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
