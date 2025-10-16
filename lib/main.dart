import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'database_helper.dart';
// Here we are using a global variable. You can use something like
// get_it in a production app.
final dbHelper = DatabaseHelper();
Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
// initialize the database
await dbHelper.init();
runApp(const MyApp());
}
class MyApp extends StatelessWidget {
const MyApp({super.key});
@override
Widget build(BuildContext context) {

return MaterialApp(
title: 'SQFlite Demo',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: const MyHomePage(),
);
}
}
class MyHomePage extends StatelessWidget {
const MyHomePage({super.key});
// homepage layout
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('sqflite'),
backgroundColor: Colors.blueAccent,
),
body: Center(
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,

children: <Widget>[
ElevatedButton(
onPressed: _insert,
style: ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))

),
child: const Text('insert'),
),
const SizedBox(height: 10),

ElevatedButton(
onPressed: _query,
style: ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))


),
child: const Text('query'),
),

ElevatedButton(
onPressed: () => _queryById(context),
style: ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))

),
child: const Text('queryById'),
),
const SizedBox(height: 10),

const SizedBox(height: 10),

ElevatedButton(
onPressed: _update,
style: ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
),
child: const Text('update'),
),
const SizedBox(height: 10),
ElevatedButton(
onPressed: _delete,
style: ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))

),
child: const Text('delete'),
),
],
),
),
);
}
// Button onPressed methods
void _insert() async {
// row to insert
Map<String, dynamic> row = {
DatabaseHelper.columnName: 'Bob',
DatabaseHelper.columnAge: 23
};
final id = await dbHelper.insert(row);
debugPrint('inserted row id: $id');
}
void _query() async {
final allRows = await dbHelper.queryAllRows();
debugPrint('query all rows:');
for (final row in allRows) {
debugPrint(row.toString());
}
}


void _queryById(BuildContext context) async {
  final TextEditingController idController = TextEditingController();

  final result = await showDialog<int> (
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Query By Id'),
      content: TextField(
        controller: idController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Enter ID'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              final id = int.tryParse(idController.text);
              Navigator.of(context).pop(id);
            },
            child: const Text('OK'),
          )
      ],
      ),

    );

    if(result != null) {
      final row = await dbHelper.queryById(result);
      if(row != null) {
        debugPrint('Row with id=$result: $row');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Found: ${row['name']}, Age: ${row['age']}')),
      );
      }
      else{
        debugPrint('Row with id = $result not found!');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No row found with id $result')));
      }
    }

}
void _update() async {
// row to update
Map<String, dynamic> row = {
DatabaseHelper.columnId: 1,
DatabaseHelper.columnName: 'Mary',
DatabaseHelper.columnAge: 32
};
final rowsAffected = await
dbHelper.update(row);
debugPrint('updated $rowsAffected row(s)');
}
void _delete() async {
// Assuming that the number of rows is the id for the last row.
final id = await dbHelper.queryRowCount();
final rowsDeleted = await dbHelper.delete(id);
debugPrint('deleted $rowsDeleted row(s): row$id');
}
}