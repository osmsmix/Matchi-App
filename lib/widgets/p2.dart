import 'package:first_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:intl/intl.dart';

class p2 extends StatefulWidget {
  const p2({super.key});
 static const String screenRoute = 'profil';
  @override
  State<p2> createState() => _p2State();
}
class _p2State extends State<p2> {
    

  // mybutton({required this.color,required this.title,required this.onPressed});
  // final Color color;
  // final String title;
  // final VoidCallback onPressed;
  String? a;
  bool isvisible = false;
  DateTime? selectedDate;
  final List<String> _checked = [];
  List<String> itemList = ["Item 1", "Item 2", "Item 3"]; // قائمة العناصر

  // الدالة المسؤولة عن حذف عنصر من القائمة
  void _deleteItem(int index) {
    setState(() {
      itemList.removeAt(index); // حذف العنصر بالفهرس المحدد
    });
  }

  // الدالة المسؤولة عن إضافة عنصر إلى القائمة
  void _addItem(String item) {
    setState(() {
      itemList.add(item); // إضافة العنصر إلى نهاية القائمة
    });
  }
  final bool _showCalendar = false;
  List<String> itemlist = [
    "Ajouter une autre heur",
    "ن",
    "dhd",
    "sdfifjsf",
    "fshwc"
  ];
  String? selecteditem = "Ajouter une autre heur";
  DateTime? d = DateTime.now();
  final List<String> _items = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
  ];

  final List<bool> _checkedItems = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  String getFormattedDate(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
   child: Column(children: [
    const SizedBox(height: 100,),
    Center(
      child: Container(
        width: 300,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 172, 154, 100),
          ),
          borderRadius: BorderRadius.circular(10))
          
        ,
        child: const Text("edd"),
                    ),
    ),
    const SizedBox(height: 10,),
    Center(
      child: InkWell(
        child: Container(
          width: 300,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 154, 100),
            ),
            borderRadius: BorderRadius.circular(10))
            
          ,
          child: const Text("edd"),
                      ),
                      onTap: () {

                      },
      ),
    ),
    Visibility(
      visible: true,
      child: Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 172, 154, 100),),
          borderRadius: BorderRadius.circular(10)
          ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///////////
              
              
            
              mybutton(
                  color: Colors.black,
                  title: "ajouter une photo",
                  onPressed: () async {
                  //await _requestPermissioncamera();
                // CollectionReference usersCollection=_firestore.collection("site");
                // DocumentReference newDocRef = usersCollection.doc('2');

                // newDocRef.set({
                //   "nom":"blal",
                //   "url":sitePhoto,
                //   "nom":"gjhg"
                // });
                
                  }),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  // siteText=value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  hintText: 'Entrez votre texte ici',
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
             
              const SizedBox(height: 10),
              Container(
                width: 300,
                //height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.map),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "sadadsd",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                    // onTap: () => _launchMaps(siteLocalisation)
                    ),
              ),
              // Container(
              //   child: GoogleMap(
              //         onMapCreated: _onMapCreated,
              //         initialCameraPosition: CameraPosition(
              //           target: LatLng(48.8534, 2.3488),
              //           zoom: 12,
              //         ),
              //         markers: _markers,
              //         onTap: _onMarkerTapped,
              //       ),

              // ),

              mybutton(
                  color: Colors.black,
                  title: "modifier la localisation ",
                  onPressed: () {}),
              const SizedBox(height: 10),
              
              const SizedBox(
                height: 20,
              ),
              // buildSectionTitle(context, 'وقت التوقف '),

              
              const SizedBox(height: 10),

              // عرض القائمة باستخدام ListView.builder
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: 240,
              //     decoration:
              //         BoxDecoration(border: Border.all(color: Colors.black)),
              //     child: ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: itemList.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         return ListTile(
              //           title: Text(itemList[index]),
              //           trailing: IconButton(
              //             icon: Icon(Icons.delete),
              //             onPressed: () => _deleteItem(index),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),



              // إضافة عنصر إلى القائمة

              const SizedBox(height: 10),

              Visibility(
                visible: !isvisible,
                child: ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDatePickerMode: DatePickerMode.day,
                    );
                    if (selectedDate != null) {
                      String j = getFormattedDate(selectedDate);
                      a = j;
                      setState(() {
                        isvisible = !isvisible;
                      });
                      //d = selectedDate;
                      // يمكن استخدام selectedDate لتحديد السنة المختارة
                    }
                  },
                  child: const Text('Add Item'),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red)),
                        height: isvisible ? 200 : 0,
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                              title: Text(_items[index]),
                              value: _checkedItems[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _checkedItems[index] = value!;
                                  if (_checkedItems[index] == true) {
                                    _checked.add(_items[index]);
                                  } else {
                                    _checked.remove(_items[index]);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => {
                              _addItem("$a,$_checked"),
                              setState(() {
                                isvisible = !isvisible;
                              })
                            },
                        child: const Text("ok"))
                 

              ///////////
            ],
          ),
        ),
   ]),
    )
    ),
    )
    )]
   )
      )
      // child: Material(
      //   elevation: 5,
      //   color: color,
      //   borderRadius: BorderRadius.circular(10),
      //   child: MaterialButton(
      //     onPressed: onPressed,
      //     minWidth: 200,
      //     height: 42,
      //     child: Text(title,
      //     style: TextStyle(color: Colors.white),),
      //     ),
      // ),
    );
    
  }
}