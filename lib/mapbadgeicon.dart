import 'package:flutter/material.dart';

class MapBadgeIcon extends StatelessWidget {
  const MapBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        decoration: BoxDecoration(
            // color: const Color.fromARGB(160, 213, 210, 210),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color:
                      const Color.fromARGB(157, 173, 164, 164).withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero)
            ]),
        child: Row(
          children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                        image: AssetImage('assets/profileImg.jpeg'),
                        fit: BoxFit.cover),
                    border: Border.all(
                        color: const Color.fromARGB(255, 1, 1, 1), width: 1))),
            const SizedBox(width: 10),
            const Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sidhant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 84, 78, 78),
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'My Location',
                  style: TextStyle(
                    color: Color.fromARGB(255, 84, 78, 78),
                    letterSpacing: 1.2,
                  ),
                )
              ],
            )),
            const Icon(Icons.location_pin, color: Colors.redAccent, size: 40)
          ],
        ),
      ),
    );
  }
}
