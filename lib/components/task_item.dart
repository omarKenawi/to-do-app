import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:flutter_dismissible_tile/flutter_dismissible_tile.dart';
class taskItem extends StatelessWidget {
  Map task;
  IconData? icon;
  taskItem({Key? key, required this.task,required context,required IconData this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissibleTile(
      key:Key(task['id'].toString()) ,
      padding: const EdgeInsets.symmetric(vertical: 8),
      borderRadius: const BorderRadius.all(Radius.circular(16)),

      rtlDismissedColor:AppCubit.get(context).currentIndex==2? Color(0xffffd700):Colors.grey[500],
      ltrDismissedColor: Colors.redAccent,
      rtlOverlay: AppCubit.get(context).currentIndex==2? const Text('to do'):const Text('Archive'),
      rtlOverlayDismissed: AppCubit.get(context).currentIndex==2? const Text('new task'):const Text('Archived'),
      ltrOverlay: const Text('Delete'),
      ltrOverlayDismissed: const Text('Deleted'),
      child: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.deepPurple,
                child: Text('${task['time']}',style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${task['title']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text('${task['date']}', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDatabase(status: 'done', id: task['id']);
                },
                icon: Icon(icon,color: Colors.green),
              ),
            ],
          ),
        ),
      ),
      onDismissed:(direction){
        if(direction.toString()=="DismissibleTileDirection.rightToLeft"){
          if(task['status']=='archived'){
            AppCubit.get(context).updateDatabase(status: 'new', id: task['id']);
          }else {
            AppCubit.get(context).updateDatabase(status: 'archived', id: task['id']);
          }
        }else {
          AppCubit.get(context).deleteDatabase(id: task['id']);
        }

      } ,
    );
  }
}
