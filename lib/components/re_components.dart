import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor:
                  AppCubit.get(context).isDark ? Colors.teal : Colors.pink,
              child: Text(
                '${model['time']}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: AppCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDataBase(
                  status:'Done',
                  id: model['id'],
                );
              },
              icon: const Icon(Icons.check_box,color: Colors.green,),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDataBase(
                  status:'Archived',
                  id: model['id'],
                );
              },
              icon: const Icon(Icons.archive,color: Colors.yellow),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDataFromDataBase(id: model['id']);
      },
    );

Widget buildConditional(tasks) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (BuildContext context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Container(
          height: 3.0,
          width: double.infinity,
          color: Colors.grey[200],
          margin: const EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        itemCount: tasks.length,
      ),
      fallback: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'No Tasks Yet,Please Add Some Tasks',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        );
      },
    );
