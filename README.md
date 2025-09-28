# Crypto Portfolio Tracker

A Flutter application to track your cryptocurrency portfolio. Users can add coins, manage quantities, view current market prices, total holding values, and overall portfolio value. The app persists data locally and fetches prices via the CoinGecko API.

---

## 📌 Features

- Splash screen with animation  
- Add, remove, and manage crypto holdings
- Persistent portfolio storage (local)  
- Pull-to-refresh prices  
- Total portfolio value calculation  
- Basic UI polish with Cards and subtle animations  


---

## 🏗 Architectural Choices

- **State Management:** GetX (Reactive and simple for this project)  
- **Data Persistence:** shared_preferences (JSON storage)  
- **API Integration:** CoinGecko REST API  
- **Async Handling:** reactive state updates with GetX  
- **UI:** Flutter widgets  

---

## 🛠 Third-Party Libraries

- `get` – State management and navigation  
- `http` – API requests  
- `shared_preferences` – Local storage  
- `intl` – Currency formatting  
- `google_fonts` For fonts

---

## 🚀 App Setup

1. **Clone the Repository**  

```bash
git clone <your-repo-url>
cd crypto_portfolio_tracker
```

2. **Install Dependencies**  

```bash
flutter pub get
```

3. **Run the App**  

```bash
flutter run
```

> Ensure you have a connected device or simulator running.

---

## 🎨 Recorded Demo

A video demo showcasing the app functionality can be accessed here:  
[Demo Video Link](https://example.com)

---

## 🔗 API Endpoints

- **Get Coin List:** `https://api.coingecko.com/api/v3/coins/list`  
- **Get Current Price:** `https://api.coingecko.com/api/v3/simple/price?ids={COIN_IDS}&vs_currencies=usd`  

---

## 💡 Notes

- Use the Add button to add coins with quantities.  
- Pull-to-refresh updates current coin prices.  
- Portfolio persists across app restarts.  
- Ensure internet connectivity for fetching prices.  

---

## 📁 Project Structure


```
lib/
├─ controllers/   # GetX controllers for state management
├─ models/        # Coin and portfolio models
├─ screens/       # UI screens (Splash, Portfolio, AddAsset)
├─ services/      # API service
├─ widgets/       # Reusable widgets (Cards, Buttons)
├─ extensions/    # Custom extensions (e.g., Size, String)
├─ main.dart      # App entry point
```
---

## 📧 Contact

Vishrut Trapasiya  
Email: vishruttrapasiya321@gmail.com
