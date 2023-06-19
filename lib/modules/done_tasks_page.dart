import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import '../components/task_item.dart';
import '../shared/cubit/cubit.dart';

class DoneTasksPage extends StatelessWidget {
  const DoneTasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;
          return tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.menu, size: 100, color: Color(0xffffd700)),
                      Text(
                        'no tasks yet,add some tasks',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => taskItem(
                    task: tasks[index],
                    context: context,
                    icon: Icons.check_box,
                  ),
                  separatorBuilder: (context, index) => Container(
                    color: Colors.grey,
                    height: 1,
                  ),
                  itemCount: tasks.length,
                );
        });
  }
}
