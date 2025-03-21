import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/constants/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/core/setting/setting.dart';
import 'package:dine_in/src/app/core/cart/cart_screen.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';
import 'package:dine_in/src/app/core/item_detail/item_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = categories.first;

  final CartController controller = Get.find<CartController>();

  final itemCollection = FirebaseFirestore.instance.collection('Items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                InkWell(
                  onTap: () => Get.to(() => const Setting()),
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
                Obx(
                  () => Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () => Get.to(() => const CartScreen()),
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                          ),
                          if (controller.cartItems.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.cartItems.length.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 40,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 7.5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search menu item or specials...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                mainAxisExtent: 40,
              ),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      category = categories[index];
                    });
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: categories[index] == category ? selectedOptionColor : secondaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder(
              stream: itemCollection.where('Category', isEqualTo: category).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final itemSnapshot = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () => Get.to(() => ItemDetail(
                              id: itemSnapshot.id,
                              itemName: itemSnapshot['Item Name'],
                              price: itemSnapshot['Price'],
                              category: itemSnapshot['Category'],
                            )),
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.coffee_rounded,
                                size: 80,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                itemSnapshot['Item Name'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
