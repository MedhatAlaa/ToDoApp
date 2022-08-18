import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/components/bloc_observer.dart';
import 'package:to_do/components/themes.dart';
import 'package:to_do/cubit/cubit.dart';
import 'package:to_do/cubit/states.dart';
import 'package:to_do/layout/home_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            themeMode: AppCubit.get(context).tm,
            home: ToDoHomeScreen(),
          );
        },
      ),
    );
  }
}
