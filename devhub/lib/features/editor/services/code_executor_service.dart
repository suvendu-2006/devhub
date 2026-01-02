/// Code Syntax Checker Service
/// 
/// Validates code syntax and provides helpful error messages.
/// This is a syntax checker, NOT a code executor.

class CodeExecutorService {
  Future<String> execute(String code, String language) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      if (code.trim().isEmpty) {
        return '⚠️ No code to check. Write some code first!';
      }
      
      // Run comprehensive syntax checks
      List<String> errors = _checkSyntax(code, language);
      
      if (errors.isNotEmpty) {
        StringBuffer result = StringBuffer();
        result.writeln('❌ Found ${errors.length} issue${errors.length > 1 ? 's' : ''}:\n');
        for (int i = 0; i < errors.length; i++) {
          result.writeln('${i + 1}. ${errors[i]}');
          if (i < errors.length - 1) result.writeln('');
        }
        return result.toString();
      }
      
      // If no errors, show simulated output
      List<String> outputs = _extractPrintStatements(code, language);
      
      StringBuffer result = StringBuffer();
      result.writeln('✅ Syntax looks good!\n');
      
      if (outputs.isNotEmpty) {
        result.writeln('📤 Expected output:');
        result.writeln('─' * 25);
        for (var output in outputs) {
          result.writeln(output);
        }
        result.writeln('─' * 25);
      } else {
        result.writeln('💡 No print statements found.');
        result.writeln('   Add a print statement to see output.');
      }
      
      return result.toString();
    } catch (e) {
      return '❌ Error during syntax check: $e';
    }
  }
  
  List<String> _checkSyntax(String code, String language) {
    List<String> errors = [];
    
    // Common checks for all languages
    errors.addAll(_checkBrackets(code));
    errors.addAll(_checkQuotes(code));
    errors.addAll(_checkGarbageText(code));
    
    // Language-specific checks
    switch (language) {
      case 'Python':
        errors.addAll(_checkPython(code));
        break;
      case 'JavaScript':
        errors.addAll(_checkJavaScript(code));
        break;
      case 'C':
        errors.addAll(_checkC(code));
        break;
      case 'Java':
        errors.addAll(_checkJava(code));
        break;
      case 'Dart':
        errors.addAll(_checkDart(code));
        break;
    }
    
    return errors;
  }
  
  List<String> _checkBrackets(String code) {
    List<String> errors = [];
    
    int parens = 0, brackets = 0, braces = 0;
    bool inString = false;
    String stringChar = '';
    
    for (int i = 0; i < code.length; i++) {
      String c = code[i];
      
      // Track string state
      if ((c == '"' || c == "'") && (i == 0 || code[i - 1] != '\\')) {
        if (!inString) {
          inString = true;
          stringChar = c;
        } else if (c == stringChar) {
          inString = false;
        }
      }
      
      if (!inString) {
        if (c == '(') parens++;
        if (c == ')') parens--;
        if (c == '[') brackets++;
        if (c == ']') brackets--;
        if (c == '{') braces++;
        if (c == '}') braces--;
        
        if (parens < 0) errors.add('Unexpected ) - missing opening parenthesis');
        if (brackets < 0) errors.add('Unexpected ] - missing opening bracket');
        if (braces < 0) errors.add('Unexpected } - missing opening brace');
      }
    }
    
    if (parens > 0) errors.add('Missing ) - ${parens} unclosed parenthesis');
    if (brackets > 0) errors.add('Missing ] - ${brackets} unclosed bracket');
    if (braces > 0) errors.add('Missing } - ${braces} unclosed brace');
    
    return errors;
  }
  
  List<String> _checkQuotes(String code) {
    List<String> errors = [];
    
    int singleQuotes = 0, doubleQuotes = 0;
    for (int i = 0; i < code.length; i++) {
      if (code[i] == "'" && (i == 0 || code[i - 1] != '\\')) singleQuotes++;
      if (code[i] == '"' && (i == 0 || code[i - 1] != '\\')) doubleQuotes++;
    }
    
    if (singleQuotes % 2 != 0) errors.add("Unclosed string - missing closing '");
    if (doubleQuotes % 2 != 0) errors.add('Unclosed string - missing closing "');
    
    return errors;
  }
  
  List<String> _checkGarbageText(String code) {
    List<String> errors = [];
    
    // Only check for obviously malformed patterns
    // Check for completely empty braces/parens that shouldn't be
    if (code.contains('()()')) {
      errors.add('Unexpected ()() - possible syntax error');
    }
    
    if (code.contains('{}{}')) {
      errors.add('Unexpected {}{} - possible syntax error');
    }
    
    return errors;
  }
  
  bool _isKeyword(String word) {
    const keywords = ['print', 'input', 'float', 'return', 'while', 'break', 
      'class', 'function', 'const', 'import', 'from', 'async', 'await',
      'public', 'private', 'static', 'void', 'String', 'result', 'number'];
    return keywords.contains(word.toLowerCase());
  }
  
  List<String> _checkPython(String code) {
    List<String> errors = [];
    
    final lines = code.split('\n');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      // Check for missing colon after control statements
      if (line.startsWith('if ') || line.startsWith('for ') || 
          line.startsWith('while ') || line.startsWith('def ') ||
          line.startsWith('class ') || line.startsWith('elif ') ||
          line.startsWith('else') || line.startsWith('try') ||
          line.startsWith('except') || line.startsWith('finally')) {
        if (!line.endsWith(':') && !line.contains('#')) {
          errors.add('Line ${i + 1}: Missing colon (:) after "${line.split(' ').first}"');
        }
      }
      
      // Check for print without parentheses
      if (line.contains('print ') && !line.contains('print(')) {
        errors.add('Line ${i + 1}: print needs parentheses in Python 3 → print(...)');
      }
    }
    
    // Check for f-string issues
    if (code.contains('f"') || code.contains("f'")) {
      int fStringStart = code.indexOf('f"');
      if (fStringStart == -1) fStringStart = code.indexOf("f'");
      
      // Look for unclosed braces in f-strings
      int braceCount = 0;
      bool inFString = false;
      for (int i = 0; i < code.length; i++) {
        if (i > 0 && code[i-1] == 'f' && (code[i] == '"' || code[i] == "'")) {
          inFString = true;
        }
        if (inFString) {
          if (code[i] == '{') braceCount++;
          if (code[i] == '}') braceCount--;
          if ((code[i] == '"' || code[i] == "'") && i > fStringStart + 1) {
            inFString = false;
            if (braceCount != 0) {
              errors.add('Unclosed { in f-string');
              braceCount = 0;
            }
          }
        }
      }
    }
    
    return errors;
  }
  
  List<String> _checkJavaScript(String code) {
    List<String> errors = [];
    
    // Check for var usage
    if (code.contains('var ')) {
      errors.add('Consider using "let" or "const" instead of "var" (modern JS)');
    }
    
    // Check for === vs ==
    if (code.contains(' == ') && !code.contains(' === ')) {
      errors.add('Using == instead of === can cause type coercion issues');
    }
    
    return errors;
  }
  
  List<String> _checkC(String code) {
    List<String> errors = [];
    
    if (code.contains('printf') && !code.contains('#include')) {
      errors.add('Missing #include <stdio.h> for printf');
    }
    
    if (!code.contains('main')) {
      errors.add('Missing main() function - C programs need an entry point');
    }
    
    if (code.contains('int main') && !code.contains('return')) {
      errors.add('Missing return statement in main()');
    }
    
    return errors;
  }
  
  List<String> _checkJava(String code) {
    List<String> errors = [];
    
    if (!code.contains('class')) {
      errors.add('Missing class declaration - Java code must be in a class');
    }
    
    if (code.contains('class') && !code.contains('public static void main')) {
      errors.add('Missing main method - add: public static void main(String[] args)');
    }
    
    return errors;
  }
  
  List<String> _checkDart(String code) {
    List<String> errors = [];
    
    if (!code.contains('main')) {
      errors.add('Missing main() function');
    }
    
    return errors;
  }
  
  List<String> _extractPrintStatements(String code, String language) {
    List<String> outputs = [];
    
    List<RegExp> patterns = [];
    switch (language) {
      case 'Python':
        patterns = [
          RegExp(r'print\s*\(\s*"([^"]*)"'),
          RegExp(r"print\s*\(\s*'([^']*)'"),
          RegExp(r'print\s*\(\s*f"([^"]*)"'),
          RegExp(r"print\s*\(\s*f'([^']*)'"),
        ];
        break;
      case 'JavaScript':
        patterns = [
          RegExp(r'console\.log\s*\(\s*"([^"]*)"'),
          RegExp(r"console\.log\s*\(\s*'([^']*)'"),
        ];
        break;
      case 'C':
        patterns = [RegExp(r'printf\s*\(\s*"([^"]*)"')];
        break;
      case 'Java':
        patterns = [RegExp(r'System\.out\.println\s*\(\s*"([^"]*)"')];
        break;
      case 'Dart':
        patterns = [
          RegExp(r'print\s*\(\s*"([^"]*)"'),
          RegExp(r"print\s*\(\s*'([^']*)'"),
        ];
        break;
    }
    
    for (var pattern in patterns) {
      for (var match in pattern.allMatches(code)) {
        outputs.add(match.group(1) ?? '');
      }
    }
    
    return outputs;
  }
}
