import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';



class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}


const String URI = "http://192.168.43.246:3000/";
class _FirstPageState extends State<FirstPage> {

  List<String> lItems = [];
  final TextEditingController eCtrl = new TextEditingController();

  _connect () async{
    SocketIO socket = await SocketIOManager().createInstance(SocketOptions(URI));
    var url = 'http://192.168.43.246:3000/arduino/on/';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    socket.onConnect((data){
      print("connected...");
      print(data);
      lItems.add(data);
      eCtrl.clear();
      setState(() {});
    });
    socket.on('moisture',(data){
      print(data);
    });
    socket.on("proximity",(data){
      print(data);

    });
    socket.connect();

  }

  void _logout() async{
    bool logout = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login',logout);
    var route = new MaterialPageRoute(
        builder: (BuildContext context)=>new MyHomePage()
    );
    Navigator.of(context).push(route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Farm Automation'),
      ),
      drawer: Drawer(
        child:Container(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                accountName: Text("Ayush Verma"),
                accountEmail: Text("ayushverma1129av@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white60,
                  child: Text('AV'),
                ),
              ),
              ListTile(
                title: Text("Home",
                    style: TextStyle(fontWeight: FontWeight.bold,)),
                trailing: Icon(Icons.home,color: Colors.black,),
              ),
              ListTile(
                title: Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold,)),
                trailing: Icon(Icons.card_travel,color: Colors.black,),

              ),

              Divider(),

              ListTile(
                title: Text("SignOut",
                  style: TextStyle(fontWeight: FontWeight.bold,),),
                trailing: Icon(Icons.close,color: Colors.black,),
                onTap:_logout,
              ),
            ],
          ),
        ),),
      body:
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          image: DecorationImage(

            fit: BoxFit.cover,
            //colorFilter: new ColorFilter.mode(Colors.black54, BlendMode.darken),
            image: AssetImage("assets/girl.png"),


          ),
        ),
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 40.0)
              ),
//        new Expanded(
//            child: new ListView.builder
//              (
//                itemCount: lItems.length,
//                itemBuilder: (BuildContext context, int Index) {
//                  return new Text(lItems[Index]);
//                }
//            )
//        ),
              new MaterialButton(
                height: 50.0,
                minWidth: 150.0,
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                splashColor: Colors.teal,
                textColor: Colors.white,
                child: new Text("Connect",
                  style: TextStyle(fontWeight:FontWeight.bold,fontFamily: 'Lato' ),),
                onPressed: () {
                  _connect();
                  },
              ),

            ],
          ),
        ),),

    );
  }


}



