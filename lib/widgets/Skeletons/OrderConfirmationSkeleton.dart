import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class OrderConfirmationSkeleton extends StatelessWidget {
  const OrderConfirmationSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SkeletonItem(
        child: Column(
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width, height: 3),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
            SizedBox(
              height: 10,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18),
            ),
          ],
        ),
      ),
    );
  }
}
