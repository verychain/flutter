import 'package:flutter/material.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  bool isBuySelected = true; // true: Buy, false: Sell

  // Sample data for listings (crypto와 paymentMethod 제거)
  final List<Map<String, dynamic>> buyListings = [
    {
      'user': 'John Doe',
      'amount': '0.5',
      'price': '45,000',
      'currency': 'USD',
      'rating': 4.8,
      'trades': 156,
    },
    {
      'user': 'Alice Smith',
      'amount': '2.5',
      'price': '2,800',
      'currency': 'USD',
      'rating': 4.9,
      'trades': 89,
    },
    {
      'user': 'Bob Wilson',
      'amount': '1000',
      'price': '1.00',
      'currency': 'USD',
      'rating': 4.7,
      'trades': 234,
    },
  ];

  final List<Map<String, dynamic>> sellListings = [
    {
      'user': 'Mike Johnson',
      'amount': '0.3',
      'price': '44,800',
      'currency': 'USD',
      'rating': 4.6,
      'trades': 67,
    },
    {
      'user': 'Sarah Davis',
      'amount': '1.8',
      'price': '2,750',
      'currency': 'USD',
      'rating': 4.9,
      'trades': 145,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          Text(
            'P2P Market',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),

          // Buy/Sell Switch
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isBuySelected = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isBuySelected ? Colors.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Buy',
                      style: TextStyle(
                        color: isBuySelected
                            ? Colors.white
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isBuySelected = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: !isBuySelected ? Colors.red : Colors.transparent,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Sell',
                      style: TextStyle(
                        color: !isBuySelected
                            ? Colors.white
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),

          // Listings List
          Expanded(
            child: ListView.builder(
              itemCount: isBuySelected
                  ? buyListings.length
                  : sellListings.length,
              itemBuilder: (context, index) {
                final listing = isBuySelected
                    ? buyListings[index]
                    : sellListings[index];
                return _buildListingCard(listing);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    listing['user'][0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing['user'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.0),
                          SizedBox(width: 4.0),
                          Text(
                            '${listing['rating']} (${listing['trades']} trades)',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Amount and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${listing['amount']} VERY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${listing['price']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Trade Button
            SizedBox(width: double.infinity),
          ],
        ),
      ),
    );
  }
}
