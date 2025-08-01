import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = usernameController.text;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(username: username),
                  ),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final List<Fruit> myFruit = [
    Fruit(
      name_fruit: "Apel",
      type_fruit: "Fuji",
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3xvx0BIwSV-npFxNZWHxsrecaC7A62VnLKw&s',
    ),
    Fruit(
      name_fruit: "Anggur",
      type_fruit: "Anggur Merah",
      image:
          'https://res.cloudinary.com/dk0z4ums3/image/upload/v1693464270/attached_image/8-manfaat-anggur-merah-untuk-kesehatan.jpg',
    ),
    Fruit(
      name_fruit: "Mangga",
      type_fruit: "Mangga Alfonso",
      image:
          'https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2023/06/29/foto-content-32-Abram-Arifin-64062668.png',
    ),
  ];

  Widget _buildCard(Fruit fruit) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(fruit.image),
        title: Text(fruit.name_fruit),
        subtitle: Text(fruit.type_fruit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: Icon(Icons.home),
        title: Text('Learning Drawing'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('User  Info'),
                    content: Text('Logged in as: ${widget.username}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 25),
            CarouselSlider(
              items:
                  [
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdF1e8rIQFav-ICUuwwpNNfoLwrPp5Decd-A&s',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVaAgPyPzsevmIkpQT6eMYhsw94paa6qrM2g&s',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwRSTmaBhQ2B-F2JRtlGp6JE2lI2CbNTdRmg&s',
                      ]
                      .map(
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
                      )
                      .toList(),
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
            const Text(
              'Are you wanna learn drawing with me?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            FruitsPage(myFruit: myFruit, count: _counter),
                  ),
                );
              },
              child: Text('Go To Fruits'),
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

class FruitsPage extends StatelessWidget {
  final List<Fruit> myFruit;
  final int count;

  const FruitsPage({super.key, required this.myFruit, required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fruits')),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          final fruitIndex = index % myFruit.length;
          return _buildCard(myFruit[fruitIndex]);
        },
      ),
    );
  }

  Widget _buildCard(Fruit fruit) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(fruit.image),
        title: Text(fruit.name_fruit),
        subtitle: Text(fruit.type_fruit),
      ),
    );
  }
}

class Fruit {
  final String name_fruit;
  final String type_fruit;
  final String image;

  Fruit({
    required this.name_fruit,
    required this.type_fruit,
    required this.image,
  });
}
