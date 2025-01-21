import 'dart:async';

import 'package:app_mobile_42/fl_chart/radar.dart';
import 'package:app_mobile_42/helper/function.dart';
import 'package:app_mobile_42/helper/reusableComponent.dart';
import 'package:app_mobile_42/screens/login_page.dart';
import 'package:app_mobile_42/screens/projects.dart';
import 'package:app_mobile_42/screens/search_user_page.dart';
import 'package:app_mobile_42/services/data_services.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? level;
  List<String>? infos;
  dynamic userData;
  dynamic coalitionData;
  late StreamSubscription<InternetStatus> _subscription;
  bool? isInternet;
  TextEditingController searchController = TextEditingController();

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  String uppercaseFirstLetter(String text) {
    return text[0].toUpperCase() + text.substring(1, text.length);
  }

  @override
  void initState() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch(status) {
        case InternetStatus.connected:
          setState(() {
            isInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isInternet = false;
          });
          break;
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (isInternet == false) {
      return offlinePage();
    }
    return  SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          flexibleSpace: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60.0, top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        controller: searchController ,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white
                              )
                            ) ,
                            focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white
                              )
                            ),
                            hoverColor: Colors.white,

                          )
                        ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (searchController.text.isNotEmpty) {
                          showDialog(context: context, builder: (context) =>
                          const AlertDialog(
                            backgroundColor: Colors.transparent,
                            content:  Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey
                              ),
                            ),
                          ));
                          final data = await DataServices().getAllUsers(searchController.text);
                          if (data["login"] == searchController.text) {
                            if (!context.mounted) return ;
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) =>
                                AlertDialog(
                                  content: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SearchUserPage(login: data["login"])));
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(data['image']['versions']['large']),
                                          radius: 25,
                                        ),
                                        const SizedBox(width: 10,),
                                        Text(uppercaseFirstLetter(data["displayname"]),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        ),)
                                      ],
                                    ),
                                  ),
                                )
                            );
                          }
                          else {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            showDialog(context: context, builder: (context) =>
                            AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 65.0),
                                child: Text(
                                    "User not found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red.shade200
                                  ),
                                ),
                              )
                            ));
                          }
                        }
                      },
                      child: const Text("search"))
                ],
              ),
      
              )),
      
        body: homePage(),
          drawer:  Drawer(
            backgroundColor: Colors.black.withValues(alpha:0.6),
            child: ListView(
              children: [
                const SizedBox(height: 30,),
                 InkWell(
                  onTap: () {
                    Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (context) => Projects(user: userData, coalitionData: coalitionData,)));
                  },
                   child: const ListTile(
                    title: Text("Projects",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                    ),),
                    leading:  Icon(
                      Icons.file_copy, 
                      color: Colors.white,)),
                 ) ,
                InkWell(
                  onTap: () {
                    deleToken();
                     Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Loginpage()));
                  },
                  child: const ListTile(
                    title: Text("Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                    ),),
                    leading: Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.white,)),
                ),
              ],
            ),
          ),
      ),
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

  Widget searchUser(String login) {
    return FutureBuilder(
        future: DataServices().getAllUsers(login),
        builder: (context, AsyncSnapshot snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Color(0xFF00BABC));
          }
          if (snap.hasError || !snap.hasData) {
            return const Text("user not found");
          }
          final data = snap.data;
          if (data["login"] == login) {
            return const Text("User found");
          }
          return const Text("User not found");
        }
    );
  }

  Widget homePage() {
    return FutureBuilder(
        future: DataServices().getUserInfo(),
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
        });
  }

  Widget offlinePage() {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("You are offline",
          style: TextStyle(
            fontSize: 21,
            
          ),),
        ),
      ),
    );
  }
}