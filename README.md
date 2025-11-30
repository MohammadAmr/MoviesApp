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

