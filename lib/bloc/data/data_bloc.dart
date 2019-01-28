import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedetect/models/alert.dart';
import 'package:wedetect/repository/repository.dart';

class AlertBloc extends Bloc<String, List<Alert>> {
  final AlertRepository alertRepository;
  final UserRepository userRepository;

  AlertBloc({@required this.alertRepository, this.userRepository});
  @override
  List<Alert> get initialState => [];

  @override
  Stream<List<Alert>> mapEventToState(
      List<Alert> currentState, String event) async* {
    if (event == 'load_alerts') {
      await alertRepository.getAlerts();
      yield alertRepository.alerts;
    }
  }
}
