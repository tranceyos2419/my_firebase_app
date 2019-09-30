import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/model/character.dart';
import 'package:my_firebase_app/model/user.dart';
import 'package:my_firebase_app/provider/auth.dart';
import 'package:my_firebase_app/provider/characters.dart';
import 'package:my_firebase_app/screen/character_form_screen.dart';
import 'package:provider/provider.dart';

class CharacterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<Auth>(context).user;
    print(user);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wife List'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              await Provider.of<Auth>(context).signOut();
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                radius: 20,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(30.0),
                  child: Image.network(
                    user.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CharacterFormScreen.routeName,
              arguments: {'appBarTitle': 'Register your wife'});
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final charactersProvider = Provider.of<Characters>(context);
    final authProvider = Provider.of<Auth>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: charactersProvider.fetchCharactersAsStream(authProvider.user),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final characters =
        snapshot.map((data) => Character.fromSnapshot(data)).toList();
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        itemCount: characters.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (buildContext, index) =>
            _buildListItem(context, characters[index]),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Character character) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              16.0, // horizontal, move right 10
              16.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      character.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 20,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pushNamed(
                            context, CharacterFormScreen.routeName,
                            arguments: {'edit': true, 'character': character});
                      },
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit)),
                    )),
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: InkResponse(
                      onTap: () async {
                        await Provider.of<Characters>(context)
                            .deleteCharacter(character);
                      },
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.delete)),
                    )),
              ],
            ),
            Container(
              padding: EdgeInsets.all(6.0),
              child: Text(
                character.name,
                style: TextStyle(
                  fontSize: 26.0,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(6),
                child: _buildRatingStars(context, character.rating))
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(BuildContext context, int rating) {
    List<Icon> starIconList = [];
    for (var i = 0; i < rating; i++) {
      starIconList.add(Icon(Icons.star));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: starIconList);
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Icon icon;
  final double size;

  const CircleButton({Key key, this.onTap, this.icon, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      onTap: onTap,
      child: new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: icon),
    );
  }
}
