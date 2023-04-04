import 'package:flutter/material.dart';

import 'index.dart';

abstract class LanguageBase {
  LanguageTheme? get languageTheme;
  TextSpan format(String src);
  Language get type;
}

/// Supported Languages Enum
enum Language { DART, C, CPP, JAVASCRIPT, KOTLIN, JAVA, SWIFT, YAML }

/// Tokens
enum HighlightType { number, comment, keyword, string, punctuation, klass, constant }

class HighlightSpan {
  HighlightSpan(this.type, this.start, this.end);
  final HighlightType type;
  final int start;
  final int end;

  String textForSpan(String src) {
    return src.substring(start, end);
  }

  TextStyle? textStyle(LanguageTheme? languageTheme) {
    if (type == HighlightType.number)
      return languageTheme!.numberStyle;
    else if (type == HighlightType.comment)
      return languageTheme!.commentStyle;
    else if (type == HighlightType.keyword)
      return languageTheme!.keywordStyle;
    else if (type == HighlightType.string)
      return languageTheme!.stringStyle;
    else if (type == HighlightType.punctuation)
      return languageTheme!.punctuationStyle;
    else if (type == HighlightType.klass)
      return languageTheme!.classStyle;
    else if (type == HighlightType.constant)
      return languageTheme!.constantStyle;
    else
      return languageTheme!.baseStyle;
  }
}

LanguageBase getSyntax(Language lang, LanguageTheme? theme) {
  switch (lang) {
    case Language.DART:
      return DartSyntaxHighlighter(theme);
    case Language.C:
      return CSyntaxHighlighter(theme);
    case Language.CPP:
      return CPPSyntaxHighlighter(theme);
    case Language.JAVA:
      return JavaSyntaxHighlighter(theme);
    case Language.KOTLIN:
      return KotlinSyntaxHighlighter(theme);
    case Language.SWIFT:
      return SwiftSyntaxHighlighter(theme);
    case Language.JAVASCRIPT:
      return JavaScriptSyntaxHighlighter(theme);
    case Language.YAML:
      return YamlSyntaxHighlighter(theme);
    default:
      return DartSyntaxHighlighter(theme);
  }
}
