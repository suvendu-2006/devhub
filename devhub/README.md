# DevHub

A comprehensive college project app built with Flutter/Dart, designed to foster genuine coding skills in beginner programmers.

## 🚀 Features

### 1. Guided Code Editor
- **Custom Code Editor** with syntax highlighting and line numbers
- **AI-Powered Feedback** that provides guided hints (not solutions)
- **In-App Code Execution** with output visualization
- **Multi-Language Support**: Python, JavaScript, C, Java, Dart

### 2. AI Courses & Opportunities
- **Curated Free Courses** from Google, Microsoft, DeepLearning.AI, fast.ai, Hugging Face, IBM
- **Category Filtering**: Machine Learning, Deep Learning, NLP, Computer Vision
- **Real-Time Opportunities**: Internships and job listings from top tech companies

### 3. Global Community
- **Profile Registration**: Name, Email, LinkedIn ID with skills selection
- **Friends Section**: Search and add friends, view connections
- **Global Section**: Smart profile suggestions based on skills and interests
- **LinkedIn Integration**: Direct links to professional profiles

### 4. AI News Feed
- **Real-Time Updates**: Latest AI news from top sources
- **Category Filtering**: AI Research, Industry, Startups
- **Breaking News Badges**: Highlighted important announcements
- **Pull-to-Refresh**: Stay updated with latest developments

## 📱 Screenshots

The app features a modern dark theme with:
- Vibrant gradient accents
- Glassmorphism effects
- Smooth animations
- Premium UI/UX design

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package
- **Typography**: Google Fonts (Inter)

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  http: ^1.1.2
  url_launcher: ^6.2.2
  intl: ^0.18.1
  flutter_highlight: ^0.7.0
  google_fonts: ^6.1.0
```

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd devhub
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # Entry point
├── core/
│   └── theme/
│       └── app_theme.dart    # App theming
├── features/
│   ├── editor/               # Code Editor
│   ├── courses/              # AI Courses
│   ├── community/            # Community Tab
│   └── news/                 # AI News
└── navigation/
    └── app_navigation.dart   # Bottom navigation
```

## 🎯 Key Design Decisions

1. **AI Feedback Philosophy**: The AI assistant provides guidance and hints, not direct solutions, to enhance problem-solving skills.

2. **Local-First**: Profiles and friends are stored locally for this college project. Can be extended to use a backend.

3. **Modular Architecture**: Feature-based folder structure for easy maintenance and scalability.

## 👨‍💻 For Beginners

This app is designed to help you:
- Learn coding through guided feedback
- Access free AI/ML courses from top companies
- Connect with fellow learners
- Stay updated with AI industry news

## 📝 License

This project is created for educational purposes.
