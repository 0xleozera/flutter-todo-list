import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todos/home_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => HomeBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: Home(),
      ),
    );
  }
}

class Item {
  String description;
  bool toggle;

  Item(String description, bool toggle) {
    this.description = description;
    this.toggle = toggle;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc _homeBloc = BlocProvider.getBloc<HomeBloc>();

  void _showDialog(String action, index) {
    TextEditingController controller = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: action == "create"
                          ? "Nome da Tarefa"
                          : _homeBloc.list[index].description),
                ),
                MaterialButton(
                  child:
                      Text(action == "create" ? "Adicionar" : "Salvar Edição"),
                  onPressed: () {
                    action == "create"
                        ? _homeBloc.addToDo(controller.text)
                        : _homeBloc.editToDo(index, controller.text);
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text("Fechar"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog('create', 0),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: _homeBloc.outList,
        builder: (context, snapshot) {
          return Container(
              child: ListView.builder(
            itemCount: snapshot?.data?.length ?? 0,
            itemBuilder: buildItem,
          ));
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => _showDialog('edit', index),
        ),
        IconSlideAction(
          caption: 'Remover',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _homeBloc.removeToDo(index),
        )
      ],
      child: CheckboxListTile(
        title: Text(_homeBloc.list[index].description),
        value: _homeBloc.list[index].toggle,
        secondary: CircleAvatar(
          child: Icon(_homeBloc.list[index].toggle ? Icons.check : Icons.close),
        ),
        onChanged: (toggle) => _homeBloc.toggleToDo(index, toggle),
      ),
    );
  }
}
