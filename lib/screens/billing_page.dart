/*import 'package:flutter/material.dart';

void main() {
  List<Map<String, dynamic>> bookedItems = [
    {'name': 'Accommodation', 'price': 100},
    {'name': 'Event', 'price': 50},
    {'name': 'Transportation', 'price': 75},
  ];
  runApp(MaterialApp(home: PaymentPage(bookedItems: bookedItems)));
}


class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> bookedItems;

  PaymentPage({required this.bookedItems});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    // Calculate total amount

    // Calculate total amount
    double totalAmount = 0; // Define totalAmount within build method

    for (var item in widget.bookedItems) {
      totalAmount += item['price'] * (item['numPeople'] ?? 1); // Use default value if numPeople is null
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Booked Items:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.bookedItems.map((item) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('- ${item['name']}'),
                    SizedBox(height: 4.0),
                    Text('  Price Per Person: \$${item['price']}'),
                    Text('  Number of People: ${item['numPeople']}'),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Payment Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 16.0),
            const Text(
              'Payment Status:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Payment Pending'), // Display payment status
          ],
        ),
      ),
    );
  }
}
*/



import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: PaymentPage(bookedItems: []))); // Pass an empty list initially
}

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> bookedItems;

  const PaymentPage({super.key, required this.bookedItems});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isPaid = false; // Assume initially not paid

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;

    if (widget.bookedItems.isNotEmpty) {
      for (var item in widget.bookedItems) {
        totalAmount += item['price'] * (item['numPeople'] ?? 1);
      }
    } else {
      // Handle case where no items are booked
      return Scaffold(
        appBar: AppBar(
          title: Text('No Items Booked'),
        ),
        body: Center(
          child: Text('No items have been booked yet.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your existing code for displaying booked items and payment details

            const Text(
              'Payment Status:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(isPaid ? 'Paid' : 'Payment Pending'), // Display 'Paid' if isPaid is true, else 'Payment Pending'
          ],
        ),
      ),
    );
  }
}
