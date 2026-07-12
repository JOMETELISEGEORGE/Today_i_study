# 📚 Today I Study – AI-Assisted Study Planner

Today I Study is a Flutter-based mobile application designed to help students organize their studies efficiently. The application combines AI-powered study planning with productivity tools such as focus mode, study tracking, and analytics to improve learning and time management.

---

## 🚀 Features

- 🔐 User Login & Signup
- 🤖 AI-generated personalized study plans
- 📅 Study Planner Dashboard
- 📖 Subject and syllabus management
- ⏱️ Focus Mode (Pomodoro-style study timer)
- 📊 Study Analytics & Progress Tracking
- 💾 Local data storage for offline access
- 🎨 Clean and responsive Flutter UI

---

## 🛠️ Technologies Used

- Flutter
- Dart
- Groq API (LLM)
- HTTP Package
- Shared Preferences
- Local Storage

---

## 📱 Application Modules

### Authentication
- User Login
- User Signup
- Persistent Login Session

### AI Study Planner
- Enter study subjects
- Set available study hours
- Generate personalized study plans using AI
- Save generated plans

### Planner Dashboard
- View today's study tasks
- Track weekly progress
- Monitor upcoming exams
- Mark completed tasks

### Syllabus Manager
- Add subjects and topics
- Track completed topics
- Store study notes

### Focus Mode
- Pomodoro-style study timer
- Session completion tracking
- Study duration recording

### Analytics
- Weekly study hours
- Task completion statistics
- Progress overview

---

## 📂 Project Structure

```
lib/
│
├── pages/
│   ├── login_page.dart
│   ├── signup_page.dart
│   ├── home.dart
│   ├── main_navi.dart
│   ├── syllabus/
│   ├── calm/
│   └── analytics/
│
├── planner/
│   ├── ai_planner_page.dart
│   ├── planner_dashboard.dart
│   ├── ai_service.dart
│   ├── storage_service.dart
│   └── models.dart
│
├── services/
│   ├── auth_services.dart
│   ├── storage_service.dart
│   └── theme_service.dart
│
└── main.dart
```

---

## ⚙️ Installation

1. Clone the repository

```bash
git clone https://github.com/yourusername/today-i-study.git
```

2. Open the project

```bash
cd today-i-study
```

3. Install dependencies

```bash
flutter pub get
```

4. Run the application

```bash
flutter run
```

---

## 🔑 API Configuration

The AI planner uses the **Groq API**.

Add your API key in the AI service file before running the application:

```dart
static const String apiKey = "YOUR_GROQ_API_KEY";
```

---

## 🎯 Future Enhancements

- Cloud synchronization
- Calendar integration
- Study reminders and notifications
- Multiple AI planning strategies
- Collaborative study groups
- Export study schedules to PDF

---

## 👩‍💻 Developed By

**Jomet Elise George**

Department of Computer Science & Engineering(Data Science)

New Horizon College of Engineering

---

## 📄 License

This project was developed for academic purposes as part of the undergraduate curriculum at New Horizon College of Engineering.
