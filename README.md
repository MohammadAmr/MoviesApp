# 🎬 MoviesApp (iOS)

MoviesApp is an iOS application that displays the **best movies released in 2024** using data from **The Movie Database (TMDB)** API.  
The app supports **infinite scrolling**, **detailed movie information**, and a **favorites system** that persists using **Core Data**.

The project follows a clean architecture using **UIKit + MVVM + Combine + Repository Pattern**, with **async/await** for networking and **Kingfisher** for image loading.

---

## ✨ Key Features

| Feature | Description |
|--------|-------------|
| 🏆 2024 movie list | Displays trending movies from TMDB |
| 🔁 Pagination | Automatic infinite scrolling when reaching bottom |
| ⭐ Favorites | Toggle favorite state for movies |
| 💾 Persistence | Favorite movies are saved locally using Core Data |
| 📑 Movie details | Overview, rating, language, release date & more |
| 🔄 Auto-sync | When favorite state changes in details, the list updates automatically |
| 🚀 Modern networking | `async/await` with URLSession |
| 🔗 API client | Built around TMDB API v3 |
| 🖼 Image handling | Kingfisher + caching |

---

## 🧱 Architecture Overview
UIKit ViewControllers
↓ (Combine binding)
ViewModels (state & business logic only)
↓ (Repository abstraction)
Repository (fetch movies + save favorites)
↓
TMDB Client (remote API) + Core Data (local DB)

## Responsibilities

| Layer | Responsibility |
|-------|----------------|
| ViewController | UI rendering & user interaction |
| ViewModel | Business logic & app state |
| Repository | Data access (remote + local) |
| Core Data | Favorites persistence |
| TMDB Client | REST API requests |

# 🔌 Networking

The app uses **TMDB API v3**.

Image URLs are constructed as:
https://image.tmdb.org/t/p/w500/<posterPath>


Add your API key:
```swift
let client = TMDBClient(apiKey: "<YOUR_API_KEY>")

---

## 📌 6️⃣ `06_Persistence.md`

```md
# 🗃 Persistence (Favorites)

Favorites are stored locally using **Core Data**:

- Each movie has `isFavorite: Bool`
- Data persists across app relaunches
- When the user toggles favorite in the detail screen, the list updates automatically using Combine publishers
