import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> itemList = [];
List<String> segundalista = [];
TextEditingController itemController = TextEditingController();

class listas extends StatefulWidget {
  const listas({super.key});

  @override
  State<listas> createState() => _listasState();
}

class _listasState extends State<listas> {
  List<String> itemlist = [];
  TextEditingController itemController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _showDeleteConfirmationDialog(BuildContext context, String item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar'),
          content: Text('¿Estás seguro de que deseas eliminar este elemento?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                removesegundalista(item);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      segundalista = prefs.getStringList('itemsAeliminar') ?? [];
      itemList = prefs.getStringList('items') ?? [];
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', itemList);
    await prefs.setStringList('itemsAeliminar', segundalista);
  }

  void addItem(String item) {
    setState(() {
      itemList.add(item);
      itemController.clear();
      saveData();
    });
  }

  void removeItem(String item) {
    setState(() {
      segundalista.add(item);
      itemList.remove(item);
      saveData();
    });
  }

  void removesegundalista(String item) {
    setState(() {
      segundalista.remove(item);
      saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferencias en listas"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: itemController,
              decoration: InputDecoration(
                labelText: 'Ingresa un texto',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addItem(itemController.text);
            },
            child: Text('agregar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = itemList[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      removeItem(item);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: segundalista.length,
              itemBuilder: (BuildContext context, int index) {
                final item = segundalista[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
