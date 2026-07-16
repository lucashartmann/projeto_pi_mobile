import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>?> listarUsuarios() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/usuarios.php?acao=listar",
    );
    final resposta = await http.get(uri);

    if (resposta.statusCode != 200) {
      print("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    if (resposta.body == null || resposta.body.isEmpty) {
      print("Resposta vazia do servidor");
      return null;
    }

    if (resposta.headers["content-type"] == null ||
        !resposta.headers["content-type"]!.contains("application/json")) {
      print("Resposta não é JSON");
      print(resposta.body);
      return null;
    }

    final dados = jsonDecode(resposta.body);

    return dados;
  } catch (erro) {
    print("Falha ao conectar com o backend: $erro");
    return null;
  }
}
