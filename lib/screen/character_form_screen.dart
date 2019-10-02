import 'package:flutter/material.dart';
import 'package:my_firebase_app/model/character.dart';
import 'package:my_firebase_app/provider/auth.dart';
import 'package:my_firebase_app/provider/characters.dart';
import 'package:provider/provider.dart';

class CharacterFormScreen extends StatefulWidget {
  static const routeName = 'character-form';
  @override
  _CharacterFormScreenState createState() => _CharacterFormScreenState();
}

class _CharacterFormScreenState extends State<CharacterFormScreen> {
  String _appBarTitle = 'Form of your Wife';
  final _form = GlobalKey<FormState>();
  final _imgFocusNode = FocusNode();
  final _ratingFocusNode = FocusNode();
  var _isInit = true;
  var _isLoading = false;
  var _isEdit = false;
  Character _character = new Character();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (args['edit'] != null && args['edit']) {
        _character = args['character'];
        _isEdit = args['edit'];
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _submit() async {
//* this function executes onSaved of every TextFormField
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_character.uid == null) {
        _character = Character(
            name: _character.name,
            img: _character.img,
            rating: _character.rating,
            uid: Provider.of<Auth>(context).user.uid,
            reference: _character.reference);
      }
      if (_isEdit) {
        // await Provider.of<Characters>(context, listen: false)
        // .updateCharacterAsTransaction(_character);
        await Provider.of<Characters>(context).updateChracter(_character);
      } else {
        await Provider.of<Characters>(context, listen: false)
            .addCharacter(_character);
      }
    } catch (e) {
      //TODO better error handling
      print('error: $e');
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_appBarTitle'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildCenter(),
    );
  }

  Widget buildCenter() {
    final double _iconSize = 34.0;
    final double _sizedBoxHeight = 28.0;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Text(
              'Who is your wife?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: _sizedBoxHeight),
            TextFormField(
              initialValue: _character.name,
              decoration: InputDecoration(
                labelText: 'Name',
                fillColor: Colors.white,
                icon: Icon(
                  Icons.person,
                  size: _iconSize,
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_imgFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide name';
                }
              },
              onSaved: (value) {
                _character = Character(
                    name: value,
                    img: _character.img,
                    rating: _character.rating,
                    uid: _character.uid,
                    reference: _character.reference);
              },
            ),
            SizedBox(height: _sizedBoxHeight),
            TextFormField(
              initialValue: _character.img,
              decoration: InputDecoration(
                  labelText: 'Img',
                  icon: Icon(
                    Icons.image,
                    size: _iconSize,
                  )),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.url,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_ratingFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide image';
                }
              },
              onSaved: (value) {
                _character = Character(
                    name: _character.name,
                    img: value,
                    rating: _character.rating,
                    uid: _character.uid,
                    reference: _character.reference);
              },
            ),
            SizedBox(height: _sizedBoxHeight),
            TextFormField(
              initialValue:
                  _character.rating != null ? _character.rating.toString() : '',
              decoration: InputDecoration(
                  labelText: 'Rating',
                  icon: Icon(
                    Icons.star,
                    size: _iconSize,
                  )),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide number';
                }
              },
              onFieldSubmitted: (_) {
                _submit();
              },
              onSaved: (value) {
                _character = Character(
                    name: _character.name,
                    img: _character.img,
                    uid: _character.uid,
                    rating: int.parse(value),
                    reference: _character.reference);
              },
            ),
            SizedBox(height: _sizedBoxHeight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildRaisedButton(
                    Theme.of(context).accentColor,
                    Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white),
                    ), () {
                  Navigator.of(context).pop();
                }, context),
                buildRaisedButton(
                    Theme.of(context).primaryColor,
                    Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    _submit,
                    context),
              ],
            )
          ],
        )),
      ),
    );
  }

  RaisedButton buildRaisedButton(
      Color color, Text text, Function onPressed, BuildContext context) {
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: text,
      onPressed: onPressed,
    );
  }
}
