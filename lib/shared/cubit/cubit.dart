import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import '../../modules/archived_tasks_page.dart';
import '../../modules/done_tasks_page.dart';
import '../../modules/new_tasks_page.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  var database;
  List<Widget> screens = [const NewTasksPage(), const DoneTasksPage(), const ArchivedTasksPage()];
  List<String> texts = ['Tasks', 'Done Tasks', 'Archived Tasks'];
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState(@required bool show, IconData icon) {
    isBottomSheetShow = show;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  Future<void> createDatabase() async {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        try {
          await database.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
          print('database created');
          emit(AppCreateDataBaseState());
          print('table created');
        } catch (error) {
          print('error ${error.toString()}');
        }
      },
      onOpen: (database) {
        print('database opened');
        getFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({required title, required date, required time}) async {
    await database.transaction((txn) async {
      try {
        int idx = await txn.rawInsert(
            'INSERT INTO tasks(title, date, time,status) VALUES("${title} ", "${date}", "${time}","new")');
        print('inserted row:${idx}');
        emit(AppInsertDataBaseState());
        getFromDatabase(database);
      } catch (error) {
        print('error when insert new row ${error.toString()}');
      }
    });
  }

 void getFromDatabase(database) {
    emit(AppChangeLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then(
          (value) {
            newTasks=[];
            archivedTasks=[];
            doneTasks=[];
        value.forEach((element) {
          if(element['status']=='new'){
            newTasks.add(element);
          }else if(element['status']=='done'){
            doneTasks.add(element);
          }else{
            archivedTasks.add(element);
          }
        });
        emit(AppGetDataBaseState());
      },
    );
  }

  Future<void> updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value){
      emit(AppUpdateDataBaseState());
      getFromDatabase(database);

    }
    );
  }
  Future<void> deleteDatabase({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value){
      emit(AppDeleteDataBaseState());
      getFromDatabase(database);

    }
    );
  }
}
