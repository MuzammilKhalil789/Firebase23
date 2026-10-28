//-- state management--> (halat)

//-> button click-=> condiiton-> 1st show a butotn then showing a loading

//-> setstate-> refresh the screen 
//-> 1000 lines of code--> withthe help setstate - all 1000 lines refreshing the screen--> performance issue

//->disadvantage of setstate-> performance issue-> app slow down

//-solution-> state management-> only refresh the widget which is changed not the whole screen


// controller                                                                                  UI/screen
// manage the values of the data which wnant to manage for the update/refresh the screen


//--? multiple state management-> setState ,provider(basic level), riverpod(upgraded version of provider),cubit(basic level), bloc(upgraded version of cubit), getx, mobx, , redux, etc




//--> for frontend -> we use 2 or classess
// screen (ui) and controller(for state manageemnt)
// screen (ui) and controller and  model (data flowing)

//-=> for backend-> we use 4 or classes
// screen (ui) and controller and  model (data flowing) and service (api call, database call,firebase etc)



import 'package:flutter/material.dart';

class StateManagementScreen extends StatefulWidget {
  const StateManagementScreen({super.key});

  @override
  State<StateManagementScreen> createState() => _StateManagementScreenState();
}

class _StateManagementScreenState extends State<StateManagementScreen> {
  

 
StatemanageentCOntroller controller=Get.put(StatemanageentCOntroller()); //controller object
  @override

  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(()=>Text(
              '${controller.count.value}',
              style: Theme.of(context).textTheme.headline4,
            ),)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


class StatemanageentCOntroller extends GetController
{
    var count=0.obs; //observable variable

    var age=20.obs; //observable variable
     void incrementCounter() {
   
      count.value++;
      age.value=21;
  
  }
  void decrmentCounter() {
   
      count.value--;
  
  }
}