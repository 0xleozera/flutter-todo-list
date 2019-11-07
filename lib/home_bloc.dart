import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos/main.dart';

class HomeBloc extends BlocBase {
  BehaviorSubject<List<Item>> _listController;

  Stream get outList => _listController.stream;
  Function get inList => _listController.sink.add;
  List<Item> get list => _listController.value;

  HomeBloc() {
    _listController = BehaviorSubject<List<Item>>.seeded(List<Item>());
  }

  void addToDo(String description) {
    var item = new Item(description, false);
    _listController.value.add(item);
    inList(_listController.value);
  }

  void editToDo(int index, String description) {
    _listController.value[index].description = description;
    inList(_listController.value);
  }

  void removeToDo(int index) {
    _listController.value.removeAt(index);
    inList(_listController.value);
  }

  void toggleToDo(int index, bool toggle) {
    _listController.value[index].toggle = toggle;
    inList(_listController.value);
  }

  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
