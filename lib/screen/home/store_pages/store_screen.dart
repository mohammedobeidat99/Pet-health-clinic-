import 'package:flutter/material.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/screen/home/store_pages/accessories_screen.dart';
import 'package:pethhealth/screen/home/store_pages/food_screen.dart';
import 'package:pethhealth/screen/home/store_pages/games_screen.dart';
import 'package:pethhealth/widget/custom_container.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _searchController = TextEditingController();
  List<Widget> pages = [
   const FoodScreen(),
    const GamesScreen(),
   const AccessoriesScreen(),
    Container(
     // color: Colors.white, // Placeholder color, replace with your content
      child: const Center(child: Text('Empty')),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text( getLang(context, "store") ,style: TextStyle(fontSize: 18.0 ,fontWeight: FontWeight.w600),),
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: getLang(context, "search"),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildContainer(getLang(context, "food"), 'assets/images/petfood.png', 0 ,selectedIndex,_pageController,),
                buildContainer(getLang(context, "games"), 'assets/images/ball.png', 1,selectedIndex,_pageController,),
                buildContainer(getLang(context, "accessories"), 'assets/images/collar.png', 2,selectedIndex,_pageController,),
                buildContainer(getLang(context, "other"), 'assets/images/petshop.png', 3,selectedIndex,_pageController,),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return pages[index];
              },
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
  