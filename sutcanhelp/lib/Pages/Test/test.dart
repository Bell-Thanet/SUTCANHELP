import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';
import 'package:sutcanhelp/Pages/model/sosList.dart';

//********************************************************************* */
class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select animals'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

//********************************************************************* */

FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
List<Map> sosLists = List();
String item1;

// Future<void> getdata() async {
//   final DocumentReference documentReference =
//       Firestore.instance.document('SosList/soslist');
//   documentReference.get().then((datasnapshot) {
//     if (datasnapshot.exists) {
//       sosLists.add(datasnapshot.data);
//       item1 = datasnapshot.data['1'];
//       SosList sosList = SosList.fromMap(datasnapshot.data);
//     }
//   });
// }

List<MultiSelectDialogItem<int>> multiItem = List();

final valuestopopulate = {
  1: "A",
  2: "$item1",
  3: "C",
  4: "D",
  5: "E",
};

void populateMultiselect() {
  for (int v in valuestopopulate.keys) {
    multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
  }
}

void _showMultiSelect(BuildContext context) async {
  multiItem = [];
  populateMultiselect();
  final items = multiItem;

  final selectedValues = await showDialog<Set<int>>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
        initialSelectedValues: [1].toSet(),
      );
    },
  );

  print(selectedValues);
  getvaluefromkey(selectedValues);
}

void getvaluefromkey(Set selection) {
  if (selection != null) {
    for (int x in selection.toList()) {
      print(valuestopopulate[x].splitMapJoin(","));
    }
  }
}

//********************************************************************* */

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  List<Map<dynamic, dynamic>> sosLists = List();
// List<MultiSelectDialogItem<int>> multiItem = List();

  Future<void> getdata() async {
    final DocumentReference documentReference =
        Firestore.instance.document('SosList/soslist');
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        SosList sosList = SosList.fromMap(datasnapshot.data);

        for (int i = 1; i <= datasnapshot.data.length; i++) {
          print(datasnapshot.data['$i']);
          sosLists.add(datasnapshot.data['$i']);
        }

        item1 = datasnapshot.data['3'];
        setState(() {
          // sosLists.add(sosList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        child: Text("Open Multiselect"),
        onPressed: () => _showMultiSelect(context),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: ListView.builder(
  //     itemBuilder: (BuildContext buildContext, int index) {
  //       return Text(sosLists);
  //     },
  //     itemCount: sosLists.length,
  //   ));
  // }
}
