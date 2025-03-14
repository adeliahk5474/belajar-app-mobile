import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Learning again'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Icon(Icons.home),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 25),
            CarouselSlider(
              items: [
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdF1e8rIQFav-ICUuwwpNNfoLwrPp5Decd-A&s',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVaAgPyPzsevmIkpQT6eMYhsw94paa6qrM2g&s',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwRSTmaBhQ2B-F2JRtlGp6JE2lI2CbNTdRmg&s',
              ].map(
                (item) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      item,
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                  ),
                ),
              ).toList(),
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
            const Text(
              'Are you wanna learn drawing digital together with',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Fruit {
  final String name_fruit;
  final String types_fruit;
  final String image;

  Fruit({
    required this.name_fruit,
    required this.types_fruit,
    required this.image,
  });
}

class HomePage extends StatelessWidget {
  final List<Fruit> myFruit = [
    Fruit(
      name_fruit: "Apel",
      types_fruit: "Fuji",
      image: 'https://storage.googleapis.com/manfaat/2017/12/8b3ec3ea-6-manfaat-apel-fuji-bagi-kesehatan-300x200.jpg',
    ),
    Fruit(
      name_fruit: "Anggur",
      types_fruit: "Anggur Merah",
      image: 'https://res.cloudinary.com/dk0z4ums3/image/upload/v1693464270/attached_image/8-manfaat-anggur-merah-untuk-kesehatan.jpg',
    ),
    Fruit(
      name_fruit: "Mangga",
      types_fruit: "Mangga Alfonso",
      image: 'https://awsimages.detik.net.id/content/2014/05/07/297/manggaalphonsoluar.jpg',
    ),
  ];

  Widget _buildCard(Fruit myFruit) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(myFruit.image),
        title: Text(myFruit.name_fruit),
        subtitle: Text(myFruit.types_fruit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
      ),
      body: ListView.builder(
        itemCount: myFruit.length,
        itemBuilder: (context, index) {
          return _buildCard(myFruit[index]);
        },
      ),
    );
  }
}
