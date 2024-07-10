import 'package:flutter/material.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/images.dart';
import 'package:pethhealth/widget/recommendations_list.dart';

class PetRecommendation {
  final String title;
  final String description;
  final String imagePath;

  PetRecommendation({required this.title, required this.description ,required this.imagePath});
}

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    List<PetRecommendation> recommendations = [
      PetRecommendation(
        title: getLang(context, "vaccinations"),
        description:
        getLang(context, "vaccinations_text"),
            imagePath: imageVaccinations,
      ),
      PetRecommendation(
        title: getLang(context, "healthy"),
        description:
        getLang(context, "healthy_text"),
            imagePath: imageHealthy,
      ),
      PetRecommendation(
        title: getLang(context, "regular"),
        description:getLang(context, "regular_text"),
            imagePath: imageRegular,
      ),
      PetRecommendation(
        title: getLang(context, "hygiene"),
        description:getLang(context, "hygiene_text"),
            imagePath: imageVaccinations,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getLang(context, "pet_title"),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                PetRecommendationCard(recommendation: recommendations[index]),
          );
        },
      ),
    );
  }
}
