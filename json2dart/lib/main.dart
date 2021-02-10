import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Json2Dart [mc Package]',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'Json to Dart for mc Package'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({this.title});
  final TextEditingController data = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController result = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.05),
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: MediaQuery.of(context).size.height * 0.05,
            children: [
              MyTextField(
                data,
                hint: 'Here your json data',
                help:
                    "Example \n[{'first_name':'Mohammed','last_name':'chahboun'}]",
                label: 'Json Data',
                icon: Icons.data_usage,
              ),
              MyTextField(
                name,
                hint: 'Here your Model name',
                help: 'Default name MyModel',
                label: 'Model name',
                icon: Icons.title,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.08,
                child: FlatButton(
                  color: Colors.brown,
                  child: Text(
                    "Convert",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    result.text = json2Dart(data.text, name.text);
                  },
                ),
              ),
              MyTextField(
                result,
                hint: 'Here your Model for mc package',
                label: 'Result',
                icon: Icons.restore_outlined,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _launchURL("https://pub.dev/packages/mc"),
                    child: Text("[mc Package]", style: stl),
                  ),
                  InkWell(
                    onTap: () => _launchURL("https://github.com/M97Chahboun"),
                    child: Text("[Github]", style: stl),
                  ),
                  InkWell(
                    onTap: () => _launchURL("https://chahboun.dev"),
                    child: Text("[Portfolio]", style: stl),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle stl = TextStyle(
      fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.brown);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String json2Dart(String inputUser, String className) {
    className = className.isEmpty ? "MyModel" : className;
    try {
      List jsonInputUser = json.decode(inputUser);
      String data = "";
      String parameters = "";
      String fromVar = "";
      String toVar = "";
      for (Map i in jsonInputUser) {
        for (String u in i.keys) {
          String t = i[u].runtimeType.toString();
          data += """ $t $u;\n""";
          parameters += """  this.$u,\n""";
          fromVar += "  $u = json['$u'] ?? $u;\n";
          toVar += "  data['$u'] = this.$u;\n";
        }
        break;
      }
      data += " List multi = [];\n";
      fromVar += "  return super.fromJson(json);\n";
      String multi = """\n\nvoid setMulti(List d) {
    List r = d.map((e) {
      $className m = $className();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }\n""";
      String toJson =
          " Map<String, dynamic> toJson() {\n final Map<String, dynamic> data = new Map<String, dynamic>();";
      String fromJson = " fromJson(Map<String, dynamic> json) {";
      String class_ = "class $className extends McModel{\n";
      String constractor = " $className({";
      String model = class_ +
          data +
          "\n" +
          constractor +
          "\n" +
          parameters +
          " });\n" +
          "\n" +
          fromJson +
          "\n" +
          fromVar +
          " }" +
          "\n\n" +
          toJson +
          "\n" +
          toVar +
          "\n" +
          "  return data;" +
          "\n }" +
          multi +
          "\n" +
          "}";
      print(model);
      return model;
    } catch (e) {
      print("[-] $e");
      return "[-Error] $e";
    }
  }
}

class MyTextField extends StatelessWidget {
  final String hint, help, label;
  final IconData icon;
  final TextEditingController controller;
  MyTextField(this.controller,
      {Key key, this.hint, this.help, this.label, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
          controller: controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: hint,
            helperText: help,
            labelText: label,
            prefixIcon: Icon(
              icon,
              color: Colors.brown,
            ),
          )),
    );
  }
}