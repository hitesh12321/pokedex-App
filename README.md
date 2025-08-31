# pokedex

### 1. The Grand Opening

**What you see:** The app launches, displaying a "POKEDEX" title in the app bar and a loading spinner in the center of the screen.

**What's happening in the code:**
* The app starts in `main.dart`, which immediately creates and provides a `PokemonBloc` to the entire application using `BlocProvider`.
* It instantly adds a `PokemonPageRequest` event, telling the BLoC to start fetching the first list of Pokémon.
* The `PokemonBloc` receives this request and emits a `PokemonLoadInProgress` state.
* The `PokedexView` UI is listening with a `BlocBuilder`. When it sees the `PokemonLoadInProgress` state, it knows to show the `CircularProgressIndicator`.

### 2. The Pokedex Fills Up

**What you see:** After a moment, the loading spinner vanishes and is replaced by a grid of Pokémon, each showing its image and name.

**What's happening in the code:**
* The `PokemonBloc`, while in the loading state, calls the `getPokemonHomePage` method from your `PokemonReposetory`.
* The repository makes an HTTP request to the PokeAPI, gets the list, and parses the JSON into a `PokemonPageResponnse` object, which contains a list of all the Pokémon names and IDs.
* The `PokemonBloc` receives this data and emits a `PokemonLoadSuccess` state, packed with the list of Pokémon.
* The `BlocBuilder` in `PokedexView` sees this success state and builds a `GridView`, creating a `Card` for each Pokémon in the list it received.

### 3. You Choose a Pokémon

**What you see:** You tap on a Pokémon in the grid. The screen animates as a new page slides in, showing a loading spinner again.

**What's happening in the code:**
* The `onPressed` function for the Pokémon you tapped is triggered inside the `GridView`.
* This is the clever part: a new, temporary `NavCubit` is created just for the Pokémon you selected.
* The app immediately calls the `showPokemonDetails()` method on this new Cubit to start fetching details *before* the next screen is even fully visible.
* Finally, it navigates to the `SelectedPokemonView`, providing the new `NavCubit` to it so it can listen for the details.

### 4. The Big Reveal: Pokémon Details

**What you see:** The loading spinner on the new screen is replaced by a detailed view of the Pokémon, showing its image, name, description, type, weight, and height.

**What's happening in the code:**
* The `showPokemonDetails()` method that was called in the last step first emitted a `LoadingSelectedPokemon` state, which is why you saw the spinner on the details screen.
* While loading, the `NavCubit` calls the `PokemonReposetory` twice: once to get the Pokémon's main info (height, weight, types) and a second time to get its species info (description, growth rate).
* Once both API calls are complete, the `NavCubit` emits a `SelectedPokemonLoadDone` state, which contains all the detailed information it just gathered.
* The `BlocBuilder` in `SelectedPokemonView` receives this final state and builds the UI, populating all the `Text` widgets and the `Image` with the Pokémon's specific data.

### 5. Returning to the Grid

**What you see:** You tap the back arrow in the app bar, and you smoothly navigate back to the main Pokémon grid.

**What's happening in the code:**
* Tapping the back arrow calls the `popToPokedex()` method on the `NavCubit`.
* The `NavCubit` emits one last state: `BackToPokedex`.
* `SelectedPokemonView` isn't just using a `BlocBuilder`; it also has a `BlocListener`. This listener specifically waits for the `BackToPokedex` state. When it hears it, it runs `Navigator.pop(context)`, closing the details screen and revealing the `PokedexView` again.
