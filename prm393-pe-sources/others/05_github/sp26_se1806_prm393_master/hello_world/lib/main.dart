import 'dart:convert';
import 'dart:math';

import 'package:hello_world/animal.dart';
import 'package:hello_world/post.dart';
import 'package:http/http.dart' as http;

void greet(String name, [int age = -1]) {
  if (age == null) {
    print("Hello $name");
  } else {
    print("Hello $name, you're $age");
  }
}

void describe({required String color, String size = "medium"}) {
  print("This item is $size and $color");
}

class Student {
  String _name;
  int age;
  int grade;

  // Student() : _name = 'John', age = 18, grade = 10; // Unnamed constructor
  Student(this.age, this.grade) : _name = '20'; // Unnamed constructor

  // Named constructor
  Student.withName(this._name) : age = 18, grade = 10;

  // Viet setter, getter
  String get name => _name;

  set name(String name) {
    this._name = name;
  }

  void displayInfo() {
    print("Hello, I am $_name, $age years old");
  }
}

// Extension
// extension NumberParsing on String {
//   int parseInt() {
//     return int.parse(this); // Integer.parseInt(
//   }
// }

// Future
Future<String> getUsers() {
  return Future.delayed(Duration(milliseconds: 500), () => 'User A');
}

// Stream
Stream<int> getRandomNumbers() async* {
  var random = Random();
  int n;
  int checkPoint = 79;
  do {
    n = random.nextInt(100);
    await Future.delayed(Duration(milliseconds: 500));
    yield n;
  } while (n != checkPoint);
}

void main() async {
  // getNumbers().listen((v) => print(v));
  // await for (var num in getRandomNumbers()) {
  //   print(num);
  //   if (num == 79) {
  //     print("Bingo! value is $num");
  //   }
  // }
  // getRandomNumbers().forEach((v) {
  //   print(v);
  // });

  // var userName = await getUsers();
  // print(userName);
  //
  // print("Before");
  // Future(() => 1)
  // .then((val) => val + 1)
  // .then((val2) => print(val2));
  // print("After");

  // Microtask
  // print('1 sync');
  // Future.microtask(() {
  //   print('2 microtask');
  //   return 2;
  // }).then((val) {
  //   print('3 then');
  //   print(val);
  // });
  // Future(() => print('3 future'));
  // print('4 sync');

  // Future(() => print("Finish"));
  //
  //
  //
  // Post p = Post(userId: 7, id: 10, title: "Hello", body: "Hello world!");
  // p.displayInfo();

  // Cho URL https://jsonplaceholder.typicode.com/posts/3
  // Call API
   // If response != 200.... return...
  var post = await fetchPost(3);
  post.displayInfo();
}

Future<Post> fetchPost(int id) async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
  final response = await http.get(uri);
  return Post.fromJson(jsonDecode(response.body));
}

// BT: Viet 1 doan code de
// cach moi 1s
// lay ngau nhien 1 bai post bat ki
// va in ra man hinh (max 3 bai)
