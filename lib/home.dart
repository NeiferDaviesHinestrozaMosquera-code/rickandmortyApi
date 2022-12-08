import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MyHomePage extends StatefulWidget {
  MyHomePage({ Key? key }) : super(key: key);


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
        centerTitle: true,
        title: Text("Rick y Morty Api"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getCharacters(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: const Center(
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
                    title: Text(snapshot.data[index].name ,  style: TextStyle(fontSize: 20),),
                    subtitle: Text(snapshot.data[index].status ,  style: TextStyle(fontSize: 15),),
                  );
                }
              );
            }
          },
        ),
      ),
      floatingActionButton: Container(   
        child: Row( 
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             FloatingActionButton(onPressed: (){
               setState(() {
                  page--;
                  _getCharacters();
                });
            },
              tooltip: 'Decrementar',
              child: Icon(Icons.arrow_back_ios_new,color: Colors.red,),
            ),

            SizedBox(width: 10, height: 10,),

            FloatingActionButton(
              onPressed: () {
                setState(() {
                  page++;
                  _getCharacters();
                });
              },
              tooltip: 'Incrementar',
              child: Icon(Icons.arrow_forward_ios , color: Colors.blue,),
            ),
          ],
        ),
      ),   
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