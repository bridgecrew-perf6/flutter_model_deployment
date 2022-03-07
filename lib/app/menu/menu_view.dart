import 'package:flutter/material.dart';
import 'package:nn_model_deployment/app/anime_model/anime_model.dart';
import 'package:nn_model_deployment/app/xor_model/xor_model.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              fillColor: const Color.fromRGBO(95, 79, 188, 1),
              shape: const StadiumBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnimeModelView(),
                  ),
                );
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: const Text(
                  'Anime Model',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RawMaterialButton(
              fillColor: const Color.fromRGBO(95, 79, 188, 1),
              shape: const StadiumBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const XorModelView(),
                  ),
                );
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: const Text(
                  'Xor Model',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
