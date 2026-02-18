# Seera AI - Intelligent CV Builder

Seera is a modern, AI-powered CV building application that helps users create professional resumes through a simple conversational interface or a detailed manual form.

## 🚀 Features

- **AI Chat Mode**: Build your CV by talking to an intelligent assistant that collects your information step-by-step.
- **Manual Form Mode**: A structured way to enter your professional details with full control.
- **Real-time Preview**: See how your CV looks before generating the final document.
- **Professional PDF Generation**: Generates clean, ATS-friendly PDFs in both English and Arabic.
- **Multi-platform**: Built with Flutter for a seamless experience on Android, iOS, and Desktop.
- **Guest Access**: Explore the app's features without needing to sign up immediately.

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (^3.9.0)
- Firebase Account
- AI Provider API Key (Groq, OpenRouter, or Gemini)

### Configuration
1. Clone the repository.
2. Create a `.env` file in the root directory based on `.env.example`:
   ```env
   USE_MOCK_MODE=false
   GROQ_API_KEY=your_key_here
   OPEN_ROUTER_API_KEY=your_key_here
   GEMINI_API_KEY=your_key_here
   HUGGING_FACE_API_KEY=your_key_here
   ```
3. Run `flutter pub get` to install dependencies.
4. Run `flutter gen-l10n` for localization.
5. Launch the app: `flutter run`.

## 🛡️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developed By

[Ibrahim Khaled](https://github.com/ibrahim22khaled)
