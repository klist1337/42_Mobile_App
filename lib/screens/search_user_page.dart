
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../fl_chart/radar.dart';
import '../helper/reusableComponent.dart';
import '../services/data_services.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key, required this.login});
  final String login;

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  String? level;
  List<String>? infos;
  dynamic userData;
  dynamic coalitionData;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: DataServices().getSearchUserInfo(widget.login),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color:Color(0xFF00BABC)));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No data available"));
            }
            final user = snapshot.data;
            userData = user;
            final level = user["cursus_users"][1]["level"];
            final skills = user["cursus_users"][1]["skills"];
            final skillsLevel = getSkillsValues(skills);
            final levelPercent = getPercent(level);
            final location = user["location"] ?? "Unavailable";
            final wallet = user["wallet"];
            final correctionPoint = user["correction_point"];
            List<String> userInfos = [location, wallet.toString(), correctionPoint.toString()];
            //print(user["cursus_users"][1]); // skills list
            return FutureBuilder(
                future: DataServices().getUserCoalition(user["id"]),
                builder: (context, AsyncSnapshot snap) {
                  if (snap.data == null || !snap.hasData) {
                    return const SizedBox.shrink();
                  }
                  final coalition = snap.data;
                  coalitionData = coalition;
                  String image = coalition[0]["cover_url"];
                  String colorString = coalition[0]["color"];

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover)
                    ),
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 318,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha:0.3),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black.withValues(alpha: 0.3)
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 140,
                                              height: 140,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(99),
                                                color:const Color.fromARGB(255, 19, 190, 107),
                                              ),
                                              child:  Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(user['image']['versions']['large']),
                                                  radius: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(user['usual_full_name'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                          Text(user['login'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),),
                                          const SizedBox(height: 20,),
                                          LinearPercentIndicator(
                                            progressColor: hexToColor(colorString),
                                            center:Text("${level!}%",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            backgroundColor: Colors.white,
                                            percent: levelPercent,
                                            lineHeight: 25,
                                            barRadius: const Radius.circular(20),
                                          ),
                                          const SizedBox(height: 10,),
                                          DisplayInfo(infos: userInfos)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    border: Border.all(
                                        style: BorderStyle.none
                                    )
                                ),
                                child: RadarChartSample1(
                                  skillsColor: hexToColor(colorString),
                                  skillsValue: skillsLevel,) ,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }
            );
          }),
    );
    }
    double getPercent(double level) {
      String getDecimal = level.toString().split('.')[1];
      double value = double.parse(getDecimal);
      int valueLength = value.toInt().toString().length;
      if (valueLength == 1) {
        return (value * 10 / 100);
      }
      else {
        return value / 100;
      }
    }
    List<double> getSkillsValues(List<dynamic> skills) {
      List<double> values = [];
      for (var skill in skills) {
        values.add(skill["level"]);
      }
      return values;
    }
}
