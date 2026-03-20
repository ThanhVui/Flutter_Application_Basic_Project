abstract class Printable {
  void printInfo();
}

mixin Swimmable {
  void swim() {
    print("Swimming");
  }
}
mixin Flyable {
  void fly() {
    print("Flying");
  }
}
class Animal {
  String name;
  Animal(this.name);
}
class Duck extends Animal with Flyable, Swimmable implements Printable {
  Duck(super.name);

  @override
  void printInfo() {
    print(name);
  }

}