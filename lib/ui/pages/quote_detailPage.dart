import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotesapp/ui/Models/QuoteModel.dart';

class QuoteDetailPage extends StatefulWidget {
  final List<SubcategoryItem> allitems2;
  final String main_item;

  const QuoteDetailPage(
      {Key? key, required this.allitems2, required this.main_item})
      : super(key: key);

  @override
  State<QuoteDetailPage> createState() => _QuoteDetailPageState();
}

class _QuoteDetailPageState extends State<QuoteDetailPage> {
  late PageController _pageController;
  double maxHeight = 150;
  double dragHeight = 0;
  int currentPage = 0;
  bool isForward = false;
  bool next = false;
  int currentIndex = 0;
  late PageController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          ...widget.allitems2.asMap().entries.map<Widget>((data) {
            int index = widget.allitems2.length - 1 - data.key;
            int newIndex = index - currentPage;
            double rightPad = newIndex >= 0 ? -newIndex * 50 : -25;
            double topPad = newIndex >= 0 ? -newIndex * 50 : 75;
            double turns = newIndex >= 0 ? newIndex * .02 : -.14;
            double size = newIndex >= 0 ? -newIndex * .02 : 0;
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 750),
              right: -10 + rightPad,
              top: 75 + topPad,
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
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: 20,
            child: SingleChildScrollView(child: _buildItem(context)),
          ),
          Positioned(
            top: kToolbarHeight,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 10),
              child: Text(
                "${widget.main_item} - ${currentIndex + 1}/${widget.allitems2.length}",
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20),
                // onPressed: () {},
                // icon: const Icon(Icons.more_vert),
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight,
            left: 12,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.black)),
        child: IconButton(
          onPressed: () {
            String quote =
                widget.allitems2.elementAt(currentPage).sub_item_quote;
            String owner =
                widget.allitems2.elementAt(currentPage).sub_item_author;
            Clipboard.setData(ClipboardData(text: "$quote -$owner"))
                .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied")),
                    ));
          },
          icon: const Icon(Icons.content_copy),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Center _buildItem(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PageView.builder(
            controller: _controller,
            itemCount: widget.allitems2.length,
            reverse: true,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              var data = widget.allitems2.elementAt(index);
              bool isActive = index == currentPage;
              return LayoutBuilder(builder: (context, constraint) {
                maxHeight = constraint.maxHeight;
                return Padding(
                  padding: const EdgeInsets.only(right: 60, left: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.sub_item_quote != null ? '“ ' : "",
                        style: const TextStyle(
                            fontFamily: "Ic",
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 35),
                      ),
                      Text(
                          data.sub_item_quote != null
                              ? data.sub_item_quote
                              : "",
                          style: const TextStyle(
                              fontFamily: "Ic",
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18)),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(data.sub_item_author,
                            style: const TextStyle(
                                fontFamily: "Ic",
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                );
              });
            }),
      ),
    );
  }
}
