import 'package:core/core.dart';
import 'package:flutter/material.dart';

class TVNotFoundWidget extends StatelessWidget {
  final String message;

  const TVNotFoundWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/search_not_found.png'),
          const SizedBox(height: 15),
          Text(
            message,
            style: kHeading6.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
