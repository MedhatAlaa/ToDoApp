import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/cubit/states.dart';
import 'package:to_do/modules/archived_tasks.dart';
import 'package:to_do/modules/done_tasks.dart';
import 'package:to_do/modules/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];
  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeBottomNav(index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  bool isDark = false;
  IconData iconData = Icons.light_mode;
  ThemeMode tm = ThemeMode.light;

  void changeThemes() {
    isDark = !isDark;
    iconData = isDark ? Icons.dark_mode : Icons.light_mode;
    tm = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(ChangeThemesState());
  }

  bool isBottomSheet = false;
  IconData fabIcon = Icons.edit;

  // void changeBottomSheet({
  //   required bool bottomSheet,
  //   required IconData icon,
  // }) {
  //   isBottomSheet = bottomSheet;
  //   fabIcon = icon;
  //   emit(ChangeBottomSheetState());
  // }

  Database? database;
  List newTasks = [];
  List doneTasks = [];
  List archivedTasks = [];

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
        'CREATE TABLE Tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)',
      )
          .then((value) {
        print('DataBase Created');
      }).catchError((error) {
        print('Error When Created The Table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print('DataBase Opened');
    }).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  void insertDataToDataBase({
    required String title,
    required String time,
    required String date,
  }) {
    database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO Tasks(title,time,date,status) VALUES("$title","$time","$date","new")',
      )
          .then((value) {
        emit(InsertDataToDataBaseState());
        print('$value Inserted successfully');
        getDataFromDataBase(database);
      }).catchError((error) {
        print('error on inserting table${error.toString()}');
      });
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database!.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDataFromDataBaseState());
    }).catchError((error) {
      print('error when getting the data${error.toString()}');
    });
  }

  void updateDataBase({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE Tasks SET status=? WHERE id=?',
      [status, id],
    ).then((value) {
      getDataFromDataBase(database);
      emit(UpdateDataFromDataBaseState());
      print(value);
    });
  }

  void deleteDataFromDataBase({required int id}) {
    database!.rawDelete('DELETE FROM Tasks WHERE id=?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(DeleteDataFromDataBaseState());
    });
  }
}
