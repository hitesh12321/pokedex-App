import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/pokedex_view.dart';

// 1. MODEL CLASS
class OnboardData {
  final String imagePath;
  final String text1;
  final String text2;

  OnboardData({
    required this.imagePath,
    required this.text1,
    required this.text2,
  });
}

// 2. DATA LIST (Using generic Pokemon URLs)
List<OnboardData> onboardData = [
  OnboardData(
    imagePath:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png", // Charizard
    text1: "Catch 'Em All",
    text2: "Explore the world of Pokemon and find your favorite companions.",
  ),
  OnboardData(
    imagePath:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png", // Pikachu
    text1: "Detailed Stats",
    text2: "Get in-depth information about abilities, types, and stats.",
  ),
  OnboardData(
    imagePath:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png", // Mewtwo
    text1: "Become a Master",
    text2: "Build your ultimate team and dominate the league.",
  ),
];

// 3. MAIN WIDGET
class PokedexOnboardPage extends StatefulWidget {
  const PokedexOnboardPage({super.key});

  @override
  State<PokedexOnboardPage> createState() => _PokedexOnboardPageState();
}

class _PokedexOnboardPageState extends State<PokedexOnboardPage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pokedex Red Color Palette
    const Color kPokedexRed = Color(0xFFEA473B);
    const Color kDarkBg = Color(0xFF2B292C);

    return Scaffold(
      backgroundColor: kDarkBg,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // BACKGROUND DECORATION (Pokeball faded circle)
          Positioned(
            top: -100,
            right: -100,
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/5/53/Pok%C3%A9_Ball_icon.svg",
                width: 400,
                height: 400,
                color: Colors.white,
              ),
            ),
          ),

          // PAGE VIEW
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: onboardData.length,
            itemBuilder: (context, index) => Stack(
              alignment: Alignment.center,
              children: [
                // IMAGE SECTION
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            kPokedexRed.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Image.network(
                          onboardData[index].imagePath,
                          height: 300,
                          width: 300,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const CircularProgressIndicator(
                              color: kPokedexRed,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // TEXT SECTION
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  left: 20,
                  right: 20,
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          onboardData[index].text1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bebasNeue(
                            // Impactful font
                            fontSize: 48,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Gap(15),
                        Text(
                          onboardData[index].text2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[400],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // INDICATORS (Dots)
          Positioned(
            left: 30,
            bottom: 50,
            child: Row(
              children: List.generate(
                onboardData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 8),
                  height: 6,
                  width: currentIndex == index ? 30 : 8, // Active extends width
                  decoration: BoxDecoration(
                    color: currentIndex == index ? kPokedexRed : Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // BUTTON
          Positioned(
            right: 30,
            bottom: 30,
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: MaterialButton(
                onPressed: () {
                  if (currentIndex == onboardData.length - 1) {
                    // Navigate to Home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PokedexView()),
                    );
                    print("Navigate to Home");
                  } else {
                    // Next Page
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  }
                },
                height: 60,
                minWidth: 60,
                color: kPokedexRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                elevation: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentIndex == onboardData.length - 1 ? "Start" : "Next",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
