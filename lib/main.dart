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
  Weather currentData;
  List<Weather> forecastData;
  int i = 10;
  WeatherModel weatherModel = new WeatherModel();

  callAPi(data) async {
    var city = data + ', AU';
    var current = await WeatherModel().getCurrentWeatherWithCity(city);
    var forecast = await WeatherModel().getFiveDayForecastWithCity(city);
    setState(() {
      currentData = current;
      i = i + 10;
      print('===================>');
      print(currentData.areaName);
      forecastData = forecast;
      // currentData = '''
      // ~~~ CURRENT WEATHER ~~~

      // Place Name: ${current.areaName} [${current.country}]
      // Date: ${current.date}
      // Weather: ${current.weatherDescription}
      // Temp: ${current.temperature}
      // Wind: speed ${current.windSpeed}, degree: ${current.windDegree}
      // Weather Condition code: ${current.weatherConditionCode}

      // ''';
      // forecastData = '''
      // ~~~ FORECAST WEATHER ~~~

      // Date: ${forecast[0].date}
      // Weather: ${forecast[0].weatherDescription}
      // Temp: ${forecast[0].temperature}
      // Wind: speed ${forecast[0].windSpeed}, degree: ${forecast[0].windDegree}
      // Weather Condition code: ${forecast[0].weatherConditionCode}

      // Date: ${forecast[1].date}
      // Weather: ${forecast[1].weatherDescription}
      // Temp: ${forecast[1].temperature}
      // Wind: speed ${forecast[1].windSpeed}, degree: ${forecast[1].windDegree}
      // Weather Condition code: ${forecast[1].weatherConditionCode}

      // Date: ${forecast[2].date}
      // Weather: ${forecast[2].weatherDescription}
      // Temp: ${forecast[2].temperature}
      // Wind: speed ${forecast[2].windSpeed}, degree: ${forecast[2].windDegree}
      // Weather Condition code: ${forecast[2].weatherConditionCode}

      // Date: ${forecast[3].date}
      // Weather: ${forecast[3].weatherDescription}
      // Temp: ${forecast[3].temperature}
      // Wind: speed ${forecast[3].windSpeed}, degree: ${forecast[3].windDegree}
      // Weather Condition code: ${forecast[3].weatherConditionCode}

      // Date: ${forecast[4].date}
      // Weather: ${forecast[4].weatherDescription}
      // Temp: ${forecast[4].temperature}
      // Wind: speed ${forecast[4].windSpeed}, degree: ${forecast[4].windDegree}
      // Weather Condition code: ${forecast[4].weatherConditionCode}

      // ''';
    });
  }

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
    callAPi("Sydney");
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
              showSelectedItem: true,
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
                callAPi(data);
              },
              selectedItem: "Sydney",
            ),
            // Text('${(currentData)}', style: TextStyle(height: 1.4)),
            // Text('${(forecastData)}', style: TextStyle(height: 1.4)),
            CurrentTableWidget(currentData : currentData, i: i),
          ],
        ),
      ),
    );
  }
}

class CurrentTableWidget extends StatefulWidget {
  final Weather currentData;
  final int i;
  CurrentTableWidget({Key key, @required this.currentData, @required this.i})
      : super(key: key);
  @override
  _CurrentTableWidgetState createState() =>
      _CurrentTableWidgetState(currentData, i);
}

class _CurrentTableWidgetState extends State<CurrentTableWidget> {
  final Weather currentData;
  final int i;
  _CurrentTableWidgetState(this.currentData, this.i);
  @override
  void initState() {
    super.initState();
    print('----------------------------------------------------------------');
    print(currentData);
  }

  @override
  void didUpdateWidget(CurrentTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print(currentData);
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: currentData != null ? Text(i.toString() + 'sdfsf') : Text('null'),
    );
  }
}

// class DataTableWidget extends StatelessWidget {

//   final List<Map<String, String>> listOfColumns = [
//     {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
//     {"Name": "BBBBBB", "Number": "2", "State": "no"},
//     {"Name": "CCCCCC", "Number": "3", "State": "Yes"}
//   ];
//   print
// //  DataTableWidget(this.listOfColumns);     // Getting the data from outside, on initialization
//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       columns: [
//         DataColumn(label: Text('Patch')),
//         DataColumn(label: Text('Version')),
//         DataColumn(label: Text('Ready')),
//       ],
//       rows:
//           listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
//               .map(
//                 ((element) => DataRow(
//                       cells: <DataCell>[
//                         DataCell(Text(element["Name"])), //Extracting from Map element the value
//                         DataCell(Text(element["Number"])),
//                         DataCell(Text(element["State"])),
//                       ],
//                     )),
//               )
//               .toList(),
//     );
//   }
// }
