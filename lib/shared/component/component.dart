
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

Widget defaultButton({
  double width =  double.infinity,
  double height = 40.0,
  double radius = 0.0,
  Color color= Colors.blue,
  bool isUpperCase = true,
  @required String text,
  @required Function function,
}) =>  Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadiusDirectional.all(Radius.circular(radius), ),
    color: color,
  ),
  width: width,
  height: height,

  child: MaterialButton(
    onPressed: function,
    child: Text(isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(color: Colors.white,
          fontSize: 20.0),),

  ),
);

Widget defaultField( {
  @required TextEditingController controller,
  Function onSubmitted,
  bool isPassword = false ,
  @required Function validate,
  @required  String label,
  @required IconData prefix,
  IconData suffix,
  Function onpresseds,
  Function onTap,
  @required TextInputType keyboard,
}) => TextFormField(

  controller: controller,
  keyboardType: keyboard,
  obscureText: isPassword,

  onFieldSubmitted: onSubmitted,
  onTap: onTap,
  validator: validate,
  decoration: InputDecoration(

    labelText: label,
    prefixIcon: Icon(prefix),
    suffixIcon: suffix != null ? IconButton(icon : Icon (suffix) , onPressed: onpresseds,) : null ,
    border: OutlineInputBorder(),


  ),
);
Widget buildTasksItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),

  onDismissed: (direction){

  AppCubit.get(context).deleteTasks(id: model['id']);
  },
  child:   Padding(

    padding: const EdgeInsets.all(14.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 36.0,

          child: Text('${model['time']}'),

        ),

        SizedBox(width: 14.0,),

        Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text('${model['title']}',

              style: TextStyle(

                fontWeight: FontWeight.bold,

              ),

            ),

            Text('${model['date']}',

              style: TextStyle(

             color: Colors.grey,

              ),

            ),

          ],

        ),

        Spacer(),

        IconButton(onPressed: (){

          AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);

        }, icon: Icon(Icons.check_box,

        color: Colors.green,

        )),

        IconButton(onPressed: (){

          AppCubit.get(context).updateDatabase(status: 'archive', id: model['id']);

        }, icon: Icon(Icons.archive,

          color: Colors.black26,

        )),

      ],

    ),

  ),
);
 Widget myDivider() => Container(

   margin: EdgeInsets.only(
     left: 20.0,
     right: 20.0,
   ),
   height: 1.0,
   width: double.infinity,
   color: Colors.grey[300],
 );

 Widget taskBuilder({@required  List<Map> tasks}) => ConditionalBuilder(
   condition: tasks.length > 0,
   builder: (context) => ListView.separated(
     itemBuilder: (context, index) => buildTasksItem(tasks[index],context),
     separatorBuilder:  (context, index) =>  myDivider(),
     itemCount: tasks.length,),
   fallback: (context) => Center(

     child: Column(

       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(Icons.task,
           size: 70.0,
           color: Colors.grey,),
         SizedBox(height: 20.0,),
         Text('No Tasks yet, please add some tasks',
           style: TextStyle(fontSize: 18.0,
             color: Colors.grey,
           ),),
       ],
     ),
   ),
 );