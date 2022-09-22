
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';

import '../../shared/component/component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Archive extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).archiveTasks;
          return taskBuilder(tasks:tasks ); }
    );
  }
}
