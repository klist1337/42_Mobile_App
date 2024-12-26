import 'package:flutter/material.dart';

class Projects extends StatelessWidget {
  const Projects({super.key, 
  required this.user,
  required this.coalitionData,});
  final dynamic user;
  final dynamic coalitionData;
  @override
  Widget build(BuildContext context) {
    final projects =  user["projects_users"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
      ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(coalitionData[0]["cover_url"]),
              fit: BoxFit.cover),),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:  BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                child: ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                      return Column(
                        children: [ 
                          projects[index]["cursus_ids"][0] == 21 
                          && projects[index]["final_mark"].toString() != "null"  ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(projects[index]["project"]["name"], 
                                style: const TextStyle(
                                  color: Color(0xFF00BABC),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text(projects[index]["final_mark"].toString(),
                                style: const TextStyle(
                                  color: Colors.green, 
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),)
                              ],
                            ),
                          ) : const SizedBox.shrink()
                        ],
                      );
                  },
                ),
              ),
            ),
          ),
          
    );
  }
}