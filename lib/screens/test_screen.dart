import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/test_controller.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({ Key? key }) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var testControllert = TestController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title:  Text('Users Lists',style: TextStyle(color: Colors.white) ,),
        centerTitle: true,
      ),
      body: Obx(
        ()=> Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              
              Text('User: ${testControllert.user.value.name ??'No User'}'),
          
             //  testControllert.isLoading.value ? CircularProgressIndicator() : ElevatedButton(onPressed: ()=> testControllert.getUser(), child: Text('Get User')),
             testControllert.isLoading.value ? CircularProgressIndicator() : ElevatedButton(onPressed: ()=> testControllert.getAllUsers(), child: Text('Get   All User User')),
          
            Expanded(
              child: Obx(
                (){
          
                  if(testControllert.isLoading.value){
                    return CircularProgressIndicator();
                    }
                  if(testControllert.users.isEmpty){
                    return Text('No Users');
                  }
                  return ListView.builder(
                  itemCount: testControllert.users.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8,),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.grey),)
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('test ${testControllert.users[index].email}'));
                  });
                } ,
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}