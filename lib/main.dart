import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllWeathers();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Demo'),
      ),
      body: StreamBuilder(
        stream: bloc.allWeathers,
        builder: (context, AsyncSnapshot<SetWeather> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 1000,
              width: 1000,
              color: Colors.blue,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 1000,
                width: 1000,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Washington"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("Temperature"))),
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: (snapshot.data.main.temp - 273.15)
                                              .toInt() >
                                          0
                                      ? CupertinoColors.systemRed
                                          .withOpacity(0.4)
                                      : CupertinoColors.systemBlue
                                          .withOpacity(0.4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text(
                                    "${(snapshot.data.main.temp - 273.15).toInt()}"),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("Weather"))),
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("${snapshot.data.weather[0].main}"))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("Feels Like"))),
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: (snapshot.data.main.feelsLike - 273.15)
                                      .toInt() >
                                      0
                                      ? CupertinoColors.systemRed
                                      .withOpacity(0.4)
                                      : CupertinoColors.systemBlue
                                      .withOpacity(0.4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("${(snapshot.data.main.feelsLike - 273.15).toInt()}"))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("Wind Speed"))),
                          Container(
                              height: 50,
                              width: 150,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text("${(snapshot.data.wind.speed).toInt()}"))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class WeatherApiProvider {
  Future<SetWeather> fetchWeatherList() async {
    String weatherApiKey = 'fbfd715323d19d6e43b98ce15bbeea69';
    String weatherApiCity = 'Washington';

    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$weatherApiCity&appid=$weatherApiKey';

    var response = await http.get(url);

    var resp = SetWeather.fromMap(json.decode(response.body));

    print(json.decode(response.body));

    return resp;
  }
}

class Repository {
  final weathersApiProvider = WeatherApiProvider();

  Future<SetWeather> fetchAllWeathers() =>
      weathersApiProvider.fetchWeatherList();
}

class WeathersBloc {
  final _repository = Repository();
  final _weathersFetcher = PublishSubject<SetWeather>();

  Stream<SetWeather> get allWeathers => _weathersFetcher.stream;

  fetchAllWeathers() async {
    SetWeather getData = await _repository.fetchAllWeathers();
    _weathersFetcher.sink.add(getData);
  }

  dispose() {
    _weathersFetcher.close();
  }
}

class SetWeather {
  SetWeather({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  Coord coord;
  List<Weather> weather;
  String base;
  Main main;
  int visibility;
  Wind wind;
  Clouds clouds;
  int dt;
  Sys sys;
  int timezone;
  int id;
  String name;
  int cod;

  factory SetWeather.fromMap(Map<String, dynamic> json) => SetWeather(
        coord: Coord.fromMap(json["coord"]),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromMap(x))),
        base: json["base"],
        main: Main.fromMap(json["main"]),
        visibility: json["visibility"],
        wind: Wind.fromMap(json["wind"]),
        clouds: Clouds.fromMap(json["clouds"]),
        dt: json["dt"],
        sys: Sys.fromMap(json["sys"]),
        timezone: json["timezone"],
        id: json["id"],
        name: json["name"],
        cod: json["cod"],
      );

  Map<String, dynamic> toMap() => {
        "coord": coord.toMap(),
        "weather": List<dynamic>.from(weather.map((x) => x.toMap())),
        "base": base,
        "main": main.toMap(),
        "visibility": visibility,
        "wind": wind.toMap(),
        "clouds": clouds.toMap(),
        "dt": dt,
        "sys": sys.toMap(),
        "timezone": timezone,
        "id": id,
        "name": name,
        "cod": cod,
      };
}

class Clouds {
  Clouds({
    this.all,
  });

  int all;

  factory Clouds.fromMap(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );

  Map<String, dynamic> toMap() => {
        "all": all,
      };
}

class Coord {
  Coord({
    this.lon,
    this.lat,
  });

  double lon;
  double lat;

  factory Coord.fromMap(Map<String, dynamic> json) => Coord(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "lon": lon,
        "lat": lat,
      };
}

class Main {
  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
  });

  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;

  factory Main.fromMap(Map<String, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
        feelsLike: json["feels_like"].toDouble(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
        pressure: json["pressure"],
        humidity: json["humidity"],
      );

  Map<String, dynamic> toMap() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "humidity": humidity,
      };
}

class Sys {
  Sys({
    this.type,
    this.id,
    this.country,
    this.sunrise,
    this.sunset,
  });

  int type;
  int id;
  String country;
  int sunrise;
  int sunset;

  factory Sys.fromMap(Map<String, dynamic> json) => Sys(
        type: json["type"],
        id: json["id"],
        country: json["country"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "id": id,
        "country": country,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}

class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  int id;
  String main;
  String description;
  String icon;

  factory Weather.fromMap(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };
}

class Wind {
  Wind({
    this.speed,
    this.deg,
  });

  double speed;
  int deg;

  factory Wind.fromMap(Map<String, dynamic> json) => Wind(
        speed: json["speed"].toDouble(),
        deg: json["deg"],
      );

  Map<String, dynamic> toMap() => {
        "speed": speed,
        "deg": deg,
      };
}

final bloc = WeathersBloc();
