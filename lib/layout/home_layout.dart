import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

// ignore: camel_case_types
class homePage extends StatelessWidget {
  var timeController = TextEditingController();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.deepPurple,
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text(cubit.texts[cubit.currentIndex]),
            ),
            body: state is! AppChangeLoadingState
                ? cubit.screens[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              // shape: OutlineInputBorder(borderRadius:BorderRadius.circular(50)),
              backgroundColor: Colors.deepPurple,
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    )
                        .then(
                      (value) {
                        titleController = TextEditingController();
                        dateController = TextEditingController();
                        timeController = TextEditingController();
                        Navigator.pop(context);
                        cubit.changeBottomSheetState(false, Icons.edit);
                      },
                    );
                  }
                } else {
                  cubit.changeBottomSheetState(true, Icons.add);
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 5, left: 5),
                                      child: TextFormField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          label: Text('Task title'),
                                          prefixIcon: Icon(Icons.title),
                                          hintText: "Enter the task",
                                          contentPadding: EdgeInsets.all(20),
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter correct name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onFieldSubmitted: (newValue) {
                                          titleController.text =
                                              newValue.toString();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 5, left: 5),
                                      child: TextFormField(
                                        controller: timeController,
                                        decoration: const InputDecoration(
                                          label: Text('Task Time'),
                                          prefixIcon:
                                              Icon(Icons.access_time_outlined),
                                          hintText: "Enter the time",
                                          contentPadding: EdgeInsets.all(20),
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            if (value == null) return;
                                            timeController.text = value
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter correct name';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 5, left: 5),
                                      child: TextFormField(
                                        controller: dateController,
                                        decoration: const InputDecoration(
                                          label: Text('Task date'),
                                          prefixIcon: Icon(
                                              Icons.calendar_month_outlined),
                                          hintText: "Enter the date",
                                          contentPadding: EdgeInsets.all(20),
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2023-10-15"),
                                          ).then(
                                            (value) {
                                              if (value == null) {
                                                return;
                                              }
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value)
                                                      .toString();
                                            },
                                          );
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter correct name';
                                          } else
                                            return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          shape: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))))
                      .closed
                      .then((value) {
                    print(AppCubit().database);
                    cubit.changeBottomSheetState(false, Icons.edit);
                  });
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.deepPurple,
              color: Colors.deepPurple.shade200,
              height: 60,
              items: const [
                Icon(Icons.task,color: Colors.white,),
                Icon(Icons.done_outline,color: Colors.white,),
                Icon(Icons.archive_outlined,color: Colors.white,),
              ],
              // type: BottomNavigationBarType.fixed,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
