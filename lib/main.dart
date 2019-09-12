

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class EntryData extends StatefulWidget {
  @override
  EntryDataState createState() => new EntryDataState();
}

class EntryDataState extends State<EntryData> {

  // text field
  final _nomerRakController = TextEditingController();
  final _namaProdukController = TextEditingController();
  // dropdown category
  List _category = ["Buah-buahan", "Snack", "Stationary", "Baju", "Ice Cream"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;
  // datepicker
  String _datetime = '';
  int _year = 2018;
  int _month = 11;
  int _date = 11;
  // radio
  int _radioValue1;
  //QRScaner
  String barcode = '';


  //Scan QR
  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }
  @override
  void initState() {
    super.initState();
    // dropdown category
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCategory = _dropDownMenuItems[0].value;
    // datepicker
    DateTime now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _date = now.day;
  }

  // dropdown category
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String kategori in _category) {
      items.add(new DropdownMenuItem(
          value: kategori,
          child: new Text(kategori)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  // radio discount
  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  /// Display date picker.
  void _showDatePicker() {
    final bool showTitleActions = false;
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minYear: 2019,
      maxYear: 2022,
      initialYear: _year,
      initialMonth: _month,
      initialDate: _date,
      confirm: Text(
        'PILIH',
        style: TextStyle(color: Colors.red),
      ),
      cancel: Text(
        'BATAL',
        style: TextStyle(color: Colors.cyan),
      ),
      locale: "en",
      dateFormat: "dd-mm-yyyy",
      onChanged: (year, month, date) {
        //debugPrint('onChanged date: $year-$month-$date');

        if (!showTitleActions) {
          _changeDatetime(year, month, date);
        }
      },
      onConfirm: (year, month, date) {
        _changeDatetime(year, month, date);
      },
    );
  }

  void _changeDatetime(int year, int month, int date) {
    setState(() {
      _year = year;
      _month = month;
      _date = date;
      _datetime = '$date-$month-$year';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Entry'),
      ),
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            children: <Widget>[
              // text field
              TextField(
                controller: _nomerRakController,
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Nomer Rak',
                ),
              ),
              // spacer
              SizedBox(height: 5.0),
              // text field
              TextField(
                controller: _namaProdukController,
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Nama Produk',
                ),
              ),

              // Dropdown
              new Container(
                padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    new Text("Kategori: ", style: new TextStyle(fontSize: 15.0)),
                    new DropdownButton(
                      value: _currentCategory,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    )
                  ],
                ),
              ),

              // datepicker
              new Container(
                //padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Expired Date', style: new TextStyle(fontSize: 15.0)),
                      onPressed: () {
                        _showDatePicker();
                      },
                    ),
                    new Text("  $_datetime", style: new TextStyle(fontSize: 15.0)),
                  ],
                ),
              ),

              //QR Code Reader

              new Container(
                child: new Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Barcode', style: new TextStyle(fontSize: 15.0)),
                      onPressed: () {
                        _scan();
                      },
                    ),
                    new Text(" $barcode", style: new TextStyle(fontSize: 15.0)),
                  ],
                ),
              ),


              // Radio
              new Container(
                //padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Discount',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Non Discount',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),

              // button
              RaisedButton(
                child: Text('SIMPAN'),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the user has typed in using our
                        // TextEditingController
                        content: Text('Nomer Rak: ${_nomerRakController.text}\n'+
                            'Produk: ${_namaProdukController.text}\n'+
                            'Kategori: $_currentCategory\n' +
                            'Expired Date: $_datetime\n' +
                            'Scan Code: $barcode\n' +
                            'Radio: $_radioValue1'),
                      );
                    },
                  );
                },
              ),
            ],
          )
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Entry Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new EntryData(),
    );
  }
}
//Main Program



/*

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Qrcode Scanner Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.memory(bytes),
              ),
              Text('RESULT  $barcode'),
              RaisedButton(onPressed: _scan, child: Text("Scan")),
              RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
              RaisedButton(onPressed: _generateBarCode, child: Text("Generate Barcode")),
            ],
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }

  Future _generateBarCode() async {
    Uint8List result = await scanner.generateBarCode('assakum cok');
    this.setState(() => this.bytes = result);
  }
}*/ //Barcode Reader and Generate Barcode
