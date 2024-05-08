import 'package:flutter/material.dart';

class CircularItem extends StatelessWidget {
  final IconData icon;
  final String text;
   final VoidCallback onTap;

  const CircularItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //return Column(
          return GestureDetector(
      onTap: onTap,
      child: Column(

      children: [
        Container(
          width: 75,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color.fromARGB(255, 179, 177, 177)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: const Color.fromARGB(255, 60, 94, 60),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                 style: const TextStyle(
                        //color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 6,
                      ),
                
                
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}


           
           /*
class SearchLocationContainer extends StatelessWidget {
  final TextEditingController searchController;

  const SearchLocationContainer({required this.searchController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 50,
        width: double.maxFinite,
        child: TextFormField(
          keyboardType: TextInputType.text,
          autocorrect: true,
          enableSuggestions: true,
          validator: (val) {},
          onFieldSubmitted: (term) {
            term = term.trim();
            if (term.isEmpty) {
              print("Nothing searched");
              return;
            } else {
              handleSearch(term);
              print("$term was searched");
              _saveSearchQuery(term); // Save the search query in Hive
            }
          },
          onSaved: (val) => print(val),
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: EdgeInsets.only(top: 15, left: 15),
            prefixIcon: Icon(
              Icons.search,
              size: 25,
              color: Colors.blueGrey,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                handleClearSearch();
              },
            ),
            hintText: "Search Location",
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}
    */
    class SearchLocationContainer extends StatelessWidget {
  final TextEditingController searchController;

  const SearchLocationContainer({required this.searchController, Key? key})
      : super(key: key);

  void handleSearch(String term) {
    term = term.trim();
    if (term.isEmpty) {
      print("Nothing searched");
      return;
    } else {
      // Handle the search logic here, such as calling a function or updating state
      print("$term was searched");
      // Example: _saveSearchQuery(term); // Save the search query in Hive
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      // Your widget's implementation here
    );
  }
}
   
