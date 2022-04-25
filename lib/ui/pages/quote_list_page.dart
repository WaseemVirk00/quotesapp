import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quotesapp/ui/pages/quote_detailPage.dart';

import '../Models/QuoteModel.dart';

class QuoteListPage extends StatefulWidget {
  const QuoteListPage({Key? key}) : super(key: key);

  @override
  State<QuoteListPage> createState() => _QuoteListPageState();
}

class _QuoteListPageState extends State<QuoteListPage> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Quotes_table2");

  late CategoriesList allitems;
  late PageController _pageController;
  double maxHeight = 150;
  double dragHeight = 0;
  int currentPage = 0;
  bool isForward = false;
  bool next = false;
  bool isLoaded = false;
  static List<CategoriesList> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = false;
    readData();
    _pageController = PageController(viewportFraction: .2);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoaded
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ...allitems.items.asMap().entries.map<Widget>((data) {
                    print(" keys ${data.key}");
                    int index = allitems.items.length - 1 - data.key;
                    int newIndex = index - currentPage;
                    double rightPad = newIndex >= 0 ? -newIndex * 50 : -25;
                    double topPad = newIndex >= 0 ? -newIndex * 50 : 75;
                    double turns = newIndex >= 0 ? newIndex * .02 : -.14;
                    double size = newIndex >= 0 ? -newIndex * .02 : 0;
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 750),
                      right: -25 + rightPad,
                      top: 85 + topPad,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 750),
                        alignment: Alignment.topRight,
                        turns: -.1 + turns,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 750),
                          width: MediaQuery.of(context).size.width * 1.35,
                          height: MediaQuery.of(context).size.width * 1.25,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: data.key % 2 == 0
                                      ? [
                                          Colors.yellowAccent.shade100,
                                          Colors.greenAccent.shade400
                                        ]
                                      : [
                                          Colors.yellowAccent.shade100,
                                          Colors.orangeAccent.shade400
                                        ])),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned(
                    bottom: -100,
                    child: _buildItem(context),
                  ),
                  Positioned(
                    bottom: (maxHeight * 2) - 40,
                    child: _buildActionButton(context),
                  ),
                  Positioned(
                    top: kToolbarHeight,
                    right: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                  Positioned(
                    top: kToolbarHeight,
                    left: 12,
                    child: Text(
                      "Quotes",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()));
  }

  SizedBox _buildActionButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: Colors.black)),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuoteDetailPage(
                            allitems2: allitems.items
                                .elementAt(currentPage)
                                .subcategoryItem,
                            main_item: allitems.items
                                .elementAt(currentPage)
                                .item_names,
                          )));
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }

  Container _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: PageView.builder(
          controller: _pageController,
          itemCount: allitems.items.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          reverse: true,
          itemBuilder: (context, index) {
            var data = allitems.items.elementAt(index);
            bool isActive = index == currentPage;
            return LayoutBuilder(builder: (context, constraint) {
              maxHeight = constraint.maxHeight;
              return Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: isActive
                            ? maxHeight - (isForward ? dragHeight : -dragHeight)
                            : (currentPage > index ? 1 * maxHeight : maxHeight),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Text(
                              ("${index + 1}"),
                              style: TextStyle(
                                fontSize: isActive ? 26 : 24,
                                fontWeight: FontWeight.w200,
                                foreground: Paint()
                                  ..style = isActive
                                      ? PaintingStyle.fill
                                      : PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color =
                                      isActive ? Colors.black : Colors.black38,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              (data.item_names),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragUpdate:
                          isActive ? _onVerticalDragUpdate : null,
                      onVerticalDragEnd: isActive ? _onVerticalDragEnd : null,
                      child: Container(
                        height: maxHeight,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: const SizedBox.shrink(),
                      ),
                    )
                  ],
                ),
              );
            });
          }),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    double drag = details.localPosition.dy.abs();
    double dragPercantage = drag / maxHeight;
    setState(() {
      next = false;
      if (details.delta.dy > 0) {
        isForward = true;
        if (dragPercantage < .6) {
          dragHeight = dragPercantage * (.6 * maxHeight);
        } else {
          next = true;
        }
      } else {
        isForward = false;
        if (dragPercantage < .3) {
          dragHeight = dragPercantage * (.3 * maxHeight);
        } else {
          next = true;
        }
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      dragHeight = 0;
    });
    if (next) {
      if (isForward) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut);
      } else {
        _pageController.previousPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut);
      }
    }
  }

  Future<void> readData() async {
    await ref.once().then((value) {
      var snapshot = value.snapshot;
      if (snapshot.exists) {
        allitems = CategoriesList(items: [
          for (var element in snapshot.children)
            MainCategories(
                item_names: element.key!,
                subcategoryItem: [
                  for (var element2 in element.children)
                    SubcategoryItem(
                        sub_item_quote:
                            element2.child("Quotes").value.toString(),
                        sub_item_author:
                            element2.child("Author").value.toString(),
                        sub_item_index: element2.hashCode)
                ],
                item_index: 20),
        ]);
        setState(() {
          isLoaded = true;
        });
        print(" length ${allitems.items.length}");
      } else {
        print('readData No data available.');
      }
    });
  }
}
