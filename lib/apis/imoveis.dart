import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>?> listarImoveis() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/imoveis.php?acao=listar_imoveis",
    );

    final resposta = await http.get(uri);

    if (resposta.statusCode != 200) {
      print("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      print("Resposta não é JSON");
      print(resposta.body);
      return null;
    }

    final data = jsonDecode(resposta.body);

    
    for (final imovel in data) {
      final anuncio = imovel["anuncio"];

      if (anuncio != null && anuncio["imagens"] != null) {
        final imagens = anuncio["imagens"] as List<dynamic>;

        for (int i = 0; i < imagens.length; i++) {
          imagens[i] = "http://10.0.2.2${imagens[i]}";
        }
      }
    }


    print(data.runtimeType);
    print(data);

    return data as List<dynamic>;
  } catch (e) {
    print("Erro: $e");
    return null;
  }
}