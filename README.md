# 📱 CRED Flutter Assignment

**Candidate:** Krupa Ratnam Jakka  

This Flutter application displays upcoming bills fetched from a mock API.  
The UI dynamically adapts based on the number of items returned from the API.

---

## 🚀 Project Overview
- **2 items or fewer** → Bills are displayed in a **vertical list layout**.  
- **More than 2 items** → Bills are displayed in a **stacked carousel layout**:
  - First card appears at the front  
  - Second card slightly behind  
  - Remaining cards stacked in the background  
- Users can **swipe up or down** to rotate cards within the carousel.

---

## 🛠 Tech Stack
- Flutter  
- Dart  
- HTTP Package  
- Material UI Components  

---

## 📂 Project Architecture
lib/
│
├── main.dart
│   App entry point
│
├── home.dart
│   Main screen UI
│   Handles state, swipe gestures, and layout switching
│
├── api_service.dart
│   Handles API requests and bill data fetching
│
└── card_widget.dart
    Reusable UI component for bill cards

This modular structure helps improve code readability, maintainability, and reusability.


This modular structure improves readability, maintainability, and reusability.

---

## 🌐 API Integration
Mock APIs used for testing different UI scenarios:

- **2 Cards API:** [https://api.mocklets.com/p26/mock1]
- **Multiple Cards API:** [https://api.mocklets.com/p26/mock2]

Data is fetched using the HTTP package and rendered dynamically based on the response size.

---

## 🔄 Ways to Handle API Switching
1. **Change API URL in Code**
   ```dart
   loadData("https://api.mocklets.com/p26/mock1");
   loadData("https://api.mocklets.com/p26/mock2");
   - Comment / Uncomment APIs
loadData(mock1);
// loadData(mock2);
2. **UI Buttons for Testing**
- Button 1 → Fetch 2 card API
- Button 2 → Fetch multiple card API
3. **initstate logic **
@override
void initState() {
  super.initState();
  loadData(apiUrl);
}

🎞 Carousel Swipe Animation
Swipe gestures implemented using GestureDetector:
- Swipe Up → Move top card to the back
- Swipe Down → Bring previous card to the front
Animation components used:
- AnimatedContainer
- AnimatedPositioned
- Transform.scale
These ensure smooth transitions without frame drops.

📊 UI States Handled
- Loading State → While fetching data
- List Layout → When API returns ≤ 2 cards
- Carousel Layout → When API returns > 2 cards

✅ Assumptions
- API response structure remains consistent
- First two cards are always visible in carousel
- Remaining cards stay stacked behind
- Swipe gestures rotate cards but do not remove them

🧪 Testing
Manual testing performed for:
- API returning 2 cards
- API returning multiple cards
- Swipe up interaction
- Swipe down interaction
- Loading state while fetching data
- Layout switching between list and carousel


🏗 Build Instructions
To generate the APK:
flutter build apk --release


APK will be generated at:
build/app/outputs/flutter-apk/app-release.apk



📦 Deliverables
- Complete Flutter Source Code
- Generated APK
- Video Walkthrough Demonstration


