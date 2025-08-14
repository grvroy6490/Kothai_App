import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageSlider extends StatefulWidget {
    final List<Widget> pages;
    final VoidCallback? onFinished;

    const PageSlider({Key? key, required this.pages, this.onFinished})
        : super(key: key);

    @override
    _PageSliderState createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
    late final PageController _pageController;
    int _currentIndex = 0;

    @override
    void initState() {
        _pageController = PageController();
        super.initState();
    }

    void _nextPage() {
        if (_currentIndex < widget.pages.length - 1) {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
            );
        } else {
            widget.onFinished?.call();
        }
    }

    @override
    void dispose() {
        _pageController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Color.fromARGB(255, 64, 68, 76)),
            child: Column(
                children: [
                    Expanded(
                        child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) => setState(() => _currentIndex = index),
                            children: widget.pages,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: LoadingAnimationWidget.progressiveDots(
                            color: Colors.white,
                            size: 80,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Flexible(
                                    child: Text(
                                        'உங்கள் தட்டச்சு பயணத்தை தயாரிக்கிறோம்...',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(255, 182, 186, 195),
                                        ),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}
