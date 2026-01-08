// Code Syntax Checker Service
// 
// Validates code syntax and provides helpful error messages.
// This is a comprehensive syntax checker for detecting real errors.

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
    bool inMultiLineString = false;
    
    for (int i = 0; i < code.length; i++) {
      String c = code[i];
      
      // Check for multi-line strings (Python triple quotes)
      if (i + 2 < code.length && (code.substring(i, i + 3) == '"""' || code.substring(i, i + 3) == "'''")) {
        if (!inMultiLineString) {
          inMultiLineString = true;
          i += 2;
          continue;
        } else {
          inMultiLineString = false;
          i += 2;
          continue;
        }
      }
      
      if (inMultiLineString) continue;
      
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
        
        if (parens < 0) {
          errors.add('Unexpected ) at position ${i + 1} - missing opening parenthesis');
          parens = 0; // Reset to continue checking
        }
        if (brackets < 0) {
          errors.add('Unexpected ] at position ${i + 1} - missing opening bracket');
          brackets = 0;
        }
        if (braces < 0) {
          errors.add('Unexpected } at position ${i + 1} - missing opening brace');
          braces = 0;
        }
      }
    }
    
    if (parens > 0) errors.add('Missing ) - $parens unclosed parenthesis${parens > 1 ? 'es' : ''}');
    if (brackets > 0) errors.add('Missing ] - $brackets unclosed bracket${brackets > 1 ? 's' : ''}');
    if (braces > 0) errors.add('Missing } - $braces unclosed brace${braces > 1 ? 's' : ''}');
    
    return errors;
  }
  
  List<String> _checkQuotes(String code) {
    List<String> errors = [];
    
    // Check for unclosed strings line by line (excluding multi-line strings)
    final lines = code.split('\n');
    for (int lineNum = 0; lineNum < lines.length; lineNum++) {
      String line = lines[lineNum];
      
      // Skip lines with triple quotes (multi-line strings)
      if (line.contains('"""') || line.contains("'''")) continue;
      
      // Count quotes not escaped
      int singleQuotes = 0, doubleQuotes = 0;
      for (int i = 0; i < line.length; i++) {
        bool isEscaped = i > 0 && line[i - 1] == '\\';
        if (line[i] == "'" && !isEscaped) singleQuotes++;
        if (line[i] == '"' && !isEscaped) doubleQuotes++;
      }
      
      if (singleQuotes % 2 != 0) {
        errors.add("Line ${lineNum + 1}: Unclosed string - missing closing '");
      }
      if (doubleQuotes % 2 != 0) {
        errors.add('Line ${lineNum + 1}: Unclosed string - missing closing "');
      }
    }
    
    return errors;
  }
  
  List<String> _checkPython(String code) {
    List<String> errors = [];
    
    final lines = code.split('\n');
    int expectedIndent = 0;
    bool inMultiLineString = false;
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String trimmed = line.trim();
      
      // Skip empty lines and comments
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      
      // Track multi-line strings
      if (trimmed.contains('"""') || trimmed.contains("'''")) {
        int tripleDouble = '"""'.allMatches(line).length;
        int tripleSingle = "'''".allMatches(line).length;
        if ((tripleDouble + tripleSingle) % 2 != 0) {
          inMultiLineString = !inMultiLineString;
        }
      }
      if (inMultiLineString) continue;
      
      // Check for missing colon after control statements
      List<String> colonKeywords = ['if', 'elif', 'else', 'for', 'while', 'def', 'class', 'try', 'except', 'finally', 'with'];
      for (var keyword in colonKeywords) {
        if (trimmed == keyword || trimmed.startsWith('${keyword} ') || trimmed.startsWith('${keyword}(')) {
          if (!trimmed.endsWith(':') && !trimmed.contains('#')) {
            // Check if it's a complete statement (not a continuation)
            if (!trimmed.endsWith('\\') && !trimmed.endsWith(',')) {
              errors.add('Line ${i + 1}: Missing colon (:) after "${keyword}" statement');
            }
          }
        }
      }
      
      // Check for print without parentheses (Python 2 style)
      if (RegExp(r'\bprint\s+[^(]').hasMatch(trimmed) && !trimmed.contains('print(')) {
        errors.add('Line ${i + 1}: print needs parentheses in Python 3 → print(...)');
      }
      
      // Check for invalid assignment operators
      if (trimmed.contains('=+') && !trimmed.contains('+=')) {
        errors.add('Line ${i + 1}: Invalid operator "=+" - did you mean "+="?');
      }
      if (trimmed.contains('=-') && !trimmed.contains('-=') && !RegExp(r'=\s*-\d').hasMatch(trimmed)) {
        errors.add('Line ${i + 1}: Invalid operator "=-" - did you mean "-="?');
      }
      
      // Check for common typos in keywords
      if (trimmed.contains('pritn') || trimmed.contains('pirnt') || trimmed.contains('prnit')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "print"?');
      }
      if (trimmed.contains('retrun') || trimmed.contains('reutrn') || trimmed.contains('retrn')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "return"?');
      }
      if (trimmed.contains('improt') || trimmed.contains('ipmort') || trimmed.contains('imoprt')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "import"?');
      }
      if (trimmed.contains('fucntion') || trimmed.contains('funtion') || trimmed.contains('funciton')) {
        errors.add('Line ${i + 1}: Typo detected - Python uses "def" for functions');
      }
      
      // Check for = instead of == in conditions
      if ((trimmed.startsWith('if ') || trimmed.startsWith('elif ') || trimmed.startsWith('while ')) &&
          RegExp(r'[^=!<>]=(?!=)').hasMatch(trimmed) &&
          !trimmed.contains(':=')) { // walrus operator is valid
        // Check it's not an assignment inside the condition
        String condition = trimmed.split(':')[0];
        if (!condition.contains('(') || condition.indexOf('=') < condition.indexOf('(')) {
          errors.add('Line ${i + 1}: Using "=" instead of "==" in condition - did you mean to compare?');
        }
      }
      
      // Check for invalid Python syntax patterns
      if (trimmed.contains(';;')) {
        errors.add('Line ${i + 1}: Double semicolon ";;" is invalid in Python');
      }
      
      // Check for misplaced colons
      if (trimmed.startsWith(':')) {
        errors.add('Line ${i + 1}: Unexpected ":" at the beginning of line');
      }
      
      // Check for function calls without arguments list
      if (RegExp(r'\w+\(\s*$').hasMatch(trimmed) && !trimmed.endsWith(',') && !trimmed.endsWith('\\')) {
        // This might be an incomplete function call
        if (i == lines.length - 1 || !lines[i + 1].trim().startsWith(')')) {
          errors.add('Line ${i + 1}: Incomplete function call - missing closing ")"');
        }
      }
    }
    
    // Check for indentation issues
    bool hasBlockStarter = code.contains(':');
    if (hasBlockStarter) {
      bool hasIndentedCode = false;
      for (var line in lines) {
        if (line.startsWith('    ') || line.startsWith('\t')) {
          hasIndentedCode = true;
          break;
        }
      }
      // Only warn if there's no indented code after block starters
      int colonCount = ':'.allMatches(code).length;
      if (!hasIndentedCode && colonCount > 0 && lines.length > 1) {
        bool hasCodeAfterColon = false;
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].trim().endsWith(':') && i + 1 < lines.length) {
            String nextLine = lines[i + 1].trim();
            if (nextLine.isNotEmpty && !nextLine.startsWith('#')) {
              hasCodeAfterColon = true;
              if (!lines[i + 1].startsWith(' ') && !lines[i + 1].startsWith('\t')) {
                errors.add('Line ${i + 2}: Expected indented block after ":"');
              }
            }
          }
        }
      }
    }
    
    return errors;
  }
  
  List<String> _checkJavaScript(String code) {
    List<String> errors = [];
    final lines = code.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String trimmed = line.trim();
      
      // Skip comments
      if (trimmed.startsWith('//')) continue;
      
      // Check for common typos
      if (trimmed.contains('consloe') || trimmed.contains('consoel') || trimmed.contains('conosle')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "console"?');
      }
      if (trimmed.contains('fucntion') || trimmed.contains('funtion') || trimmed.contains('funciton')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "function"?');
      }
      if (trimmed.contains('retrun') || trimmed.contains('reutrn')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "return"?');
      }
      if (trimmed.contains('constt') || trimmed.contains('cosnt')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "const"?');
      }
      
      // Check for missing function body
      if (RegExp(r'function\s+\w+\s*\([^)]*\)\s*$').hasMatch(trimmed)) {
        errors.add('Line ${i + 1}: Function declaration missing body - add { }');
      }
      
      // Check for arrow functions without body
      if (trimmed.contains('=>') && !trimmed.contains('{') && trimmed.endsWith('=>')) {
        errors.add('Line ${i + 1}: Arrow function has no body after "=>"');
      }
      
      // Check for invalid operators
      if (trimmed.contains('=+') && !trimmed.contains('+=')) {
        errors.add('Line ${i + 1}: Invalid operator "=+" - did you mean "+="?');
      }
      
      // Check for missing quotes in strings
      if (RegExp(r'console\.log\(\s*[a-zA-Z]').hasMatch(trimmed)) {
        // Check if the argument is a variable or unquoted string
        RegExp logPattern = RegExp(r'console\.log\(\s*([^)]+)\)');
        var match = logPattern.firstMatch(trimmed);
        if (match != null) {
          String arg = match.group(1)!.trim();
          if (!arg.startsWith('"') && !arg.startsWith("'") && !arg.startsWith('`') &&
              !RegExp(r'^\d').hasMatch(arg) && !arg.contains('+') && 
              !arg.startsWith('true') && !arg.startsWith('false') &&
              arg.contains(' ')) {
            errors.add('Line ${i + 1}: String not quoted in console.log() - use quotes around text');
          }
        }
      }
    }
    
    // Check for var usage (warning)
    if (code.contains('var ')) {
      errors.add('Warning: Using "var" - consider using "let" or "const" instead');
    }
    
    // Check for === vs ==
    if (code.contains(' == ') && !code.contains(' === ')) {
      errors.add('Warning: Using "==" instead of "===" can cause type coercion issues');
    }
    
    return errors;
  }
  
  List<String> _checkC(String code) {
    List<String> errors = [];
    final lines = code.split('\n');
    
    // Check for required includes
    if (code.contains('printf') && !code.contains('#include')) {
      errors.add('Missing #include <stdio.h> for printf');
    }
    if (code.contains('scanf') && !code.contains('stdio.h')) {
      errors.add('Missing #include <stdio.h> for scanf');
    }
    if ((code.contains('malloc') || code.contains('free')) && !code.contains('stdlib.h')) {
      errors.add('Missing #include <stdlib.h> for malloc/free');
    }
    if (code.contains('strlen') && !code.contains('string.h')) {
      errors.add('Missing #include <string.h> for strlen');
    }
    
    // Check for main function
    if (!code.contains('main')) {
      errors.add('Missing main() function - C programs need an entry point');
    }
    
    // Check for return statement in main
    if (code.contains('int main') && !code.contains('return')) {
      errors.add('Missing return statement in main() - add "return 0;"');
    }
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String trimmed = line.trim();
      
      // Skip preprocessor directives and comments
      if (trimmed.startsWith('#') || trimmed.startsWith('//') || trimmed.startsWith('/*')) continue;
      
      // Check for missing semicolons on statements
      if (trimmed.isNotEmpty && 
          !trimmed.endsWith('{') && !trimmed.endsWith('}') && 
          !trimmed.endsWith(';') && !trimmed.endsWith(',') &&
          !trimmed.startsWith('if') && !trimmed.startsWith('for') && 
          !trimmed.startsWith('while') && !trimmed.startsWith('else') &&
          !trimmed.startsWith('//') && !trimmed.startsWith('/*') &&
          !trimmed.endsWith(':') && // labels
          (trimmed.contains('=') || trimmed.contains('printf') || 
           trimmed.contains('scanf') || trimmed.contains('return') ||
           RegExp(r'\w+\s*\([^)]*\)$').hasMatch(trimmed))) {
        errors.add('Line ${i + 1}: Missing semicolon at end of statement');
      }
      
      // Check for common typos
      if (trimmed.contains('prtinf') || trimmed.contains('pritnf') || trimmed.contains('printd')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "printf"?');
      }
      if (trimmed.contains('retrun') || trimmed.contains('reutrn')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "return"?');
      }
    }
    
    return errors;
  }
  
  List<String> _checkJava(String code) {
    List<String> errors = [];
    final lines = code.split('\n');
    
    // Check for class declaration
    if (!code.contains('class')) {
      errors.add('Missing class declaration - Java code must be inside a class');
    }
    
    // Check for main method
    if (code.contains('class') && !code.contains('public static void main')) {
      errors.add('Missing main method - add: public static void main(String[] args)');
    }
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String trimmed = line.trim();
      
      // Skip comments
      if (trimmed.startsWith('//') || trimmed.startsWith('/*')) continue;
      
      // Check for missing semicolons
      if (trimmed.isNotEmpty && 
          !trimmed.endsWith('{') && !trimmed.endsWith('}') && 
          !trimmed.endsWith(';') && !trimmed.endsWith(',') &&
          !trimmed.startsWith('if') && !trimmed.startsWith('for') && 
          !trimmed.startsWith('while') && !trimmed.startsWith('else') &&
          !trimmed.startsWith('class') && !trimmed.startsWith('public') &&
          !trimmed.startsWith('private') && !trimmed.startsWith('protected') &&
          !trimmed.startsWith('//') && !trimmed.startsWith('@') &&
          (trimmed.contains('=') || trimmed.contains('System.out') || 
           trimmed.contains('return') || RegExp(r'\w+\s*\([^)]*\)$').hasMatch(trimmed))) {
        errors.add('Line ${i + 1}: Missing semicolon at end of statement');
      }
      
      // Check for print statement errors
      if (trimmed.contains('System.out.print') && !trimmed.contains('System.out.println') && !trimmed.contains('System.out.print(')) {
        errors.add('Line ${i + 1}: System.out.print needs parentheses');
      }
      
      // Check for common typos
      if (trimmed.contains('Systme') || trimmed.contains('Ssytem') || trimmed.contains('Sysetm')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "System"?');
      }
      if (trimmed.contains('pritnln') || trimmed.contains('printlnn') || trimmed.contains('prtinln')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "println"?');
      }
    }
    
    return errors;
  }
  
  List<String> _checkDart(String code) {
    List<String> errors = [];
    final lines = code.split('\n');
    
    // Check for main function
    if (!code.contains('main')) {
      errors.add('Missing main() function - Dart programs need an entry point');
    }
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String trimmed = line.trim();
      
      // Skip comments
      if (trimmed.startsWith('//') || trimmed.startsWith('/*')) continue;
      
      // Check for missing semicolons
      if (trimmed.isNotEmpty && 
          !trimmed.endsWith('{') && !trimmed.endsWith('}') && 
          !trimmed.endsWith(';') && !trimmed.endsWith(',') &&
          !trimmed.startsWith('if') && !trimmed.startsWith('for') && 
          !trimmed.startsWith('while') && !trimmed.startsWith('else') &&
          !trimmed.startsWith('class') && !trimmed.startsWith('//') &&
          !trimmed.endsWith('=>') && !trimmed.contains('=>') &&
          (trimmed.contains('=') || trimmed.contains('print(') || 
           trimmed.contains('return') || RegExp(r'\w+\s*\([^)]*\)$').hasMatch(trimmed))) {
        errors.add('Line ${i + 1}: Missing semicolon at end of statement');
      }
      
      // Check for common typos
      if (trimmed.contains('pritn') || trimmed.contains('pirnt') || trimmed.contains('prnt')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "print"?');
      }
      if (trimmed.contains('retrun') || trimmed.contains('reutrn')) {
        errors.add('Line ${i + 1}: Typo detected - did you mean "return"?');
      }
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
          RegExp(r'console\.log\s*\(\s*`([^`]*)`'),
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
