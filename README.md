<div align="center">

# StockPilot
<strong>Inventory Management Demo App (Flutter)</strong><br/>
Modern, production-style Flutter application showcasing clean UI, RESTful CRUD integration, form validation, resilient error handling, and testability. Designed to demonstrate practical mobile engineering skills to recruiters and collaborators.

</div>

## ✨ Highlights

- Clean architecture-lite separation (models / services / widgets / feature screens)
- Strongly typed data model with JSON (de)serialization helpers
- REST API client abstraction with consistent error surfacing
- Material 3 theming & responsive list with pull-to-refresh
- Add / Edit / View / Delete inventory items
- Form validation (numeric + required fields)
- Graceful loading + retry + empty states
- Minimal widget test scaffold (ready to extend)

## 🧱 Tech Stack

| Layer | Purpose |
|-------|---------|
| Flutter (3.x) | Cross‑platform UI | 
| http package | RESTful requests | 
| Material 3 | Modern design system |

## 🗂 Project Structure

```
lib/
├─ main.dart               # Entry point & navigation shell
├─ add_item_widget.dart    # Create item form screen
├─ edit_item_widget.dart   # Update existing item
├─ item_detail_widget.dart # Detailed view & delete action
├─ models/
│   └─ item.dart           # Item entity & JSON helpers
├─ services/
│   └─ api_service.dart    # REST CRUD abstraction
└─ widgets/
        └─ item_list.dart      # Reusable list widget
```

## 🔌 API Contract (Expected)

Base URL (configure in `api_service.dart`):
```
GET    /api/items          -> List<Item>
GET    /api/items/:id      -> Item
POST   /api/items          -> Item (created)
PUT    /api/items/:id      -> Item (updated)
DELETE /api/items/:id      -> 204/200
```

Example Item JSON:
```json
{
    "_id": "abc123",
    "name": "USB-C Hub",
    "description": "8‑port aluminum USB-C hub",
    "price": 49.99,
    "category": "Accessories",
    "quantity": 120,
    "imageUrl": "https://cdn.example.com/items/hub.jpg",
    "createdAt": "2025-01-01T10:00:00Z",
    "updatedAt": "2025-01-05T16:42:11Z"
}
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0.0+
- A running REST backend (or mock server). Try json-server or Express.

### Run Locally
1. Clone repo
2. Adjust `baseUrl` in `lib/services/api_service.dart` to your backend
3. Install deps & run:
```bash
flutter pub get
flutter run
```

### Optional: Quick Mock (json-server)
```bash
npm i -g json-server
json-server --watch db.json --port 3000
```

## 🧪 Testing
```
flutter test
```
Extensible: add golden tests, API mock tests (via `http` overrides), and widget interaction flows.

## 🧠 Extension Ideas
- Authentication (JWT / OAuth2)
- Offline cache (sqflite / hive)
- State management (Riverpod / Bloc)
- Pagination & search
- Image picker + upload
- Theming toggle (dark / light)

## 👔 Recruiter Notes
This project emphasizes: code readability, modularity, error handling, and production-ready patterns without over‑engineering. It can be quickly evolved into a portfolio-level full feature set.

## 📄 License
MIT – feel free to fork and extend.

---
Questions or want to collaborate? Open an issue or connect.
