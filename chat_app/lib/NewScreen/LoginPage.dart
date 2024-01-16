import 'package:chat_app/Model/CountryModel.dart';
import 'package:chat_app/NewScreen/CountryPage.dart';
import 'package:chat_app/NewScreen/OtpScreen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String countryName = "India";
  String countryCode = "+91";
  TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Enter your phone number",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
            wordSpacing: 1,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "Whatsapp will send an sms message to verify your number",
              style: TextStyle(
                fontSize: 13.5,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "What's my number",
              style: TextStyle(fontSize: 12.8, color: Colors.cyan[800]),
            ),
            SizedBox(
              height: 15,
            ),
            countryCard(),
            SizedBox(
              height: 5,
            ),
            number(),
            Expanded(child: Container()),
            InkWell(
              onTap: (){
                if(_controller.text.length < 10){
                  showMyDialogue1();
                }else{
                  showMyDialogue();
                }
              },
              child: Container(
                color: Colors.tealAccent[400],
                height: 40,
                width: 70,
                child: Center(
                  child: Text('NEXT', style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget countryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CountryPage(setCountryData: setCountryData)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.teal,
            width: 1.8,
          ),
        )),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    countryName,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.teal,
              size: 28,
            )
          ],
        ),
      ),
    );
  }

  Widget number(){
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 38,
      child: Row(
        children: [
          Container(
            width: 70,
            decoration: BoxDecoration(
              border:  Border(
                bottom: BorderSide(
                  color: Colors.teal,
                  width: 1.8
                ),
              )
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("+", style: TextStyle(
                    fontSize: 18
                  ),),
                ),
                SizedBox(width: 10,),
                Text(countryCode.substring(1), style: TextStyle(
                  fontSize: 15
                ),)
              ],
            ),
          ),
          SizedBox(width: 15,),
          Container(
            decoration: BoxDecoration(
                border:  Border(
                  bottom: BorderSide(
                      color: Colors.teal,
                      width: 1.8
                  ),
                )
            ),
            width: MediaQuery.of(context).size.width / 1.5 - 100,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
                hintText: "Phone number"
              ),
            ),
          )
        ],
      ),
    );
  }

  void setCountryData(CountryModel countryModel){
    setState(() {
      countryName = countryModel.name;
      countryCode = countryModel.code;
    });
    Navigator.pop(context);
  }
  
  Future<void> showMyDialogue(){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text("We will be veryfying your phone number", style: TextStyle(
                fontSize: 14
              ),),
              SizedBox(height: 10,),
              Text(countryCode + " " + _controller.text, style: TextStyle(
                  fontSize: 14,
                fontWeight: FontWeight.w500
              )),
              SizedBox(height: 10,),
              Text("Is this oke, or would you like to edit the number ? ", style: TextStyle(
                  fontSize: 13.5
              ))
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Edit")),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Ok"))
        ],
      );
    });
  }

  Future<void> showMyDialogue1(){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text("There is no number entered", style: TextStyle(
                  fontSize: 14
              ),),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen(
              number: _controller.text,
              countryCode: countryCode,
            )));
          }, child: Text("Ok"))
        ],
      );
    });
  }

}
