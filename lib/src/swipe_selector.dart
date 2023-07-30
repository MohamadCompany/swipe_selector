import 'package:flutter/material.dart';
import 'package:swipe_selector/src/select_item_background_painter.dart';

class SwipeSelector extends StatefulWidget {
  const SwipeSelector({
    Key? key,
    required this.items,
    this.initialPage,
    this.viewportFraction,
    this.keepPage,
    this.curve,
    this.duration,
    this.textDirection,
    this.backwardIcon,
    this.forwardIcon,
    this.reverse,
    this.style,
  }) : super(key: key);

  final List items;
  final int? initialPage;
  final double? viewportFraction;
  final bool? keepPage;
  final Curve? curve;
  final Duration? duration;
  final TextDirection? textDirection;
  final Icon? backwardIcon;
  final Icon? forwardIcon;
  final bool? reverse;
  final TextStyle? style;

  @override
  State<SwipeSelector> createState() => _SwipeSelectorState();
}

class _SwipeSelectorState extends State<SwipeSelector> {
  late List selectedIndex = [widget.initialPage ?? 3];

  List colors = ['blue', 'yello', 'white', 'brown', 'orange', 'black'];

  onPageViewChange(int page) {
    setState(() {
      selectedIndex.add(widget.items.indexOf(widget.items[page]));
    });
  }

  Future nextPage(PageController pageController) async {
    int pageNumber = pageController.page!.toInt();
    if (pageNumber <= widget.items.length - 1) {
      pageNumber += 1;
      await pageController.animateToPage(
        pageNumber,
        curve: widget.curve ?? Curves.easeIn,
        duration: widget.duration ?? const Duration(milliseconds: 300),
      );
    }
  }

  Future previousPage(PageController pageController) async {
    int pageNumber = pageController.page!.toInt();
    if (pageNumber >= 0) {
      pageNumber -= 1;
      await pageController.animateToPage(
        pageNumber,
        curve: widget.curve ?? Curves.easeIn,
        duration: widget.duration ?? const Duration(milliseconds: 300),
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
      painter: SelectItemBackgroundPainter(),
      child: SizedBox(
        height: 64,
        child: Directionality(
          textDirection: widget.textDirection ?? TextDirection.ltr,
          child: Row(
            children: [
              IconButton(
                onPressed: () => nextPage(controller),
                icon: widget.backwardIcon ??
                    const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: widget.items.length,
                  scrollDirection: Axis.horizontal,
                  reverse: widget.reverse ?? true,
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
                            style: widget.style ??
                                themeData.textTheme.labelLarge!.copyWith(
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
                onPressed: () => previousPage(controller),
                icon: widget.forwardIcon ??
                    const Icon(
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
