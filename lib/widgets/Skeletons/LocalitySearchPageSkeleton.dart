import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class LocalitySearchPageSkeleton extends StatelessWidget {
  const LocalitySearchPageSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SkeletonItem(
        child: Column(
          children: [
            SkeletonListTile(
              leadingStyle:
              SkeletonAvatarStyle(shape: BoxShape.circle, height: 30),
              titleStyle: SkeletonLineStyle(
                width: MediaQuery.of(context).size.width,
              ),
              hasSubtitle: true,
              subtitleStyle: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width, height: 50),
            ),
            SkeletonListTile(
              leadingStyle:
              SkeletonAvatarStyle(shape: BoxShape.circle, height: 30),
              titleStyle: SkeletonLineStyle(
                width: MediaQuery.of(context).size.width,
              ),
              hasSubtitle: true,
              subtitleStyle: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width, height: 50),
            ),
            SkeletonListTile(
              leadingStyle:
              SkeletonAvatarStyle(shape: BoxShape.circle, height: 30),
              titleStyle: SkeletonLineStyle(
                width: MediaQuery.of(context).size.width,
              ),
              hasSubtitle: true,
              subtitleStyle: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width, height: 50),
            ),
            SkeletonListTile(
              leadingStyle:
              SkeletonAvatarStyle(shape: BoxShape.circle, height: 30),
              titleStyle: SkeletonLineStyle(
                width: MediaQuery.of(context).size.width,
              ),
              hasSubtitle: true,
              subtitleStyle: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width, height: 50),
            ),

          ],
        ),
      ),
    );
  }
}
