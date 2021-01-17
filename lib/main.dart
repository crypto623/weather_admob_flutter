import 'package:flutter/material.dart';
import 'package:weather_admob_flutter/weather.dart';
import 'package:firebase_admob/firebase_admob.dart';

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

class HomePage extends StatelessWidget {
  // Main Page Container
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
            MyCustomForm(),
            // BannerAdPage(),
          ],
        ),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  String currentData = '';
  String forecastData = '';

  WeatherModel weatherModel = new WeatherModel();


  callAPi(city) async {
    var current = await WeatherModel().getCurrentWeatherWithCity(city);
    var forecast = await WeatherModel().getFiveDayForecastWithCity(city);
    setState(() {
      currentData = '''
      ~~~ CURRENT WEATHER ~~~

      Place Name: ${current.areaName} [${current.country}]
      Date: ${current.date}
      Weather: ${current.weatherDescription}
      Temp: ${current.temperature} 
      Wind: speed ${current.windSpeed}, degree: ${current.windDegree}
      Weather Condition code: ${current.weatherConditionCode}

      ''';
      forecastData = '''
      ~~~ FORECAST WEATHER ~~~

      Date: ${forecast[0].date}
      Weather: ${forecast[0].weatherDescription}
      Temp: ${forecast[0].temperature}
      Wind: speed ${forecast[0].windSpeed}, degree: ${forecast[0].windDegree}
      Weather Condition code: ${forecast[0].weatherConditionCode}
      
      Date: ${forecast[1].date}
      Weather: ${forecast[1].weatherDescription}
      Temp: ${forecast[1].temperature}
      Wind: speed ${forecast[1].windSpeed}, degree: ${forecast[1].windDegree}
      Weather Condition code: ${forecast[1].weatherConditionCode}
      
      Date: ${forecast[2].date}
      Weather: ${forecast[2].weatherDescription}
      Temp: ${forecast[2].temperature}
      Wind: speed ${forecast[2].windSpeed}, degree: ${forecast[2].windDegree}
      Weather Condition code: ${forecast[2].weatherConditionCode}
      
      Date: ${forecast[3].date}
      Weather: ${forecast[3].weatherDescription}
      Temp: ${forecast[3].temperature}
      Wind: speed ${forecast[3].windSpeed}, degree: ${forecast[3].windDegree}
      Weather Condition code: ${forecast[3].weatherConditionCode}
      
      Date: ${forecast[4].date}
      Weather: ${forecast[4].weatherDescription}
      Temp: ${forecast[4].temperature}
      Wind: speed ${forecast[4].windSpeed}, degree: ${forecast[4].windDegree}
      Weather Condition code: ${forecast[4].weatherConditionCode}

      ''';
    });
  }

  // Admob integration
  BannerAd myBanner;
  BannerAd buildBannerAd(){
    return BannerAd(
      // Replase your AdUnitID
      // adUnitId:"YOUR_ADUNITID",
      adUnitId:BannerAd.testAdUnitId,
      size:AdSize.banner,
      listener:(MobileAdEvent event){
        if(event == MobileAdEvent.loaded){
          myBanner..show();
        }
      }
    );
  }
  @override
  void initState(){
    super.initState();
    // Replace your appId
    // FirebaseAdMob.instance.initialize(appId:"YOUR_APPID");
    FirebaseAdMob.instance.initialize(appId:FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()..load();
  }
  @override
  void dispose(){
    myBanner.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: myController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter city name';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'City Name'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  callAPi(myController.text);
                }
              },
              child: Text('Submit'),
            ),
          ),
          Text('${(currentData)}', style: TextStyle(height: 1.4)),
          Text('${(forecastData)}', style: TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}

