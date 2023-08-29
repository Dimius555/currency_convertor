import 'package:currency_convertor/cubits/convertor/convertor_cubit.dart';
import 'package:currency_convertor/repositories/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ConvertorCubit, ConvertorState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                ConvertorCubit.read(context).test();
              },
              child: const Text('Press'),
            ),
          );
        },
      ),
    );
  }
}
