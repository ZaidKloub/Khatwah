import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class CharitiesScreen extends StatefulWidget {
  @override
  _CharitiesScreenState createState() => _CharitiesScreenState();
}

class _CharitiesScreenState extends State<CharitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> items = [
    {
      'title': 'Tkyiet Um Ali',
      'description':
      'Founded in the heart of the Jordanian capital, Amman, Tkiyet Um Ali (TUA) is considered the first organization of its kind in the Arab world geared towards eradicating hunger. It also represents the first non-governmental organization to provide sustainable food support, through the distribution of food parcels to families living in extreme poverty. Alongside delivering hot meals to passers-by, at its premises, and the provision of humanitarian food aid to the underprivileged in Jordan. TUA depends on regular and increasing charitable contributions to continue providing food support to its beneficiaries.',
      'image': 'asset/charities/Um_Ali.png',
      'url': 'https://www.tua.jo/en/about',
    },
    {
      'title': 'Jordan River',
      'description':
      'Chaired by Her Majesty Queen Rania Al Abdullah, JRF is a non-profit, non-governmental organization established in 1995 with a focus on child safety and community empowerment.',
      'image': 'asset/charities/Jordan River.png',
      'url': 'https://www.jordanriver.jo',
    },
    {
      'title': 'Guide to Civil Society',
      'description':
      'The Comprehensive Guide to Civil Society Organizations in Jordan is a joint effort between the Phenix Center for Economic and Informatics Studies and the Friedrech-Ebert-Stiftungto attempt to present an inclusive database for civil activists in the public life of Jordan. The Guide presents a list of different Jordanian civil society organizations, in addition to foreign organizations working in the kingdom.',
      'image': 'asset/charities/guide.png',
      'url': 'http://www.civilsociety-jo.net/ar/organization/875',
    },
    // Add more items as needed
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(items); // Initialize with all items
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      _filteredItems = List.from(items);
    } else {
      _filteredItems = items.where((item) {
        return item['title'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Charities', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color(0xFF416C77),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("asset/شعار-خطوة-بنج2.png"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search Charities',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Color(0xFF416C77)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Color(0xFF416C77)),
                  onPressed: () {
                    _searchController.clear();
                    _filterItems('');
                  },
                )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF416C77), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF416C77), width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(_filteredItems[index]['image']),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          _filteredItems[index]['title'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ReadMoreText(
                          _filteredItems[index]['description'],
                          trimLines: 2,
                          colorClickableText: Color(0xFF416C77),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: () async {
                              try {
                                await launch(_filteredItems[index]['url']);
                              } catch (e) {
                                print("Error launching URL: $e");
                              }
                            },
                            child: Text('Go to Website'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Color(0xFF416C77),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Donate'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: CharitiesScreen()));
