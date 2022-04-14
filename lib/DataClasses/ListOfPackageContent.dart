import 'PackageContent.dart';

class ListOfPackageContent {
  List<PackageContent> _pcs = [
    PackageContent(id: "p1", title: "Grocery"),
    PackageContent(id: "p2", title: "Food"),
    PackageContent(id: "p3", title: "Vegetables"),
    PackageContent(id: "p4", title: "Electronics"),
  ];

  getPackageContentList() => _pcs;
}
