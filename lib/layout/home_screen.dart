import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do/cubit/cubit.dart';
import 'package:to_do/cubit/states.dart';

class ToDoHomeScreen extends StatelessWidget {
  ToDoHomeScreen({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                onPressed: () {
                  cubit.changeThemes();
                },
                icon: Icon(
                  cubit.iconData,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModelSheet(context);
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            backgroundColor: cubit.isDark ? Colors.black : Colors.white,
            color: cubit.isDark ? Colors.teal : Colors.grey,
            buttonBackgroundColor: Colors.pink,
            items: const [
              Icon(Icons.menu),
              Icon(Icons.check_circle),
              Icon(Icons.archive),
            ],
          ),
        );
      },
    );
  }

  void showModelSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Title Must not be empty';
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.title),
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: timeController,
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      timeController.text = value!.format(context).toString();
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Time Must not be empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.watch_later),
                    labelText: 'Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: dateController,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate:  DateTime(2050),
                    ).then((value) {
                      dateController.text = DateFormat.yMMMd().format(value!);
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Date Must not be empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() => {
          AppCubit.get(context).insertDataToDataBase(
              date: dateController.text,
              time: timeController.text,
              title: titleController.text),
        });
  }
}
