import 'dart:ffi';

import 'package:app_mobile_42/helper/function.dart';
import 'package:app_mobile_42/helper/reusableComponent.dart';
import 'package:app_mobile_42/login_page.dart';
import 'package:app_mobile_42/services/data_services.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? level;
  List<String>? infos;

  void getlevelFuntion() async{
  level = await getLevel();
  }
  void saveLevelFunct(String level) async {
    await saveLevel(level);
  }
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
          print(user);
          return FutureBuilder(
            future: DataServices().getUserCoalition(user["id"]),
            builder: (context, AsyncSnapshot snap) {
              if (snap.data == null || !snap.hasData) {
                 return const SizedBox.shrink();
              }
              final coalition = snap.data;
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
                            height: MediaQuery.sizeOf(context).height * 0.35,
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
                                        FutureBuilder(
                                          future: DataServices().getCursus(user["id"]) ,
                                          builder: (context, AsyncSnapshot snapshot) {
                                            if (!snapshot.hasData || snapshot.data == null) {
                                              return const SizedBox.shrink();
                                            }
                                            try {
                                             level = snapshot.data[0]["level"].toString();
                                             saveLevelFunct(level!);
                                             double value = double.parse(level!.split('.')[1]);
                                              double percent;
                                              int valueLength = value.toInt().toString().length;
                                              if (valueLength == 1) {
                                                percent = value * 10 / 100;
                                              }
                                              else {
                                                percent = value / 100;
                                              }
                                             return Column(
                                              children: [
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
                                                  percent: percent,
                                                  lineHeight: 25,
                                                  barRadius: const Radius.circular(20),
                                                )
                                              ],
                                            );
                                            } catch (e) {
                                              getlevelFuntion();
                                              double value =  double.parse(level!.split('.')[1]);
                                              double percent;
                                              int valueLength = value.toInt().toString().length;
                                              if (valueLength == 1) {
                                                percent = value * 10 / 100;
                                              }
                                              else {
                                                percent = value / 100;
                                              }
                                              return Column(
                                              children: [
                                                const SizedBox(height: 20,),
                                                LinearPercentIndicator(
                                                  progressColor: const Color(0xFF00babc),
                                                  center:Text("${level!}%",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  backgroundColor: Colors.white,
                                                  percent: percent,
                                                  lineHeight: 25,
                                                  barRadius: const Radius.circular(20),
                                                )
                                              ],
                                            );
                                            }
                                          } ),
                                      const SizedBox(height: 10,),
                                      FutureBuilder(
                                        future: DataServices().getLocation(user['id']),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const Center(child: CircularProgressIndicator(color: Color(0xFF00babc)));
                                          }
                                          if (snapshot.data == null || !snapshot.hasData) {
                                            return const SizedBox.shrink();
                                          }
                                          try {
                                            final data = snapshot.data;
                                            final location = data[0]["user"]["location"].toString();
                                            final wallet = data[0]["user"]["wallet"].toString();
                                            final correctionPoint = data[0]["user"]["correction_point"].toString();
                                            List<String> infosUser = [location, wallet, correctionPoint];
                                            saveInfo(infosUser);
                                            return DisplayInfo(infos: infosUser);
                                          } catch(e) {
                                            getUserInfo();
                                            return DisplayInfo(infos: infos);
                                          }
                                        }
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                            const SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade100
                                )
                              ),
                              child: const Text("content") ,
                            )
                      ],
                    ),
                  ],
                ),
              );
            }
          );
        }),
        drawer:  Drawer(
          backgroundColor: Colors.black.withValues(alpha:0.6),
          child: ListView(
            children: [
              ListTile(
                title: const Text("Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24
                ),),
                leading: IconButton(
                  onPressed: () {
                   deleToken();
                   Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Loginpage()));
                  }, 
                  icon: const Icon(Icons.logout,
                  size: 30,
                  color: Colors.white,)),
              )
            ],
          ),
        ),
    );
  }

  Future saveUserInfo(List<String> infos) async {
    await saveInfo(infos);
  }

  Future getUserInfo() async {
    infos = await getInfo();
  }
}