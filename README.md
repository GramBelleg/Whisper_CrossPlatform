# Whisper_CrossPlatform 📱💬

A powerful, secure, and feature-rich cross-platform messaging app built with **Flutter** and **Dart**. Inspired by Telegram, Whisper aims to deliver smooth real-time communication, robust user privacy controls, and advanced messaging features — all wrapped in a clean, modern UI.

---

## 📌 Project Overview

Whisper_CrossPlatform is a messaging application that supports:
- Real-time text, voice, and media messaging
- Secure authentication with multiple providers
- Profile customization and privacy control
- Group and channel management
- Voice calling
- Admin moderation tools
- Global search and discovery

This project is built as a **Telegram Replica** with modern software design, robust architecture, and highly modular code — perfect for scale and production readiness.

---

## 🚀 Features

### 📍 Module 1: Authentication and Registration

- **User Registration**:
  - Register with email (save phone number).
  - CAPTCHA: “I am not a robot”.
  - Email verification with confirmation code.
  - Resend confirmation.
  - Optional phone/email verification.

- **Login/Logout**:
  - Login with email and password.
  - OAuth: Google, Facebook, GitHub.
  - Logout from current or all devices.

- **Account Recovery**:
  - Reset password via email.
  - Resend reset instructions.
  - Auto-logout after password change.

---

### 👤 Module 2: User Profile Management

- **Profile Settings**:
  - Add, delete, or change profile picture.
  - Bio update and screen name edit.
  - Change username (must be unique).
  - Update email or phone number.
  - Story: Add/Remove user stories.

- **Privacy Settings**:
  - Control visibility: profile, story, last seen.
  - Block/unblock users.
  - Enable/disable read receipts.
  - Group add control: Everyone/Admins.

---

### 💬 Module 3: Messaging

- **One-on-One Messaging**:
  - Send/receive/edit/delete messages.
  - Reply, forward, and mention users.
  - Voice messages, audio, static stickers, GIFs.
  - Mute user notifications.
  - Drafts and device sync.

- **Media Messaging**:
  - Support images, videos, documents (PDF, Word).
  - File size limits and auto-download control.

---

### 👥 Module 4: Group and Channel Management

- **Group Chats**:
  - Create/delete groups, assign admins.
  - User permissions: post/edit/delete, download access.
  - Set public/private, group limit (~1,000).
  - Announcement mode, member list view, search.

- **Channels**:
  - Broadcast-only channels with infinite subscribers.
  - Admin permissions.
  - Control content download access.

---

### 📞 Module 5: Voice Calls

- One-on-one and group voice calls.
- End-to-end encryption.
- Mute/unmute, call duration tracking, call logs.

---

### 🛠️ Module 6: Admin Dashboard

- View/manage registered users.
- Ban/deactivate users.
- AI-based inappropriate content filtering in groups.

---

### 🔍 Module 7: Search and Discover

- Chat & message search with filters (text, media).
- Global search:
  - Public groups/channels.
  - Users by username, name, email, or phone.

---

### 📂 Media and Files

- Image, video, document sharing.
- Compress/full-size media options.
- Max upload size (e.g., 100MB).
- In-app media player for audio/video.
- Download files with/without preview.

---

## 🧪 Tech Stack

| Layer          | Technology         |
|----------------|--------------------|
| Frontend       | **Flutter**        |
| Language       | **Dart**           |
| Real-Time Comm | Socket.IO, REST API|
| State Mgmt     | Cubit (Bloc)       |


---

## 🎬 Demo

> 📽️ [Demo](https://drive.google.com/drive/folders/14o2fgZDff0Uxrkb-QJlNwdY3Y2Ng0C_p)  

---

## 🛠️ How to Run

1. **Clone the Repo**  
   ```bash
   git clone https://github.com/YourUsername/Whisper_CrossPlatform.git
   cd Whisper_CrossPlatform
2. **Install Dependencies**
   ```bash
   flutter pub get
3. **Run the App**
   ```bash
   flutter run 
