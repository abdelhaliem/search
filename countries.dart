import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel/screens/search.dart';

import '../color.dart';
import 'ditalsWorld.dart';

class Countries extends StatefulWidget {
  String id;
  String name;
  Countries({@required this.id, this.name});
  @override
  CountriesState createState() => CountriesState();
}

class CountriesState extends State<Countries> {
  // void initState() {
  //   super.initState();
  //   loadData();
  //   getConutries();
  // }

  // List _countries = [];
  // var jsonData = Data();
  // void loadData() async {
  //   await jsonData.getCountries();
  //   setState(() {
  //     _countries = jsonData.countries;
  //   });
  // }

  // Map _map;
  // List conutries = [];
  // List conutry = [];

  // Future<List> getConutries() async {
  //   final String response = await rootBundle.loadString('assets/api/data.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     _map = data['countries'];
  //     conutries = _map.values.toList();
  //   });
  //   for (int i = 0; i <= conutries.length; i++) {
  //     String countryCon = conutries[i]['contint'];
  //     if (widget.key == countryCon) {
  //       conutry.add(conutries[i]);
  //     }
  //   }
  //   return conutry;
  // }

  Map _map;
  List country = [];
  List countries = [];
  bool favorite = false;

  Future<List> getCountry() async {
    final String response = await rootBundle.loadString('assets/api/data.json');
    final data = await json.decode(response);
    setState(() {
      _map = data['countries'];
      country = _map.values.toList();
    });

    for (var i = 0; i < country.length; i++) {
      var countryOfCon = country[i]['continent'];
      if (widget.id == countryOfCon) {
        countries.add(country[i]);
        searchList = countries;
      }
    }
    return countries;
  }

  @override
  void initState() {
    getCountry();
    super.initState();
  }

  bool isSearching = false;
  List searchList = [];

  void _filterSearch(value) {
    // print(searchList = countries
    //     .where((country) =>
    //         country['name'].toLowerCase().contains(value.toLowerCase()))
    //     .toList());
    print(value);

    setState(() {
      searchList = countries
          .where((country) =>
              country['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoresDark.red,
        title: !isSearching
            ? Text(widget.name)
            : TextField(
                onChanged: (value) {
                  _filterSearch(value);
                },
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Search Countries Here',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  icon: Icon(Icons.search, color: Colors.white),
                ),
              ),
        centerTitle: true,
        actions: [
          isSearching
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      searchList = countries;
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  }),
        ],
      ),
      body: countries.length > 0
          ? ListView.builder(
              itemCount: countries.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade200),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountriesDetails(
                                      name: countries[index]["name"],
                                      continent: countries[index]["continent"],
                                      emoji: countries[index]["emoji"],
                                      native: countries[index]["native"],
                                      phone: countries[index]["phone"],
                                      languages: countries[index]["languages"],
                                    )));
                      },
                      trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: ColoresDark.red,
                          ),
                          onPressed: () {
                            setState(() {
                              favorite = true;
                              print('faaaav');
                            });
                          }),
                      title: Text(
                        countries[index]["name"],
                        style: TextStyle(color: ColoresDark.bal),
                      ),
                      leading: Text(countries[index]["emoji"]),
                    ),
                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
