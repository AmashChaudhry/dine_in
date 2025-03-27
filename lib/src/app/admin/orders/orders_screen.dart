import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final orderCollection = FirebaseFirestore.instance.collection('Orders');

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
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder(
              stream: orderCollection.orderBy('Time', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final orderSnapshot = snapshot.data!.docs[index];
                      return Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderSnapshot['Table'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(orderSnapshot['Time'].toDate()).toLowerCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orderSnapshot['Items'].length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${orderSnapshot['Items'][index]['Item Name']}, ${orderSnapshot['Items'][index]['Size']} ${orderSnapshot['Items'][index]['Quantity']}x',
                                    ),
                                    Text(
                                      'PKR ${orderSnapshot['Items'][index]['Total Price']}',
                                      style: TextStyle(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                ),
                                Text(
                                  'PKR ${orderSnapshot['Total Bill'].toString()}',
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
