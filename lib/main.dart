import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_admob_flutter/weather.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:dropdown_search/dropdown_search.dart';

void main() {
  runApp(MyApp());
}

var currentData;
var forecastData;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String param = 'Sydney';
  WeatherModel weatherModel = new WeatherModel();

  // Admob integration
  BannerAd myBanner;
  BannerAd buildBannerAd() {
    return BannerAd(
        // Replase your AdUnitID
        // adUnitId:"YOUR_ADUNITID",
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  @override
  void initState() {
    super.initState();
    // Replace your appId
    // FirebaseAdMob.instance.initialize(appId:"YOUR_APPID");
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()..load();
    // callAPi("Sydney");
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),

        // background_image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),

        // child widgets
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                bottom: 10,
              ),
              child: Text(
                "Weather(Australia)",
                style: TextStyle(fontSize: 22),
              ),
            ),
            DropdownSearch<String>(
              mode: Mode.MENU,
              maxHeight: 300,
              showSelectedItem: true,
              dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
              items: [
                "Sydney",
                "Albury",
                "Armidale",
                "Bathurst",
                "Blue Mountains",
                "Broken Hill",
                "Campbelltown",
                "Cessnock",
                "Dubbo",
                "Goulburn",
                "Grafton",
                "Lithgow",
                "Liverpool",
                "Newcastle",
                "Orange",
                "Parramatta",
                "Penrith",
                "Queanbeyan",
                "Tamworth",
                "Wagga Wagga",
                "Wollongong"
              ],
              label: "City Name *",
              onChanged: (data) {
                setState(() {
                  param = data;
                });
              },
              selectedItem: "Sydney",
            ),
            CurrentTableWidget(param: param),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 0,
              ),
              child: Text("Forecast Weather",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ForecastTableWidget(param: param),
          ],
        ),
      ),
    );
  }
}

// CurrentTable
class CurrentTableWidget extends StatefulWidget {
  final String param;
  CurrentTableWidget({Key key, @required this.param}) : super(key: key);
  @override
  _CurrentTableWidgetState createState() => _CurrentTableWidgetState(param);
}

class _CurrentTableWidgetState extends State<CurrentTableWidget> {
  final String param;
  _CurrentTableWidgetState(this.param);
  Weather currentData;
  @override
  void initState() {
    super.initState();
    this.callAPI(this.widget.param);
  }

  @override
  void didUpdateWidget(CurrentTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.callAPI(this.widget.param);
  }

  callAPI(data) async {
    var city = data + ', AU';
    var current = await WeatherModel().getCurrentWeatherWithCity(city);
    setState(() {
      if (current == null) {
        currentData = new Weather(null);
      } else {
        currentData = current;
        print("=============<<<<<<<<<<<");
        print(currentData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: currentData != null
              ? DataTable(
                  dataRowHeight: 30,
                  columnSpacing: 0,
                  horizontalMargin: 0,
                  columns: [
                    DataColumn(label: Text('Current Weather')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text("Date")),
                      DataCell(Text(currentData.date.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Description")),
                      DataCell(Text(currentData.weatherDescription.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Temp")),
                      DataCell(Text(currentData.temperature.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Temp (min)")),
                      DataCell(Text(currentData.tempMin.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Temp (max)")),
                      DataCell(Text(currentData.tempMax.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Sunrise")),
                      DataCell(Text(currentData.sunrise.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Sunset")),
                      DataCell(Text(currentData.sunset.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Wind Speed")),
                      DataCell(Text(currentData.windSpeed.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Wind Degree")),
                      DataCell(Text(currentData.windDegree.toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Condition code")),
                      DataCell(
                          Text(currentData.weatherConditionCode.toString())),
                    ]),
                  ],
                )
              : Text(''),
        ),
      ),
    );
  }
}

// ForecastTable
class ForecastTableWidget extends StatefulWidget {
  final String param;
  ForecastTableWidget({Key key, @required this.param}) : super(key: key);
  @override
  _ForecastTableWidgetState createState() => _ForecastTableWidgetState(param);
}

class _ForecastTableWidgetState extends State<ForecastTableWidget> {
  final String param;
  _ForecastTableWidgetState(this.param);
  List<Weather> forecastData;
  @override
  void initState() {
    super.initState();
    this.callAPI(this.widget.param);
  }

  @override
  void didUpdateWidget(ForecastTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.callAPI(this.widget.param);
  }

  callAPI(data) async {
    var city = data + ', AU';
    var forecast = await WeatherModel().getFiveDayForecastWithCity(city);
    setState(() {
      if (forecast == null)
        forecastData = [];
      else {
        List<Weather> let = [
          forecast[0],
          forecast[8],
          forecast[16],
          forecast[24],
          forecast[32],
          forecast[39]
        ];
        forecastData = let;
        print('=============>>>>>>>>>>>>>>>>>>>>>');
        print(forecastData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dataRowHeight: 30,
            columnSpacing: 5,
            horizontalMargin: 0,
            columns: [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Temp')),
              DataColumn(label: Text('Temp (min)')),
              DataColumn(label: Text('Temp (max)')),
              DataColumn(label: Text('Wind Speed')),
              DataColumn(label: Text('Wind Degree')),
              DataColumn(label: Text('Condition code')),
            ],
            rows: forecastData != null?forecastData // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                  element.date.toString().substring(0, 10))),
                              DataCell(
                                  Text(element.weatherDescription.toString())),
                              DataCell(Text(element.temperature.toString())),
                              DataCell(Text(element.tempMin.toString())),
                              DataCell(Text(element.tempMax.toString())),
                              DataCell(Text(element.windSpeed.toString())),
                              DataCell(Text(element.windDegree.toString())),
                              DataCell(Text(
                                  element.weatherConditionCode.toString())),
                            ],
                          )),
                    )
                    .toList()
                : [],
          ),
        ),
      ),
    );
  }
}
