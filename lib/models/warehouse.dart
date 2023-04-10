class Warehouse {
  Warehouse({
    required this.bags,
  });

  final List<Bag> bags;
}

class Bag {
  Bag({
    required this.id,
    required this.name,
    required this.products,
    required this.units,
  });

  final String id;
  final String name;
  final List<String> products;
  final int units;
}
