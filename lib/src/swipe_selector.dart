import 'package:flutter/material.dart';
import 'package:swipe_selector/src/select_date_background_painter.dart';

class SwipeSelector extends StatefulWidget {
  const SwipeSelector({
    Key? key,
    required this.items,
    this.initialPage,
    this.viewportFraction,
    this.keepPage,
  }) : super(key: key);

  final int? initialPage;
  final double? viewportFraction;
  final bool? keepPage;
  final List items;

  @override
  State<SwipeSelector> createState() => _SwipeSelectorState();
}

class _SwipeSelectorState extends State<SwipeSelector> {
  List selectedIndex = [3];

  onPageViewChange(int page) {
    setState(() {
      selectedIndex.add(widget.items.indexOf(widget.items[page]));
    });
  }

  Future nextPage(PageController pageController) async {
    int pageNumber;
    pageNumber = pageController.page!.toInt();
    if (pageNumber <= 11) {
      pageNumber += 1;
      await pageController.animateToPage(
        pageNumber,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Future previousPage(PageController pageController) async {
    int pageNumber;
    pageNumber = pageController.page!.toInt();
    if (pageNumber >= 0) {
      pageNumber -= 1;
      await pageController.animateToPage(
        pageNumber,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  late PageController controller = PageController(
    initialPage: widget.initialPage ?? 3,
    viewportFraction: widget.viewportFraction ?? 0.4,
    keepPage: widget.keepPage ?? true,
  );

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 100),
      painter: SelectDateBackgroundPainter(),
      child: SizedBox(
        height: 64,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  nextPage(controller);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: widget.items.length,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  onPageChanged: onPageViewChange,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedIndex.last >
                            widget.items.indexOf(widget.items[index])) {
                          previousPage(controller);
                        } else if (selectedIndex.last <
                            widget.items.indexOf(widget.items[index])) {
                          nextPage(controller);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.items[index]}",
                            style: themeData.textTheme.labelLarge!.copyWith(
                              color: selectedIndex.isEmpty
                                  ? const Color(0xFFACACAC)
                                  : selectedIndex.last ==
                                          widget.items
                                              .indexOf(widget.items[index])
                                      ? const Color(0xFF091B3D)
                                      : const Color(0xFFACACAC),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  previousPage(controller);
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
