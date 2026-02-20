class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }
    
    return null;
  }
  
  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Video file validation
  static String? validateVideoFile(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return 'Please select a video file';
    }
    
    final validExtensions = ['.mp4', '.mov', '.avi', '.mkv'];
    final extension = filePath.toLowerCase().substring(filePath.lastIndexOf('.'));
    
    if (!validExtensions.contains(extension)) {
      return 'Invalid file format. Supported: MP4, MOV, AVI, MKV';
    }
    
    return null;
  }
  
  // File size validation (in bytes)
  static String? validateFileSize(int? sizeInBytes, int maxSizeMB) {
    if (sizeInBytes == null) {
      return 'Unable to determine file size';
    }
    
    final maxSizeBytes = maxSizeMB * 1024 * 1024;
    if (sizeInBytes > maxSizeBytes) {
      return 'File size must be less than ${maxSizeMB}MB';
    }
    
    return null;
  }
}
