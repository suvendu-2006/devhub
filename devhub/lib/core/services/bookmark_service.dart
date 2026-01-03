import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class BookmarkService extends ChangeNotifier {
  Set<String> _bookmarkedCourses = {};
  Set<String> _bookmarkedArticles = {};
  
  BookmarkService() {
    _loadBookmarks();
  }
  
  void _loadBookmarks() {
    _bookmarkedCourses = StorageService.getBookmarkedIds('course').toSet();
    _bookmarkedArticles = StorageService.getBookmarkedIds('article').toSet();
    notifyListeners();
  }
  
  // Course bookmarks
  bool isCourseBookmarked(String courseId) {
    return _bookmarkedCourses.contains(courseId);
  }
  
  Future<void> toggleCourseBookmark(String courseId) async {
    if (_bookmarkedCourses.contains(courseId)) {
      _bookmarkedCourses.remove(courseId);
      await StorageService.removeBookmark('course', courseId);
    } else {
      _bookmarkedCourses.add(courseId);
      await StorageService.addBookmark('course', courseId);
    }
    notifyListeners();
  }
  
  List<String> get bookmarkedCourseIds => _bookmarkedCourses.toList();
  
  // Article bookmarks
  bool isArticleBookmarked(String articleId) {
    return _bookmarkedArticles.contains(articleId);
  }
  
  Future<void> toggleArticleBookmark(String articleId) async {
    if (_bookmarkedArticles.contains(articleId)) {
      _bookmarkedArticles.remove(articleId);
      await StorageService.removeBookmark('article', articleId);
    } else {
      _bookmarkedArticles.add(articleId);
      await StorageService.addBookmark('article', articleId);
    }
    notifyListeners();
  }
  
  List<String> get bookmarkedArticleIds => _bookmarkedArticles.toList();
  
  // Stats
  int get totalBookmarks => _bookmarkedCourses.length + _bookmarkedArticles.length;
}
