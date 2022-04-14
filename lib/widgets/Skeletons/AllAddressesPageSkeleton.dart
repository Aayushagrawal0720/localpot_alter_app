import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class AllAddressesPageSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget childd(context, index) {
      return SkeletonListTile(
        leadingStyle: SkeletonAvatarStyle(shape: BoxShape.circle, height: 30),
        titleStyle: SkeletonLineStyle(
          width: MediaQuery.of(context).size.width,
        ),
        subtitleStyle: SkeletonLineStyle(
            width: MediaQuery.of(context).size.width, height: 50),
      );
    }

    return Container(
      child: SkeletonItem(
        child: Column(
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(
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
