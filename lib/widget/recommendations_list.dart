import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pethhealth/screen/home/profile/recommendation%20_screen.dart';

class PetRecommendationCard extends StatelessWidget {
  final PetRecommendation recommendation;

  const PetRecommendationCard({Key? key, required this.recommendation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpandableNotifier(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  // You can use different images for each recommendation if available
                  image: DecorationImage(
                    image: AssetImage((recommendation.imagePath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ExpandablePanel(
              header: Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10),
                child: Text(
                  recommendation.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              collapsed: Text(
                recommendation.description,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              expanded: Text(
                recommendation.description,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
