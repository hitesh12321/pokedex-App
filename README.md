
# 🔴 Flutter Pokedex

A modern, feature-rich Pokedex application built with **Flutter** and **Clean Architecture**. This project demonstrates advanced state management using **BLoC/Cubit**, optimized UI rendering, and seamless animations.

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue?logo=dart)
![State Management](https://img.shields.io/badge/State%20Management-BLoC-red)

## 📱 App Demo

> **Watch the App in Action**
> *Note: Upload your screen recording (GIF or MP4) to your repository and link it below.*

<div align="center">
  <img src="[https://via.placeholder.com/300x600?text=Upload+Your+Demo+Here](https://github.com/user-attachments/assets/e4d63009-d058-4c3e-8df7-cd0f19d33cab)" alt="App Demo" width="300" />
</div>
![Screenshot_2025-11-21-03-17-44-61_b6c29ea0c0e65253fd90bb894465f0e2 1](https://github.com/user-attachments/assets/e4d63009-d058-4c3e-8df7-cd0f19d33cab)![Screenshot_2025-11-21-03-17-50-40_b6c29ea0c0e65253fd90bb894465f0e2 1](https://github.com/user-attachments/assets/551c95da-6ffd-459a-b01c-de2a90ba2e95)
![Screenshot_2025-11-21-03-17-44-61_b6c29ea0c0e65253fd90bb894465f0e2 1](https://github.com/user-attachments/assets/e4d63009-d058-4c3e-8df7-cd0f19d33cab)


---

## 🛠️ Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** flutter_bloc (Bloc & Cubit)
* **Architecture:** MVVM / Clean Architecture with Repository Pattern
* **Network:** HTTP (Consuming PokeAPI)
* **UI/UX:** * `animate_do` for entrance animations
    * Hero animations for image transitions
    * Custom Painters & Stack layouts

---

## ⚙️ Under the Hood: Application Flow

Here is a breakdown of the lifecycle of the application, from launch to navigation.

### 1. 🚀 The Grand Opening
**What you see:** The app launches, displaying a "POKEDEX" title in the app bar and a loading spinner in the center of the screen.

**What's happening in the code:**
* The app starts in `main.dart`, which immediately creates and provides a `PokemonBloc` to the entire application using `BlocProvider`.
* It instantly adds a `PokemonPageRequest` event, telling the BLoC to start fetching the first list of Pokémon.
* The `PokemonBloc` receives this request and emits a `PokemonLoadInProgress` state.
* The `PokedexView` UI is listening with a `BlocBuilder`. When it sees the `PokemonLoadInProgress` state, it knows to show the `CircularProgressIndicator`.

### 2. 📥 The Pokedex Fills Up
**What you see:** After a moment, the loading spinner vanishes and is replaced by a grid of Pokémon, each showing its image and name.

**What's happening in the code:**
* The `PokemonBloc`, while in the loading state, calls the `getPokemonHomePage` method from your `PokemonReposetory`.
* The repository makes an HTTP request to the PokeAPI, gets the list, and parses the JSON into a `PokemonPageResponse` object.
* The `PokemonBloc` receives this data and emits a `PokemonLoadSuccess` state, packed with the list of Pokémon.
* The `BlocBuilder` in `PokedexView` sees this success state and builds a `GridView`, creating a `Card` for each Pokémon using optimized image caching.

### 3. 👆 You Choose a Pokémon
**What you see:** You tap on a Pokémon in the grid. The screen animates as a new page slides in, showing a loading spinner again.

**What's happening in the code:**
* The `onTap` function (via `InkWell`) for the Pokémon you tapped is triggered inside the `GridView`.
* **The Clever Part:** A new, temporary `NavCubit` is created just for the Pokémon you selected.
* The app immediately calls `showPokemonDetails()` on this new Cubit to start fetching details *before* the next screen is even fully visible.
* It navigates to the `SelectedPokemonView`, providing the new `NavCubit` to it so it can listen for the details.

### 4. ✨ The Big Reveal: Pokémon Details
**What you see:** The loading spinner on the new screen is replaced by a detailed view of the Pokémon, showing its floating image, name, description, type, weight, and height.

**What's happening in the code:**
* The `showPokemonDetails()` method emitted a `LoadingSelectedPokemon` state, triggering the spinner.
* While loading, the `NavCubit` calls the `PokemonReposetory` twice: 
    1.  To get main info (height, weight, types).
    2.  To get species info (description, growth rate).
* Once both API calls are complete, the `NavCubit` emits a `SelectedPokemonLoadDone` state containing all gathered data.
* The `BlocBuilder` in `SelectedPokemonView` receives this final state and builds the `Stack` layout UI.

### 5. 🔙 Returning to the Grid
**What you see:** You tap the back arrow in the app bar, and you smoothly navigate back to the main Pokémon grid.

**What's happening in the code:**
* Tapping the back arrow calls the `popToPokedex()` method on the `NavCubit`.
* The `NavCubit` emits one last state: `BackToPokedex`.
* `SelectedPokemonView` uses a `BlocListener` specifically waiting for this state. When it hears it, it runs `Navigator.pop(context)`, closing the details screen and revealing the `PokedexView` again.

---

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/pokedex-app.git](https://github.com/yourusername/pokedex-app.git)
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## 🤝 Contribution

Contributions are welcome! Feel free to submit a Pull Request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request
