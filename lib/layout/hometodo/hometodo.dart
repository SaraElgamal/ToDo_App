import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/archive/archive.dart';
import 'package:todo_list/models/done/done.dart';
import 'package:todo_list/models/tasks/tasks.dart';
import 'package:todo_list/shared/component/component.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';


class hometodo extends StatelessWidget {



  var scaffoldKey = GlobalKey<ScaffoldState>();



  var textController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {

          if ( state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentB],
                style: TextStyle(color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,),
              ),
            ),
            body:
            ConditionalBuilder(
              condition: state is! AppDatabaseLoadingState,
              builder: (context) => cubit.screen[cubit.currentB],
              fallback: (context) => Center(child: CircularProgressIndicator()),

            ),

            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.iconBottom),
              onPressed: () {
                if (cubit.isBottomShow) {
                  if (formKey.currentState.validate()) {
                    print('mamy');
                    cubit.insertDatabase(
                      title: textController.text,
                      time: timeController.text,
                      date: dateController.text,

                    );/*.then((value) {
                      cubit.changeBottomSheet(isShown: false, iconShow: Icons.edit);
                    }).catchError((error) {
                      print('errrrrrorrr here ${error.toString()}');
                    });*/
                  }
                }
                else {
                  scaffoldKey.currentState.showBottomSheet(
                          (context) =>

                          Container(
                            width: double.infinity,


                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(

                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultField(
                                      controller: textController,
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                      label: 'Task title',
                                      prefix: Icons.title,
                                      keyboard: TextInputType.text),
                                  SizedBox(height: 15.0,),
                                  defaultField(
                                      controller: timeController,
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      },
                                      label: 'Task time',
                                      prefix: Icons.watch_later_outlined,
                                      onTap: () {
                                        showTimePicker(context: context,
                                            initialTime: TimeOfDay.now()).then((
                                            value) {
                                          print(value.format(context));
                                          timeController.text =
                                              value.format(context);
                                        });
                                      },
                                      keyboard: TextInputType.datetime),
                                  SizedBox(height: 15.0,),
                                  defaultField(
                                      controller: dateController,
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return 'Date must not be empty';
                                        }
                                        return null;
                                      },
                                      label: 'Task Date',
                                      prefix: Icons.calendar_today,
                                      onTap: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse(
                                                '2023-05-28')).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                      keyboard: TextInputType.datetime),
                                ],
                              ),
                            ),
                          ),
                      elevation: 30.0)
                  //عشان اقفل البوتوم شيت
                      .closed.then((value) {

                  cubit.changeBottomSheet(isShown: false, iconShow: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShown: true, iconShow: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentB,
              onTap: (index) {
                cubit.Change(index);

              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.assignment,
                ), label: 'Tasks',),
                BottomNavigationBarItem(
                    icon: Icon(Icons.cloud_done_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),

              ],


            ),
          );
        },
      ),
    );
  }

}