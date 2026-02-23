# Seera AI - Intelligent CV Builder 🚀

Seera is a premium, AI-powered CV building application designed to simplify the professional resume creation process. Users can generate state-of-the-art CVs through a sleek conversational AI interface or a meticulous manual form, ensuring both speed and precision.

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)](https://firebase.google.com)
[![Groq](https://img.shields.io/badge/Groq-AI-orange?style=for-the-badge)](https://groq.com)

## ✨ Key Features

- **Hybrid CV Creation**: A versatile "Dual-Mode" approach that combines the magic of AI with the reliability of a structured professional form.
- **Guided AI Chat Assistant**: An intelligent interviewer that helps you draft your professional essence. *Note: AI availability depends on provider capacity; we've built the app to handle this gracefully.*
- **Rock-Solid Manual Mode**: A meticulous, full-featured form that gives you absolute precision and control. It's the perfect companion to the chat or a reliable primary tool when AI limits are reached.
- **Seamless Fallback Logic**: Intelligent detection of AI rate limits (especially useful for free tier API keys) with localized prompts to keep your progress moving in Manual Mode.
- **Enhanced Project Portfolios**: Sophisticated support for multiple project links, designed with developers and technical professionals in mind.
- **Precision PDF Generation**: A custom engine that produces clean, LaTeX-inspired, ATS-friendly resumes in both English and Arabic.
- **Adaptive RTL/LTR Layouts**: Flawless bilingual support that respects language directionality throughout the entire user journey.

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Firebase project (configured for Google Sign-In and Auth)
- A Groq API Key

### Secure Setup
The project uses `--dart-define` for secure API key injection, keeping sensitive secrets out of the source code and configuration files.

1. **Clone the Repo**
   ```bash
   git clone https://github.com/ibrahim22khaled/seera.git
   cd seera
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Localization**
   ```bash
   flutter gen-l10n
   ```

4. **Launch with Secrets**
   Replace `YOUR_KEY` with your actual Groq API key:
   ```bash
   flutter run --dart-define=GROQ_API_KEY=YOUR_KEY
   ```

## 🏗️ Tech Stack

- **Core**: [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- **State Management**: [BloC (flutter_bloc)](https://pub.dev/packages/flutter_bloc)
- **AI Engine**: [Groq Cloud API](https://groq.com) (Llama 3.3 70B)
- **Backend**: [Firebase Authentication](https://firebase.google.com/docs/auth) & Google Sign-In
- **PDF Generation**: [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing)
- **Localization**: Flutter Intl (ARB files)

## 🛡️ License

Distributed under the MIT License. See `LICENSE` for more information.

## 👨‍💻 Developed By

Built with ❤️ by [Ibrahim Khaled](https://github.com/ibrahim22khaled)
