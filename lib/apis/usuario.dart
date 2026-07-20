import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic usuarioLogado;
List imoveisCurtidos = [];
bool logado = false;

dynamic salvarImoveisCurtidos() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/login.php?acao=favoritar_imoveis",
    );
    final resposta = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_imoveis": imoveisCurtidos}),
    );

    if (resposta.statusCode != 200) {
      print("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    if (resposta.body.isEmpty) {
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

    carregarUser();
    print("Imóveis curtidos salvos com sucesso! $dados.mensagem");
  } catch (err) {
    print("Erro ao salvar imóveis curtidos: $err");
  }
}

// dynamic curtirImovel(event, imovelId) async{
//     if (!logado) {
//         if (!usuarioLogado) {
//             print ("Você precisa estar logado para curtir um imóvel!");
//             return;
//         }
//         else {
//             logado = true;
//         }
//     }
//     if (imoveisCurtidos.includes(imovelId)) {
//         imoveisCurtidos.splice(imoveisCurtidos.indexOf(imovelId), 1);
//         print("Imóvel removido dos curtidos: $imoveisCurtidos");
//         event.target.classList.remove("curtido");
//         return;
//     }
//     imoveisCurtidos.push(imovelId);
//     event.target.classList.toggle("curtido");
//     event.stopPropagation();
// }

dynamic deslogar() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/login.php?acao=deslogar",
    );
    final resposta = await http.get(uri); // http.post(uri)
    if (resposta.statusCode != 200) {
      print("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    if (resposta.body.isEmpty) {
      print("Resposta vazia do servidor");
      return null;
    }

    if (resposta.headers["content-type"] == null ||
        !resposta.headers["content-type"]!.contains("application/json")) {
      print("Resposta não é JSON");
      print(resposta.body);
      return null;
    }

    usuarioLogado = null;
    imoveisCurtidos = [];

    print("Deslogado com sucesso!");
  } catch (erro) {
    print("Falha ao conectar com o backend: $erro");
    return null;
  }
}

Future<List<dynamic>?> carregarUser() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/login.php?acao=get_usuario",
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

    final dados = jsonDecode(resposta.body);

    usuarioLogado = dados.usuario;
    if (usuarioLogado.tipo && usuarioLogado.tipo == "CLIENTE") {
      imoveisCurtidos = dados.imoveis ?? [];
    }
    return dados as List<dynamic>;
  } catch (e) {
    print("Falha ao conectar com o backend: $e");
    return null;
  }
}
