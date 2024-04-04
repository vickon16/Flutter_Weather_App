import 'dart:ui';

import 'package:flutter/material.dart';

enum CardSize { big, small }

class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double? elevation;
  final CardSize? cardSize;

  const HourlyForecastItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.elevation,
    this.cardSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: elevation ?? 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(cardSize == CardSize.big ? 16 : 8),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(cardSize == CardSize.big ? 16 : 8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: EdgeInsets.all(cardSize == CardSize.big ? 20 : 10),
              child: Column(
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    label,
                    style: TextStyle(
                      fontSize: cardSize == CardSize.big ? 34 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Icon(
                    icon,
                    size: cardSize == CardSize.big ? 50 : 20,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    value,
                    style:
                        TextStyle(fontSize: cardSize == CardSize.big ? 16 : 10),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
