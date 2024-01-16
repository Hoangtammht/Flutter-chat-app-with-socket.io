import 'package:chat_app/Model/CountryModel.dart';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  final Function setCountryData;
  const CountryPage({Key? key, required this.setCountryData}) : super(key: key);

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<CountryModel> countries = [
    CountryModel(name: "India", code: "+91", flag: "IN"),
    CountryModel(name: "Pakistan", code: "+92", flag: "PK"),
    CountryModel(name: "United States", code: "+1", flag: "US"),
    CountryModel(name: "South Africa", code: "+23", flag: "ZA"),
    CountryModel(name: "Afghanistan", code: "+93", flag: "AF"),
    CountryModel(name: "United Kingdom", code: "+44", flag: "GB"),
    CountryModel(name: "Italy", code: "+39", flag: "IT"),
    CountryModel(name: "India", code: "+25", flag: "IN"),
    CountryModel(name: "Pakistan", code: "+5", flag: "PK"),
    CountryModel(name: "United States", code: "+23", flag: "US"),
    CountryModel(name: "South Africa", code: "+3", flag: "ZA"),
    CountryModel(name: "Afghanistan", code: "+99", flag: "AF"),
    CountryModel(name: "United Kingdom", code: "+60", flag: "GB"),
    CountryModel(name: "Italy", code: "+77", flag: "IT"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Choose a country",
          style: TextStyle(
              color: Colors.teal,
              fontSize: 18,
              wordSpacing: 1,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.teal,
              ))
        ],
      ),
      body: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) => card(countries[index])),
    );
  }

  Widget card(CountryModel country) {
    return InkWell(
      onTap: () {
        widget.setCountryData(country);
      },
      child: Card(
        margin: EdgeInsets.all(0.15),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Text(country.flag),
              SizedBox(
                width: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text(country.name)],
              ),
              Expanded(
                child: Container(width: 150, child: Text(country.code)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
