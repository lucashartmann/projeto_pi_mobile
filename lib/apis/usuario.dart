import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'package:flutter/foundation.dart';

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
      headers: {
        "Content-Type": "application/json",
        "Cookie": sessionCookie ?? "",
      },
      body: jsonEncode({"id_imoveis": imoveisCurtidos}),
    );

    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    if (resposta.body.isEmpty) {
      debugPrint("Resposta vazia do servidor");
      return null;
    }

    if (resposta.headers["content-type"] == null ||
        !resposta.headers["content-type"]!.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    final dados = jsonDecode(resposta.body);

    carregarUser();
    debugPrint("Imóveis curtidos salvos com sucesso! $dados.mensagem");
  } catch (err) {
    debugPrint("Erro ao salvar imóveis curtidos: $err");
  }
}

// dynamic curtirImovel(event, imovelId) async{
//     if (!logado) {
//         if (!usuarioLogado) {
//             debugPrint ("Você precisa estar logado para curtir um imóvel!");
//             return;
//         }
//         else {
//             logado = true;
//         }
//     }
//     if (imoveisCurtidos.includes(imovelId)) {
//         imoveisCurtidos.splice(imoveisCurtidos.indexOf(imovelId), 1);
//         debugPrint("Imóvel removido dos curtidos: $imoveisCurtidos");
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
    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    ); // http.post(uri)
    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    if (resposta.body.isEmpty) {
      debugPrint("Resposta vazia do servidor");
      return null;
    }

    if (resposta.headers["content-type"] == null ||
        !resposta.headers["content-type"]!.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    usuarioLogado = null;
    imoveisCurtidos = [];

    debugPrint("Deslogado com sucesso!");
  } catch (erro) {
    debugPrint("Falha ao conectar com o backend: $erro");
    return null;
  }
}

Future<Map<String, dynamic>?> carregarUser() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/login.php?acao=get_usuario",
    );

    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    );

    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    final dados = jsonDecode(resposta.body);

    if (dados["status"] == "erro") {
      debugPrint("Usuário não logado: ${dados["mensagem"]}");
      return null;
    }

    usuarioLogado = dados["usuario"];
    if (usuarioLogado["tipo"] != null && usuarioLogado["tipo"] == "CLIENTE") {
      imoveisCurtidos = dados["imoveis"] ?? [];
    }
    return dados;
  } catch (e) {
    debugPrint("Falha ao conectar com o backend: $e");
    return null;
  }
}
