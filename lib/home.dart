import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MyHomePage extends StatefulWidget {
  MyHomePage({ Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List? datas;
  int page = 1; //XXXXX
  

  Future<Object> _getCharacters() async {
    
    var data = await http.get(Uri.parse('https://rickandmortyapi.com/api/character/?page=$page'),
    headers: {"Accept": "application/json"} ///XXX
    );  ///XXX
    var jsonData = json.decode(data.body);

    ///
    //  this.setState(() {
    //   datas = Map<String,dynamic>.from( json.decode(data.body)) as List?;
    // });

    // return "Success!";

     @override
  void initState() {
    this._getCharacters();
  }
    
    ///

    List<Character> characters = [];

    for (var c in jsonData['results']) {
      Character character = Character(
          c['name'], c['status'], c['species'], c['gender'], c['image']);
      characters.add(character);
    }

    return characters;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getCharacters(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].imageUrl),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].status),
                  );
                });
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            page++;
            _getCharacters();
          });
        },
        tooltip: 'Incrementar',
        child: Icon(Icons.add),
      )
    );
  }
}

class Character {
  final String name;
  final String status;
  final String species;
  final String gender;
  final String imageUrl;

  Character(this.name, this.status, this.species, this.gender, this.imageUrl);
}