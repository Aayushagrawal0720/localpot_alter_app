import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class LandingPageSkeleton extends StatelessWidget {
  const LandingPageSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SkeletonItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3
                ),
              ),
              // SizedBox(height: 30,),
              // SkeletonAvatar(
              //   style: SkeletonAvatarStyle(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height/7
              //   ),
              // ),
              // SizedBox(height: 30,),
              // SkeletonAvatar(
              //   style: SkeletonAvatarStyle(
              //       width: MediaQuery.of(context).size.width,
              //       height: MediaQuery.of(context).size.height/7
              //   ),
              // )

            ],
          ),
        ),
      ),
    );
  }
}
