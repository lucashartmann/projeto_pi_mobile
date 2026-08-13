import 'dart:convert';
import 'package:http/http.dart' as http;
import '.././apis/api.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AtendimentosCliente extends StatefulWidget {
  const AtendimentosCliente({super.key});

  @override
  State<AtendimentosCliente> createState() => _AtendimentosClienteState();
}

class _AtendimentosClienteState extends State<AtendimentosCliente> {
  List<dynamic> _atendimentos = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await listarAtendimentos();

    setState(() {
      _atendimentos = dados ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atendimentos')),
      body: Center(
        child: _atendimentos.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _atendimentos.length,
                itemBuilder: (context, index) {
                  final atendimento = _atendimentos[index] ?? [];
                  return Row(
                    children: [
                      Image.asset(
                        atendimento[index]['imovel']['anuncio']['imagens'][0],
                      ),
                      Column(
                        children: [
                          Text(
                            "Imovel: ${atendimento[index]['imovel']['anuncio']['titulo']}",
                          ),
                          Text(
                            "Status: ${atendimento[index]['imovel']['status']}",
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}

Future<List<dynamic>?> listarAtendimentos() async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}login.php?acao=get_atendimentos",
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

    final data = jsonDecode(resposta.body);

    for (final imovel in data) {
      final anuncio = imovel["anuncio"];

      if (anuncio != null && anuncio["imagens"] != null) {
        final imagens = anuncio["imagens"] as List<dynamic>;

        for (int i = 0; i < imagens.length; i++) {
          imagens[i] = "${dotenv.get('IPLOCAL')}${imagens[i]}";
        }
      }
    }

    return data as List<dynamic>;
  } catch (e) {
    debugPrint("Erro: $e");
    return null;
  }
}
