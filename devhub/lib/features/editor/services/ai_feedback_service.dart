// AI Feedback Service
// 
// This service analyzes code and provides GUIDED feedback,
// NOT direct solutions. The goal is to enhance thinking capacity.

class AIFeedbackService {
  /// Analyzes code and provides educational guidance
  Future<String> analyzeCode(String code, String language) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (code.trim().isEmpty) {
        return _buildGuidance(
          title: "🎯 Ready to Code!",
          message: "Your editor is empty. Let's start with something simple!",
          hint: "Try writing a basic program that prints a message. In $language, what function displays output to the console?",
          encouragement: "Every expert was once a beginner. Start with something simple!",
        );
      }
      
      // Analyze for common patterns and provide guidance
      final issues = _analyzeCodePatterns(code, language);
      
      if (issues.isEmpty) {
        return _buildGuidance(
          title: "✨ Great Work!",
          message: "Your code looks well-structured! No obvious issues detected.",
          hint: "Try running your code to see the output. Consider: Can you add error handling? What edge cases might break your code?",
          encouragement: "Keep experimenting and learning. You're doing great!",
        );
      }
      
      return issues.join('\n\n---\n\n');
    } catch (e) {
      return '❌ Error analyzing code: $e\n\nPlease try again.';
    }
  }
  
  List<String> _analyzeCodePatterns(String code, String language) {
    List<String> guidance = [];
    
    switch (language) {
      case 'Python':
        guidance.addAll(_analyzePython(code));
        break;
      case 'JavaScript':
        guidance.addAll(_analyzeJavaScript(code));
        break;
      case 'C':
        guidance.addAll(_analyzeC(code));
        break;
      case 'Java':
        guidance.addAll(_analyzeJava(code));
        break;
      case 'Dart':
        guidance.addAll(_analyzeDart(code));
        break;
    }
    
    return guidance;
  }
  
  List<String> _analyzePython(String code) {
    List<String> guidance = [];
    
    // Check for missing colons
    final lines = code.split('\n');
    for (var line in lines) {
      final trimmed = line.trim();
      if ((trimmed.startsWith('if ') || trimmed.startsWith('for ') || 
           trimmed.startsWith('while ') || trimmed.startsWith('def ') ||
           trimmed.startsWith('class ')) && !trimmed.endsWith(':') && !trimmed.endsWith(':\\')) {
        guidance.add(_buildGuidance(
          title: "🔍 Syntax Hint",
          message: "I noticed a control structure or function definition.",
          hint: "In Python, statements like 'if', 'for', 'while', 'def', and 'class' need to end with a colon (:). Check the line: '$trimmed'",
          encouragement: "Colons tell Python where a code block begins!",
        ));
        break;
      }
    }
    
    // Check for print without parentheses
    if (code.contains('print ') && !code.contains('print(')) {
      guidance.add(_buildGuidance(
        title: "🖨️ Print Function",
        message: "It looks like you're using print without parentheses.",
        hint: "In Python 3, print is a function and requires parentheses. Use print('message') instead of print 'message'.",
        encouragement: "This is a common Python 2 vs 3 difference!",
      ));
    }
    
    // Check for indentation
    bool hasColon = code.contains(':');
    bool hasIndent = code.contains('    ') || code.contains('\t');
    if (hasColon && !hasIndent && code.split('\n').length > 1) {
      guidance.add(_buildGuidance(
        title: "📐 Indentation",
        message: "Python uses indentation to define code blocks.",
        hint: "After a line ending with ':', the next line should be indented (usually 4 spaces). This tells Python which code belongs inside the block.",
        encouragement: "Proper indentation makes your code readable and runnable!",
      ));
    }
    
    return guidance;
  }
  
  List<String> _analyzeJavaScript(String code) {
    List<String> guidance = [];
    
    // Check for var usage
    if (code.contains('var ')) {
      guidance.add(_buildGuidance(
        title: "📦 Modern Variables",
        message: "You're using 'var' for variable declaration.",
        hint: "Consider using 'let' for variables that change, or 'const' for constants. They have better scoping rules than 'var'.",
        encouragement: "Modern JavaScript features make your code safer!",
      ));
    }
    
    // Check for == instead of ===
    if (code.contains(' == ') && !code.contains(' === ')) {
      guidance.add(_buildGuidance(
        title: "🔄 Strict Equality",
        message: "You're using '==' for comparison.",
        hint: "JavaScript has '==' (loose equality) and '===' (strict equality). Using '===' is safer because it doesn't do type coercion. For example: 1 == '1' is true, but 1 === '1' is false.",
        encouragement: "Strict equality prevents unexpected bugs!",
      ));
    }
    
    // Check for semicolons
    final lines = code.split('\n');
    bool hasMissingSemicolon = false;
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty && 
          !trimmed.endsWith('{') && !trimmed.endsWith('}') &&
          !trimmed.endsWith(';') && !trimmed.startsWith('//') &&
          !trimmed.startsWith('if') && !trimmed.startsWith('for') &&
          !trimmed.startsWith('while') && !trimmed.startsWith('function') &&
          (trimmed.contains('let ') || trimmed.contains('const ') || trimmed.contains('console.log'))) {
        hasMissingSemicolon = true;
        break;
      }
    }
    if (hasMissingSemicolon) {
      guidance.add(_buildGuidance(
        title: "⚡ Statement Endings",
        message: "Some statements might be missing semicolons.",
        hint: "While JavaScript often works without semicolons, it's good practice to end statements with ';' to avoid unexpected behavior.",
        encouragement: "Consistent style makes code more maintainable!",
      ));
    }
    
    return guidance;
  }
  
  List<String> _analyzeC(String code) {
    List<String> guidance = [];
    
    // Check for stdio.h
    if (code.contains('printf') && !code.contains('#include')) {
      guidance.add(_buildGuidance(
        title: "📚 Header File",
        message: "You're using printf but might be missing a header.",
        hint: "In C, you need to include <stdio.h> to use printf. Add: #include <stdio.h> at the top of your file.",
        encouragement: "Headers provide function declarations!",
      ));
    }
    
    // Check for main function
    if (!code.contains('main')) {
      guidance.add(_buildGuidance(
        title: "🚀 Entry Point",
        message: "Every C program needs a main function.",
        hint: "Your program should have: int main() { ... return 0; } This is where execution begins.",
        encouragement: "The main function is where your program starts!",
      ));
    }
    
    // Check for return statement
    if (code.contains('int main') && !code.contains('return')) {
      guidance.add(_buildGuidance(
        title: "↩️ Return Statement",
        message: "Your main function is declared to return int.",
        hint: "Add 'return 0;' at the end of main to indicate successful execution. Non-zero values indicate errors.",
        encouragement: "Return values communicate program status!",
      ));
    }
    
    return guidance;
  }
  
  List<String> _analyzeJava(String code) {
    List<String> guidance = [];
    
    if (!code.contains('class')) {
      guidance.add(_buildGuidance(
        title: "🏗️ Class Structure",
        message: "Java requires all code to be inside a class.",
        hint: "Wrap your code in: public class Main { ... } Java is object-oriented, so everything lives in classes.",
        encouragement: "Classes are the building blocks of Java!",
      ));
    }
    
    if (code.contains('class') && !code.contains('public static void main')) {
      guidance.add(_buildGuidance(
        title: "🎯 Main Method",
        message: "Java applications need a main method to run.",
        hint: "Add: public static void main(String[] args) { ... } inside your class. This is the entry point.",
        encouragement: "The main method signature is always the same!",
      ));
    }
    
    return guidance;
  }
  
  List<String> _analyzeDart(String code) {
    List<String> guidance = [];
    
    if (!code.contains('main')) {
      guidance.add(_buildGuidance(
        title: "🎯 Entry Point",
        message: "Dart programs need a main function.",
        hint: "Add: void main() { ... } This is where your Dart program starts execution.",
        encouragement: "Every Dart app begins with main!",
      ));
    }
    
    if (code.contains('var ') && code.split('\n').length > 5) {
      guidance.add(_buildGuidance(
        title: "📋 Type Annotations",
        message: "Consider using explicit types for clarity.",
        hint: "Instead of 'var x = 5', you can use 'int x = 5'. Explicit types make code more readable and catch errors early.",
        encouragement: "Dart's type system helps prevent bugs!",
      ));
    }
    
    return guidance;
  }
  
  String _buildGuidance({
    required String title,
    required String message,
    required String hint,
    required String encouragement,
  }) {
    return '''$title

$message

💡 **Think about this:**
$hint

🌟 $encouragement''';
  }
}
