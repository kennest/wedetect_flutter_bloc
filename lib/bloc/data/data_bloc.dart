import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedetect/repository/repository.dart';

class DataBloc extends Bloc<String, List<dynamic>> {
  final AlertRepository alertRepository;
  final UserRepository userRepository;
  final DiagnosticRepository diagnosticRepository;

  DataBloc({ this.alertRepository,@required this.userRepository,this.diagnosticRepository});
  @override
  List<dynamic> get initialState => [];

  @override
  Stream<List<dynamic>> mapEventToState(
      List<dynamic> currentState, String event) async* {
    if (event == 'load_alerts') {
      await alertRepository.getAlerts();
      yield alertRepository.alerts;
    }
  }
}
