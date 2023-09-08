// import 'package:first_app/screens/5.dart';
// import 'package:flutter/material.dart';

// class check extends StatefulWidget {
//   static const String screenRoute = 'check';
//   const check({super.key});

//   @override
//   State<check> createState() => _checkState();
// }

// class _checkState extends State<check> {
//   List<String> _items = [
//     '0',
//     '1',
//     '2',
//     '3',
//     '4',
//     '5',
//     '6',
//     '7',
//     '8',
//     '9',
//     '10',
//     '11',
//     '12',
//     '13',
//     '14',
//     '15',
//     '16',
//     '17',
//     '18',
//     '19',
//     '20',
//     '21',
//     '22',
//     '23',
//   ];

//   List<bool> _checkedItems = [
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//   ];
//   List<String> _checked = [
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("تحديد ساعات توقف العمل"),
//         actions: [IconButton(onPressed: (){
          
//           String nom ="";
//           for (var i in _checked){
            
//             nom = "$nom , $i";
//           }
//            _j = "$j,$nom";
//           _textController.text = j;
                      
          
                      
//           Navigator.pushNamed(context, mod.screenRoute,arguments: nom);
//         }, icon: Icon(Icons.check))],
//       ),
//       body: Container(
//         child: ListView.builder(
//           itemCount: _items.length,
//           itemBuilder: (BuildContext context, int index) {
//             return CheckboxListTile(
//               title: Text(_items[index]),
//               value: _checkedItems[index],
//               onChanged: (bool? value) {
//                 setState(() {
//                   _checkedItems[index] = value!;
//                   _checked.add(_items[index]);
//                 });
//               },
              
//             );
//           },
//         ),
      
//       ),
//     );
//   }
// }
