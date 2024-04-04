// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final double temp = 0;
  late Future<Map<String, dynamic>> weatherCall;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    const url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=6.4579&lon=3.1580&appid=38f3f155e7232a47bc39160dd49ed0fb";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw "An Unexpected Error Occurred";
      }

      final data = jsonDecode(response.body);

      if (data['cod'] != "200") {
        throw "An Unexpected Error Occurred";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weatherCall = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        actions: [
          // can use GestureDetector or InkWell here instead of IconButton
          IconButton(
            onPressed: () => {
              setState(() {
                weatherCall = getCurrentWeather();
              })
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weatherCall,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // adaptive gives us a native feel.
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final List<dynamic> dataList = data["list"];
          final currentTemperature = dataList[0]["main"]["temp"];
          final currentSky = dataList[0]["weather"][0]["main"];
          final currentPressure = dataList[0]["main"]["pressure"];
          final currentHumidity = dataList[0]["main"]["humidity"];
          final currentWindSpeed = dataList[0]["wind"]["speed"];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: HourlyForecastItem(
                    label: "$currentTemperature K",
                    icon: currentSky == "Clouds" || currentSky == "Rain"
                        ? Icons.cloud
                        : Icons.sunny,
                    value: "$currentSky",
                    elevation: 3,
                    cardSize: CardSize.big,
                  ),
                ),
                const SizedBox(height: 15),
                // weather forecast cards
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final list = dataList[index + 1];
                        final listSky = list["weather"][0]["main"];
                        // format to Hour-min
                        final time = DateTime.parse(list["dt_txt"]);
                        final formattedTime = DateFormat.j().format(time);

                        return SizedBox(
                          width: 90,
                          child: HourlyForecastItem(
                            label: formattedTime,
                            icon: listSky == "Clouds" || listSky == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            value: list["main"]["temp"].toString(),
                            elevation: 1,
                          ),
                        );
                      }),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: "$currentHumidity",
                      ),
                      AdditionalInfo(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: "$currentWindSpeed",
                      ),
                      AdditionalInfo(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: "$currentPressure",
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
