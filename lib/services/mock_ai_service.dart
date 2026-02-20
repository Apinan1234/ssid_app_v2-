import 'dart:math';

class AnalysisResult {
  final double overallScore;
  final double suturingTechnique;
  final double handMovement;
  final double toolHandling;
  final double timeEfficiency;
  final String feedback;
  final List<StepAnalysis> stepBreakdown;
  final DateTime analyzedAt;
  
  AnalysisResult({
    required this.overallScore,
    required this.suturingTechnique,
    required this.handMovement,
    required this.toolHandling,
    required this.timeEfficiency,
    required this.feedback,
    required this.stepBreakdown,
    required this.analyzedAt,
  });
}

class StepAnalysis {
  final String stepName;
  final double score;
  final String feedback;
  final bool isPassed;
  
  StepAnalysis({
    required this.stepName,
    required this.score,
    required this.feedback,
    required this.isPassed,
  });
}

class MockAIService {
  static final Random _random = Random();
  
  /// Simulates AI analysis of a suturing video
  /// Returns mock analysis results after a realistic delay
  static Future<AnalysisResult> analyzeVideo(String videoPath) async {
    // Simulate processing time (3-5 seconds)
    await Future.delayed(Duration(seconds: 3 + _random.nextInt(3)));
    
    // Generate random but realistic scores (70-95%)
    final overallScore = 70 + _random.nextDouble() * 25;
    final suturingTech = 65 + _random.nextDouble() * 30;
    final handMovement = 70 + _random.nextDouble() * 25;
    final toolHandling = 68 + _random.nextDouble() * 27;
    final timeEfficiency = 72 + _random.nextDouble() * 23;
    
    // Generate step-by-step breakdown
    final steps = [
      StepAnalysis(
        stepName: 'Needle Loading',
        score: 75 + _random.nextDouble() * 20,
        feedback: _generateStepFeedback('needle_loading'),
        isPassed: _random.nextBool() || true, // Mostly passed
      ),
      StepAnalysis(
        stepName: 'Entry Angle',
        score: 70 + _random.nextDouble() * 25,
        feedback: _generateStepFeedback('entry_angle'),
        isPassed: _random.nextDouble() > 0.3,
      ),
      StepAnalysis(
        stepName: 'Suture Spacing',
        score: 78 + _random.nextDouble() * 18,
        feedback: _generateStepFeedback('spacing'),
        isPassed: true,
      ),
      StepAnalysis(
        stepName: 'Knot Tying',
        score: 80 + _random.nextDouble() * 15,
        feedback: _generateStepFeedback('knot'),
        isPassed: _random.nextDouble() > 0.2,
      ),
      StepAnalysis(
        stepName: 'Tension Control',
        score: 72 + _random.nextDouble() * 23,
        feedback: _generateStepFeedback('tension'),
        isPassed: _random.nextDouble() > 0.25,
      ),
    ];
    
    return AnalysisResult(
      overallScore: overallScore,
      suturingTechnique: suturingTech,
      handMovement: handMovement,
      toolHandling: toolHandling,
      timeEfficiency: timeEfficiency,
      feedback: _generateOverallFeedback(overallScore),
      stepBreakdown: steps,
      analyzedAt: DateTime.now(),
    );
  }
  
  static String _generateOverallFeedback(double score) {
    if (score >= 90) {
      return 'Excellent performance! Your suturing technique demonstrates professional-level proficiency. Continue practicing to maintain this high standard.';
    } else if (score >= 80) {
      return 'Very good work! Your technique is solid with minor areas for improvement. Focus on consistency and precision in your movements.';
    } else if (score >= 70) {
      return 'Good effort! You show understanding of the fundamentals. Practice the recommended improvements to enhance your skills further.';
    } else {
      return 'Keep practicing! Focus on the basic techniques and take your time to build muscle memory. Consistency will come with practice.';
    }
  }
  
  static String _generateStepFeedback(String stepType) {
    final feedbackOptions = {
      'needle_loading': [
        'Good needle grip at 1/3 distance from swaged end',
        'Needle slightly too close to tip - adjust grip position',
        'Excellent positioning for optimal control',
      ],
      'entry_angle': [
        '90-degree entry angle well maintained',
        'Entry angle needs adjustment - aim for perpendicular penetration',
        'Consistent entry angle throughout the procedure',
      ],
      'spacing': [
        'Uniform spacing between sutures achieved',
        'Spacing slightly irregular - maintain 3-4mm intervals',
        'Excellent spatial awareness demonstrated',
      ],
      'knot': [
        'Square knot properly executed with good tension',
        'Knot security could be improved - add additional throw',
        'Perfect knot tying technique observed',
      ],
      'tension': [
        'Appropriate tension maintained without tissue damage',
        'Slightly excessive tension noted - be gentler',
        'Excellent balance between secure closure and tissue preservation',
      ],
    };
    
    final options = feedbackOptions[stepType] ?? ['Good technique observed'];
    return options[_random.nextInt(options.length)];
  }
  
  /// Simulates checking if video processing is complete
  static Future<bool> checkProcessingStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
  
  /// Gets mock confidence level for the analysis
  static double getConfidenceLevel() {
    return 82 + _random.nextDouble() * 13; // 82-95% confidence
  }
}
