import 'package:flutter/material.dart';

class DisplayInfo extends StatelessWidget {
  const DisplayInfo({super.key, required this.infos});

  final List<String>? infos;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.desktop_mac,
                  color: Colors.white),
            const SizedBox(width: 8,),    
            Text(infos![0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                )),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          height: 32,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
            ),
            color: Colors.black.withValues(alpha: 0.6)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                const SizedBox(width: 20,),
                const Icon(Icons.wallet,
                  color: Colors.white,),
                const SizedBox(width: 8,),
                Text(infos![1],
                  style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.5,),
                const Text("Ev.P",
                    style:TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )),
                const SizedBox(width: 8),
                Text(infos![2],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ) ,),
              ]
            ),
          ),
        ),
      ],
    );
  }
}