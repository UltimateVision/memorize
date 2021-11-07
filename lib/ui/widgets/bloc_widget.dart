import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocWidget<B extends Bloc> extends StatefulWidget {
  final B bloc;

  const BlocWidget(this.bloc, {Key? key}) : super(key: key);

  @override
  BlocWidgetState<B> createState() => BlocWidgetState<B>(bloc);

  void initState() {}

  Widget build(BuildContext context);
}

class BlocWidgetState<B extends Bloc> extends State<BlocWidget<B>> {
  final B bloc;

  BlocWidgetState(this.bloc);

  @override
  void initState() {
    super.initState();
    widget.initState();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<B>(
    create: (context) => bloc,
    child: widget.build(context),
  );

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}
