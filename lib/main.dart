import 'package:dio/dio.dart';
import 'package:e_commerce/app/my_app.dart';
import 'package:e_commerce/bloc/authentication/bloc.dart';
import 'package:e_commerce/bloc/profile/bloc.dart';
import 'package:e_commerce/domain/api_service.dart';
import 'package:e_commerce/domain/firestore_service.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/product/bloc.dart';
import 'data/conncetivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final Dio dio = Dio();
  final connectivityService = ConnectivityService(dio);
  final fireStoreService = FirestoreService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc()),
        BlocProvider(create: (context) => ProfileBloc(fireStoreService)),
        BlocProvider(
            create: (context) =>
                ProductBloc(api: ApiService(dio, connectivityService))),
      ],
      child: const MyApp(),
    ),
  );
}
