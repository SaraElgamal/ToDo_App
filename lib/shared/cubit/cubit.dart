import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/archive/archive.dart';
import 'package:todo_list/models/done/done.dart';
import 'package:todo_list/models/tasks/tasks.dart';
import 'package:todo_list/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentB = 0;
  List<Widget> screen = [
    Tasks(),
    Done(),
    Archive(),
  ];
  List<String> title = [
    ' Tasks',
    'Done' ,
    'Archive',
  ];
  List <Map> newTasks = [];
  List <Map> doneTasks = [];
  List <Map> archiveTasks = [];
void Change(int index){
  currentB=index;
  emit(AppChangeBottomNav());
}
 Database database;
  void createDatabase()  {
    openDatabase(
        'todo.db',
        version: 1,
        //1.create db
        onCreate: (database , version) {
          print ('database created');
          //2.create table

          //id integer
          //title string
          //date string
          //time string
          //status string
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value)
          {
            print('table created');
          } ).catchError((error){
            print('error${error.toString()}');
          } );
        },
        onOpen: (database){
          //get db
          getDatabase(database);
          print ('database opened');
        }
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }
  IconData iconBottom = Icons.edit;

  bool isBottomShow = false;
   insertDatabase (

      {

        @required String title,
        @required String time,
        @required String date,
      }
      ) async {


   await   database.transaction(( txn) async
    {
      await    txn
          .rawInsert('INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")',
      )
          .then((value){
        print ('$value inserted success');

        changeBottomSheet(isShown: false, iconShow: Icons.edit);

    emit(AppInsertDatabaseState());
        getDatabase(database);

      }).catchError((error){
        print('error tooooo ${error.toString()}');
      });
      return null;
    });
  }
   void getDatabase(database)  {

     newTasks = [];
     doneTasks = [];
     archiveTasks = [];
     emit(AppDatabaseLoadingState());
   database.rawQuery('SELECT * FROM tasks').then((value){
     value.forEach((element){
       if(element['status'] == 'new')
         newTasks.add(element);
       else if(element['status'] == 'done')
         doneTasks.add(element);
       else
         archiveTasks.add(element);
     });
    /* newTasks = value;
     print (newTasks);*/

     emit(AppGetDatabaseState());

   });

  }
    void updateDatabase({
  @required String status,
  @required int id,
}){
     database.rawUpdate(
          'UPDATE tasks SET status = ? WHERE id = ?',
          ['$status', id]).then((value)
     {
       getDatabase(database);
      emit(AppUpdateDatabaseState());

     });
    }
    void deleteTasks({
      @required int id,
}){
      database
          .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
        getDatabase(database);
        emit(AppDeleteDatabaseState());
      });
    }
  void changeBottomSheet ({
  @required bool isShown,
  @required IconData iconShow,

}) {
    isBottomShow = isShown;
    iconBottom = iconShow;

    emit(AppChangeBottomSheetState());

  }
}

