import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderImage extends StatefulWidget {
  const SliderImage({super.key});

  @override
  State<SliderImage> createState() => _SliderState();
}

class _SliderState extends State<SliderImage> {
  final List<String> imgList = [
    'https://scontent.fmnl9-1.fna.fbcdn.net/v/t39.30808-6/318213051_3369332953280601_2881606770115205145_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=730e14&_nc_ohc=VJwsdMSCFwgAX_H6L4K&_nc_ht=scontent.fmnl9-1.fna&oh=00_AfB_3X35dY4qVnuZF3k8zmfiM85tPpRtaxfir196bMgkuA&oe=6475F02B',
    'https://scontent.fmnl9-3.fna.fbcdn.net/v/t39.30808-6/250062877_3057094287837804_4458892065277853433_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=8bfeb9&_nc_ohc=SO24XdUEEqYAX9uGz7W&_nc_ht=scontent.fmnl9-3.fna&oh=00_AfBRxaszXd_DVwH3Lwi0hEkw_zfQYSlnavJoqQDfXqkgxw&oe=647490BE',
    'https://media-cdn.tripadvisor.com/media/photo-s/0d/91/8d/7a/ta-img-20161109-170031.jpg',
    'https://media-cdn.tripadvisor.com/media/photo-f/08/09/af/2b/baby-back-ribs.jpg',
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 216,
      child: Column(children: [
        Container(
          height: 188,
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
