# ☕ CafeFinder

CafeFinder is an iOS application for managing and discovering favorite cafes.

The application allows users to add cafes, edit and delete them, rate their favorite places, save notes and addresses, search their cafe collection, view detailed information, and see each cafe's location on a map.

The application also supports both Light Mode and Dark Mode.

---

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
- Real-time cafe updates using Cloud Firestore
- Display an empty state when no cafes are found
- Custom styled cafe cards
- Input validation
- Support for Light Mode and Dark Mode
- Display cafe images

---

## 🔥 Firebase

CafeFinder uses Firebase for cloud data management.

### Cloud Firestore

Cloud Firestore is used for storing and synchronizing cafe information.

Each cafe contains:

- Name
- City
- Address
- Rating
- Notes
- Creation date
- Image name

Firestore also provides real-time updates, allowing the cafe list to automatically update when the stored data changes.

### Firebase Realtime Database

Firebase Realtime Database is used for tracking the number of times each cafe's details screen has been viewed.

Every time a user opens the details screen, the cafe's view counter is updated.

---

## 🗺️ MapKit

CafeFinder integrates Apple's MapKit and CoreLocation frameworks.

The saved cafe address and city are converted into geographic coordinates using geocoding.

The cafe location is then displayed on an interactive map with a map annotation.

Users can also open the cafe location directly in Apple Maps.

---

## 🔍 Search

The Favorite Cafes screen includes a search bar.

Users can search cafes by:

- Cafe name
- City

The cafe list updates according to the search text.

When no matching cafes are found, the application displays an empty-state message.

---

## ⭐ Rating

Each cafe can be rated from 1 to 5 stars.

The rating is selected when adding or editing a cafe.

The selected rating is displayed in:

- Favorite Cafes list
- Cafe Details screen

---

## 🌙 Light & Dark Mode

CafeFinder supports both Light Mode and Dark Mode.

The application's colors automatically adapt to the current appearance mode.

A central `CafeAppTheme` is used to maintain consistent styling throughout the application.

---

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

---

## 📱 Screens

CafeFinder contains three main screens.

### 1. Favorite Cafes

Displays all saved cafes.

Each cafe displays:

- Cafe name
- City
- Star rating

The screen also includes a search bar for filtering cafes by name or city.

Selecting a cafe opens its details screen.

---

### 2. Add / Edit Cafe

Allows the user to add a new cafe or edit an existing cafe.

The user can enter:

- Cafe name
- City
- Full address
- Rating
- Notes

The same screen is reused for both adding and editing cafes.

---

### 3. Cafe Details

Displays detailed information about the selected cafe.

The screen displays:

- Cafe name
- City
- Address
- Rating
- Notes
- View counter
- Map location

From this screen, the user can also:

- Edit the cafe
- Delete the cafe
- Open the cafe location in Apple Maps

---

## 🧭 Navigation

The application uses a `UINavigationController` to manage navigation between screens.

It allows users to navigate between:

Favorite Cafes → Add / Edit Cafe → Cafe Details

The Navigation Controller also provides the navigation bar and back navigation between screens.

---

## 🗂 Project Structure

The project separates the application into models, services, view controllers, and UI components.

### `Cafe.swift`

Represents the Cafe data model.

Stores information such as:

- ID
- Name
- City
- Address
- Rating
- Notes
- Creation date
- Image name

---

### `CafeListViewController.swift`

Responsible for:

- Displaying the cafe list
- Receiving real-time Firestore updates
- Searching cafes
- Filtering cafes by name or city
- Displaying the empty state
- Navigating to cafe details

---

### `AddCafeViewController.swift`

Responsible for:

- Adding new cafes
- Editing existing cafes
- Reading user input
- Selecting cafe rating
- Validating required fields
- Saving changes to Firestore

The same View Controller is used for both Add and Edit operations.

---

### `CafeDetailsViewController.swift`

Responsible for:

- Displaying cafe information
- Displaying the cafe location on a map
- Geocoding the cafe address
- Opening the location in Apple Maps
- Displaying the view counter
- Editing cafes
- Deleting cafes

---

### `CafeTableViewCell.swift`

Custom `UITableViewCell` used for displaying cafes in the Favorite Cafes list.

Displays:

- Cafe name
- City
- Star rating

It also applies the custom card design used by the application.

---

### `CafeFirestoreService.swift`

Handles communication with Cloud Firestore.

Responsible for:

- Reading cafes
- Listening for real-time changes
- Adding cafes
- Updating cafes
- Deleting cafes

---

### `CafeRealtimeService.swift`

Handles communication with Firebase Realtime Database.

Used for managing the cafe details view counter.

---

### `CafeAppTheme.swift`

Contains the application's central styling configuration.

Responsible for:

- Colors
- Text field styling
- Text view styling
- Button styling
- Card styling
- Light Mode
- Dark Mode

---

### `AppDelegate.swift`

Initializes Firebase when the application starts.

---

## ✅ Validation

CafeFinder validates required information before saving a cafe.

The user must provide:

- Cafe name
- City
- Address

If required information is missing, an alert is displayed and the cafe is not saved until the required information is entered.

---

## 🔄 CRUD Operations

CafeFinder supports the main CRUD operations:

**Create** – Add a new cafe

**Read** – Display cafes from Firestore

**Update** – Edit an existing cafe

**Delete** – Delete a cafe

---

## 🧪 Testing

The application was tested for:

- Adding cafes
- Editing cafes
- Deleting cafes
- Firestore synchronization
- Real-time updates
- Searching cafes
- Rating display
- Address geocoding
- Map annotations
- Opening locations in Apple Maps
- View counter updates
- Input validation
- Light Mode
- Dark Mode

---

## 👩‍💻 Author

**May Shabat**

iOS Development Project – CafeFinder
