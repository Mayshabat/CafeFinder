# ☕ CafeFinder

CafeFinder is an iOS application for managing and discovering favorite cafes.

The application allows users to add cafes, rate them, save notes and addresses, search their cafe collection, view detailed information, and see the cafe's location on a map.

## ✨ Features

- View a list of favorite cafes
- Add a new cafe
- Edit existing cafe information
- Delete cafes
- Search cafes by name or city
- Rate cafes from 1 to 5 stars
- Add personal notes
- Save the cafe's city and full address
- Display cafe location using MapKit
- Open the cafe location in Apple Maps
- Track cafe detail views using Firebase Realtime Database
- Real-time cafe updates
- Empty state when no cafes are found
- Custom styled cafe cards
- Input validation

## 🔥 Firebase

CafeFinder uses Firebase for cloud data management.

### Cloud Firestore
Used for storing cafe information:

- Name
- City
- Address
- Rating
- Notes
- Creation date

### Firebase Realtime Database
Used for tracking the number of times a cafe's details screen has been viewed.

## 🗺️ MapKit

CafeFinder integrates Apple's MapKit and CoreLocation frameworks.

The saved address and city are converted into geographic coordinates using geocoding.

The cafe location is then displayed on an interactive map with a map annotation.

Users can also open the cafe location directly in Apple Maps.

## 🔍 Search

The cafe list includes a search bar that allows users to search cafes by name or city.

When no matching cafes are found, the application displays an empty-state message.

## ⭐ Rating

Each cafe can be rated from 1 to 5 stars.

The rating can be selected when adding or editing a cafe and is displayed both in the cafe list and the details screen.

## 🛠 Technologies

- Swift
- UIKit
- Storyboard
- Auto Layout
- Firebase
- Cloud Firestore
- Firebase Realtime Database
- MapKit
- CoreLocation
- Git & GitHub
- Xcode

## 📱 Screens

### Favorite Cafes
Displays all saved cafes with their name, city and star rating.

### Add / Edit Cafe
Allows the user to enter:

- Cafe name
- City
- Full address
- Rating
- Notes

The same screen is reused for editing an existing cafe.

### Cafe Details
Displays:

- Cafe name
- City
- Address
- Rating
- Notes
- View counter
- Map location

The user can also edit or delete the cafe.

## 🗂 Project Structure

The project separates the application into models, services and view controllers.

- `Cafe.swift` – Cafe data model
- `CafeListViewController.swift` – Displays and searches cafes
- `AddCafeViewController.swift` – Adds and edits cafes
- `CafeDetailsViewController.swift` – Displays cafe details and map
- `CafeTableViewCell.swift` – Custom cafe list cell
- `CafeFirestoreService.swift` – Handles Firestore operations
- `CafeRealtimeService.swift` – Handles view counter
- `CafeAppTheme.swift` – Central application styling
- `AppDelegate.swift` – Firebase configuration

## ✅ Validation

CafeFinder validates required information before saving a cafe.

The user must provide:

- Cafe name
- City
- Address

If required information is missing, an alert is displayed.

## 🧪 Testing

The application was tested for:

- Adding cafes
- Editing cafes
- Deleting cafes
- Firestore synchronization
- Searching cafes
- Rating display
- Address geocoding
- Map annotations
- View counter updates
- Input validation

## 👩‍💻 Author

May Shabat
