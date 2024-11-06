import 'dart:convert';
import 'package:http/http.dart' as http;

class NameValidationResult {
  final bool isValid;
  final String? message;

  NameValidationResult({required this.isValid, this.message});
}

Future<NameValidationResult> ValidateNameWithAPI(String? name) async {
  final url =
      'https://api.nameapi.org/rest/v5.3/riskdetector/person?apiKey=e3c4907bd5593d0976a4a7973481a18b-user1'; // Replace with the correct endpoint
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    "inputPerson": {
      "type": "NaturalInputPerson",
      "personName": {
        "nameFields": [
          {"string": "$name", "fieldType": "FULLNAME"}
        ]
      }
    }
  });
try{
  final response =
  await http.post(Uri.parse(url), headers: headers, body: body);
  print(jsonDecode(response.body));
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    double score = jsonResponse['score'];
    print("score: $score");
    if (jsonResponse['score']>0) {
      return NameValidationResult(
          isValid: false,
          message: jsonResponse['worstRisk']?['riskType']??"Enter your real name");
    } else {
      return NameValidationResult(isValid: true, message: "Successful");
    }
  } else {
    return NameValidationResult(
        isValid: false, message: 'Error: ${response.statusCode}');
  }
} catch(e)
  {
    return NameValidationResult(
        isValid: false, message: 'Error: ${e}');
  }

}
