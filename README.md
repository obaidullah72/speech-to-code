# 🧠 speech-to-code (Flutter Frontend)

A Flutter application that allows users to **speak natural language commands** and convert them into **Python code** using OpenAI — with support for **live speech input**, **syntax-highlighted code editing**, and **execution via Node.js backend**.

🌐 Backend repo: [speech2code-backend](https://github.com/obaidullah72/speech2code-backend)  
📱 Frontend repo: [speech-to-code](https://github.com/obaidullah72/speech-to-code)

---

## 🚀 Features

- 🎙️ **Voice-to-Text**: Speak your coding instruction.
- 🧠 **AI-Powered Code Generation**: OpenAI generates clean Python code.
- 💻 **In-App Code Editor**: View and edit code with syntax highlighting.
- ⚡ **Remote Code Execution**: Run the generated Python code via the backend.
- 🧵 **Beautiful UI**: Powered by Google Fonts and modern icon packs.

---

## 🛠️ Dependencies

```yaml
dependencies:
  http: ^1.3.0
  google_fonts: ^6.2.1
  speech_to_text: ^7.0.0
  flutter_code_editor: ^0.3.3
  highlight: ^0.7.0
  iconsax: ^0.0.8
```

---

## 🔗 Backend Integration

This app connects to the Node.js backend hosted at:

```
https://github.com/obaidullah72/speech2code-backend
```

Make sure to:
1. Clone and run the backend.
2. Ensure the backend is running on `http://localhost:3000` (or update the API base URL in your Flutter code if deployed remotely).

---

## 📱 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/obaidullah72/speech-to-code.git
cd speech-to-code
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

> 🎯 Make sure your device/emulator is running and your backend server is active.

---

## 📸 Screenshots

*(Add screenshots of the UI here if available for visual context)*

---

## 🧠 How It Works

1. User speaks a command (e.g., "Create a function to calculate factorial").
2. Speech is converted to text using `speech_to_text`.
3. The text is sent to the backend `/api/text-to-code` endpoint.
4. OpenAI generates Python code.
5. The response is shown inside a syntax-highlighted editor.
6. User can execute code by calling `/api/execute-code`.

---

## 🧪 API Usage Summary

- `POST /api/voice-to-text` — Receives spoken input (optional)
- `POST /api/text-to-code` — Returns generated Python code
- `POST /api/execute-code` — Returns stdout from executing code

---

## 🤖 Requirements

- Flutter SDK
- OpenAI API key (on backend)
- Python installed (on backend machine)

---

## 📄 License

MIT License

---

## 👨‍💻 Author

**Obaidullah**  
GitHub: [obaidullah72](https://github.com/obaidullah72)
