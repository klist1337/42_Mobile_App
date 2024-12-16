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
            infos?[0] == null ?
            const Text("unavailable",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )) :
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
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                const Icon(Icons.wallet,
                  color: Colors.white,),
                const SizedBox(width: 8,),
                Text(infos![1],
                  style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
              ]
            ),
          ),
        ),
      ],
    );
  }
}