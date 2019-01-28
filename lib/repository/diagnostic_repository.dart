import 'package:http/http.dart' as http;
class DiagnosticRepository{
  Future<bool> sendDiagnostic() async{
    var sended=await http.post('url',body: {}).then((r){

    });
    return sended;
  }
}