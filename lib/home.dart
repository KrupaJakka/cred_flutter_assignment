import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List cards = [];
  bool loading = true;
  int textIndex = 0;
  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    // <=2 cards API
    loadData("https://api.mocklets.com/p26/mock1");
    //// >2 cards API
    // loadData("https://api.mocklets.com/p26/mock2");

    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        textIndex = (textIndex + 1) % 2;
      });
    });
  }

  Future loadData(String url) async {
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    cards = data["template_properties"]["child_list"];

    setState(() {
      loading = false;
    });
  }

  // ===== CARD ROTATION FUNCTIONS =====

  void flipUp() {
    if (cards.isEmpty) return;

    setState(() {
      final first = cards.removeAt(0);
      cards.add(first);
    });
  }

  void flipDown() {
    if (cards.isEmpty) return;

    setState(() {
      final last = cards.removeLast();
      cards.insert(0, last);
    });
  }

  // ================= <=2 CARDS UI =================

  Widget buildTwoCards() {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return buildDynamicCard(cards[index], index);
      },
    );
  }

  Widget buildDynamicCard(dynamic card, int index) {
    final body = card["template_properties"]["body"];
    final logo = body["logo"]["url"];
    final amount = body["payment_amount"] ?? "0";

    final dueTexts = ["Due on 20 Oct", "Due on 21 Oct"];
    final autoPayTexts = ["Auto pay in 8 days", "Auto pay in 9 days"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(logo), radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body["title"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        body["sub_title"] ?? "",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.autorenew, color: Colors.green),
                label: Text("Pay $amount"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(140, 40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                textIndex == 0
                    ? dueTexts[index % dueTexts.length]
                    : autoPayTexts[index % autoPayTexts.length],
                style: TextStyle(
                  color: textIndex == 0 ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= >2 CARDS UI =================

  Widget buildStackCards() {
    List frontCards = cards.take(2).toList();
    List backCards = cards.length > 2 ? cards.sublist(2) : [];

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            flipUp();
          } else {
            flipDown();
          }
        }
      },
      child: SizedBox(
        height: 260,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // BACK STACK INDICATOR
            if (backCards.isNotEmpty)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                top: 240,
                left: 12,
                right: 12,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

            // SECOND CARD
            if (frontCards.length > 1)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                top: 120,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: buildCardWithButton(frontCards[1], 1),
                ),
              ),

            // FIRST CARD
            if (frontCards.isNotEmpty)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: buildCardWithButton(frontCards[0], 0),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCardWithButton(dynamic card, int index) {
    final body = card["template_properties"]["body"];
    final logo = body["logo"]["url"];
    final amount = body["payment_amount"] ?? "0";

    return GestureDetector(
      onTap: () {
        setState(() {
          isFlipped = !isFlipped;
        });
      },
      child: SizedBox(
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (index == 1) ...[
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: isFlipped ? -8 : 8,
                child: buildBackgroundCard(scale: 0.95),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: isFlipped ? -4 : 4,
                child: buildBackgroundCard(scale: 0.97),
              ),
            ],
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.translationValues(0, isFlipped ? -6 : 0, 0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(logo),
                            radius: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  body["title"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  body["sub_title"] ?? "",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(120, 40),
                          ),
                          child: Text(
                            "Pay $amount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "OVER DUE",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackgroundCard({double scale = 1}) {
    return Transform.scale(
      scale: scale,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Bills (${cards.length})",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "View All >",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: cards.length <= 2
                          ? buildTwoCards()
                          : buildStackCards(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
