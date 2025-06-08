# 🚀 Postiz - Open Source Social Media Scheduler

<div align="center">

```
 *   *  **  **  *   *
| | | | \ \/ / | | | |
| | | |  \  /  | | | |
| |_| |  /  \  | |_| |
 \___/  /_/\_\  \___/
```

**🌟 Zarządzaj wszystkimi swoimi social media z jednego miejsca! 🌟**

</div>

## 1️⃣ 🎯 Co to jest Postiz i po co?

**Postiz** to **darmowe, open-source** narzędzie do zarządzania social media, które pozwala:

🎨 **Planować i publikować** posty na wszystkich platformach jednocześnie  
🤖 **Generować treści** za pomocą sztucznej inteligencji (OpenAI)  
📅 **Harmonogram publikacji** - ustaw raz, publikuj automatycznie  
📊 **Analizować wydajność** postów i engażement  
👥 **Zarządzać zespołem** i uprawnieniami użytkowników  
🔗 **Skracać linki** i śledzić kliki  
📧 **Powiadomienia email** o publikacjach

### ✨ **Dlaczego Postiz?**
- 💰 **Całkowicie darmowy** (open-source)
- 🏠 **Self-hosted** - pełna kontrola nad danymi
- 🔒 **Prywatność** - żadne dane nie trafiają do firm trzecich
- 🌍 **16 platform** social media w jednym miejscu
- 🤖 **AI integration** - automatyczne generowanie treści
- 📱 **Responsive** - działa na telefonie, tablecie, komputerze

## 2️⃣ 📱 Jakie social media obsługuje?

**16 najpopularniejszych platform:**

| Platforma | Co możesz robić |
|-----------|-----------------|
| 🐦 **X (Twitter)** | Posty, wątki, obrazy, GIF, ankiety |
| 💼 **LinkedIn** | Posty personalne z obrazami |
| 🏢 **LinkedIn Page** | Posty firmowe, marketing B2B |
| 📘 **Facebook** | Posty na profile i strony |
| 📸 **Instagram** | Posty z obrazami, opisy |
| 🧵 **Threads** | Posty tekstowe i wizualne |
| 📺 **YouTube** | Publikacja wideo, opisy |
| 🎵 **TikTok** | Upload filmów |
| 📌 **Pinterest** | Tworzenie pinów, tablice |
| 🟠 **Reddit** | Posty w subredditach |
| 🎨 **Dribbble** | Portfolio, projekty graficzne |
| 🎮 **Discord** | Wiadomości na serwery |
| 💬 **Slack** | Komunikacja zespołowa |
| 🐘 **Mastodon** | Federowane social media |
| 💙 **Bluesky** | Nowa platforma społecznościowa |
| ✈️ **Telegram** | Kanały i grupy |

## 3️⃣ 💾 Co potrzebujesz aby uruchomić?

### **🐳 Wymagane oprogramowanie:**
- **Docker** (wersja 20.10+) - [Pobierz tutaj](https://www.docker.com/products/docker-desktop/)
- **Git** (do pobierania plików) - [Pobierz tutaj](https://git-scm.com/downloads)

### **⚙️ Minimalne wymagania sprzętowe:**
- 💾 **RAM:** 2GB
- 💿 **Dysk:** 5GB wolnego miejsca
- 🖥️ **CPU:** 1 rdzeń
- 🌐 **Internet:** Stabilne połączenie

### **🔧 Systemy operacyjne:**
- 🪟 **Windows** (10/11)
- 🍎 **macOS** (Big Sur+)
- 🐧 **Linux** (Ubuntu, Debian, CentOS)

### **📋 Opcjonalne do przygotowania:**
- 🌐 **Domena** (lub użyj localhost)
- 🔑 **API keys** social media platform (możesz dodać później)
- 🤖 **OpenAI API key** (dla AI - opcjonalne)
- ☁️ **Cloudflare R2** (storage w chmurze - opcjonalne)
- 📧 **Resend API** (email notifications - opcjonalne)

## 4️⃣ 🚀 Jak uruchomić?

### **Krok 1: Zainstaluj Docker**

<details>
<summary>🪟 <strong>Windows</strong></summary>

**Metoda 1: Docker Desktop (zalecane)**
1. 📥 Pobierz [Docker Desktop dla Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
2. 🔧 Uruchom installer i postępuj zgodnie z instrukcjami
3. ✅ Upewnij się że WSL2 integration jest włączona
4. 🔄 Restart komputera jeśli będzie wymagany
5. 📥 Pobierz [Git dla Windows](https://git-scm.com/download/win) jeśli nie masz

**Metoda 2: WSL2 (dla zaawansowanych)**
```powershell
# 1. Zainstaluj WSL2
wsl --install

# 2. Restart komputera

# 3. W WSL2 Terminal:
wsl
sudo apt update
sudo apt install docker.io docker-compose git -y
sudo usermod -aG docker $USER
```
</details>

<details>
<summary>🍎 <strong>macOS</strong></summary>

**Metoda 1: Docker Desktop (zalecane)**
1. 📥 Pobierz [Docker Desktop dla Mac](https://desktop.docker.com/mac/main/amd64/Docker.dmg)
2. 🔧 Przeciągnij Docker.app do Applications
3. 🚀 Uruchom Docker Desktop z Applications
4. ⏳ Poczekaj aż ikona Docker w menu bar będzie aktywna
5. 📥 Pobierz [Git dla Mac](https://git-scm.com/download/mac) jeśli nie masz

**Metoda 2: Homebrew**
```bash
# Zainstaluj Homebrew (jeśli nie masz)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Zainstaluj Docker Desktop + Git
brew install --cask docker
brew install git
```
</details>

<details>
<summary>🐧 <strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
# Zainstaluj Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Zainstaluj Git
sudo apt install git -y

# Restart sesji (lub wyloguj/zaloguj)
newgrp docker
```
</details>

### **Krok 2: Pobierz repozytorium**

```bash
https://github.com/uxugroup/uxu-postiz-docker-compose.git
wejdz za pomoca terminala do katalogu repozytorium
```

### **Krok 3: Uruchom konfigurator**

```bash
bash env.sh
```

**🎨 Zobaczysz piękny interfejs który to dla Ciebie przygotowałem:**
```
 *   *  **  **  *   *
| | | | \ \/ / | | | |
| | | |  \  /  | | | |
| |_| |  /  \  | |_| |
 \___/  /_/\_\  \___/

🚀 Interaktywny Konfigurator Postiz
====================================

📋 INSTRUKCJA:
  ↵ ENTER = Akceptuj wartość i przejdź dalej
  ○ Puste pole = Użyj wartości domyślnej
  ◐ Opcjonalne = Można pominąć

📊 Statystyki: Łącznie pytań: 48 | Social Media: 16 platform

❓ Domena/URL aplikacji np. uxu.pl [localhost]: 
```

### **Krok 4: Odpowiedz na pytania**

Konfigurator zapyta o:

**📱 Podstawowe ustawienia:**
- Domena (zostaw `localhost` dla testów)
- Porty (domyślne: 6000 dla frontend, 3000 dla backend)
- HTTPS (zostaw `N` dla localhost)

**📱 Social Media APIs:**
- Możesz **pominąć wszystkie** (naciśnij ENTER)
- API keys można dodać później przez interfejs web

**🤖 Opcjonalne funkcje:**
- OpenAI API (zostaw puste jeśli nie masz)
- Email notifications (zostaw puste)
- Cloud storage (zostaw `local`)

### **Krok 5: Uruchom aplikację**

```bash
# Podstawowe uruchomienie
docker-compose up -d

# Sprawdź czy działa
docker-compose ps
```

### **Krok 6: Otwórz Postiz**

🌐 **Adres:** `http://localhost:4200`

👤 **Pierwszy raz:**
1. Utworzysz konto administratora
2. Ustawisz nazwę organizacji
3. Dodasz pierwsze konta social media

🎉 **Gotowe!** Postiz jest uruchomiony!

---

### 🔧 **Przydatne komendy:**

```bash
# Zatrzymaj aplikację
docker-compose down

# Uruchom ponownie
docker-compose up -d

# Zobacz logi
docker-compose logs -f

# Aktualizuj do najnowszej wersji
docker-compose pull
docker-compose up -d
```

### 📚 **Więcej informacji:**

- 📖 **Dokumentacja:** [docs.postiz.com](https://docs.postiz.com)
- 🐛 **Problemy:** [GitHub Issues](https://github.com/gitroomhq/postiz-app/issues)
- 💬 **Społeczność:** [Discord](https://discord.gg/postiz)

---

<div align="center">

**Made with ❤️ by the Open Source Community**

[⭐ Star us on GitHub](https://github.com/gitroomhq/postiz-app) | [📖 Docs](https://docs.postiz.com) | [💬 Discord](https://discord.gg/postiz)

</div>