import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'package:projeto_pi_mobile/apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projeto_pi_mobile/apis/imoveis.dart';

class CadastroImovel extends StatefulWidget {
  const CadastroImovel({super.key});

  @override
  State<CadastroImovel> createState() => _CadastroImovelState();
}

class _CadastroImovelState extends State<CadastroImovel> {
  String _categoria = "";
  String _situacao = "";
  String _estado = "";
  String _ocupacao = "";
  String _status = "";

  final TextEditingController _refController = TextEditingController();
  final TextEditingController _nomeCondominioController =
      TextEditingController();
  final TextEditingController _anoConstrucaoController =
      TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _blocoController = TextEditingController();
  final TextEditingController _andarController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _salasController = TextEditingController();
  final TextEditingController _banheirosController = TextEditingController();
  final TextEditingController _vagasController = TextEditingController();
  final TextEditingController _varandasController = TextEditingController();
  final TextEditingController _quartosController = TextEditingController();
  final TextEditingController _suitesController = TextEditingController();
  final TextEditingController _areaTotalController = TextEditingController();
  final TextEditingController _areaPrivativaController =
      TextEditingController();
  final TextEditingController _valorVendaController = TextEditingController();
  final TextEditingController _valorAluguelController = TextEditingController();
  final TextEditingController _valorCondominioController =
      TextEditingController();
  final TextEditingController _valorIPTUController = TextEditingController();

  void salvar() async {
    Map<String, dynamic> imovel = {
      "ref": _refController.text,
      "categoria": _categoria,
      "situacao": _situacao,
      "estado": _estado,
      "ocupacao": _ocupacao,
      "status": _status,
      "nomeCondominio": _nomeCondominioController.text,
      "anoConstrucao": _anoConstrucaoController.text,
      "cep": _cepController.text,
      "rua": _ruaController.text,
      "numero": _numeroController.text,
      "complemento": _complementoController.text,
      "bloco": _blocoController.text,
      "andar": _andarController.text,
      "bairro": _bairroController.text,
      "cidade": _cidadeController.text,
      "uf": _ufController.text,
      "salas": _salasController.text,
      "banheiros": _banheirosController.text,
      "vagas": _vagasController.text,
      "varandas": _varandasController.text,
      "quartos": _quartosController.text,
      "suites": _suitesController.text,
      "areaTotal": _areaTotalController.text,
      "areaPrivativa": _areaPrivativaController.text,
      "valorVenda": _valorVendaController.text,
      "valorAluguel": _valorAluguelController.text,
      "valorCondominio": _valorCondominioController.text,
      "valorIPTU": _valorIPTUController.text,
    };

    if (imovel.isNotEmpty) {
      try {
        final uri = Uri.parse(
          "${dotenv.get('ADDRESS')}imoveis.php?acao=cadastrar",
        );

        final resposta = await http.post(
          uri,
          body: jsonEncode(imovel),
          headers: {
            "Content-Type": "application/json",
            "Cookie": sessionCookie ?? "",
          },
        );
        if (resposta.statusCode != 200) {
          debugPrint("Erro HTTP: ${resposta.statusCode}");
        }

        if (resposta.body.isEmpty) {
          debugPrint("Resposta vazia do servidor");
        }

        if (resposta.headers["content-type"] == null ||
            !resposta.headers["content-type"]!.contains("application/json")) {
          debugPrint("Resposta não é JSON");
          debugPrint(resposta.body);
        }

        final dados = jsonDecode(resposta.body);

        debugPrint("Imóvel destacado com sucesso! $dados.mensagem");
      } catch (erro) {
        debugPrint("Falha ao conectar com o backend: $erro");
      }
    } else {
      debugPrint("Erro: Dados do imóvel estão vazios");
    }
  }

  void excluirImovel() async {
    int imovelId = _refController.text.isNotEmpty
        ? int.tryParse(_refController.text) ?? 0
        : 0;
    if (imovelId <= 0) {
      debugPrint("ID do imóvel inválido: $imovelId");
    }
    try {
      final uri = Uri.parse(
        "${dotenv.get('ADDRESS')}imoveis.php?acao=apagar&id=$imovelId",
      );
      final resposta = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Cookie": sessionCookie ?? "",
        },
      );

      if (resposta.statusCode != 200) {
        debugPrint("Erro HTTP: ${resposta.statusCode}");
      }

      if (resposta.body.isEmpty) {
        debugPrint("Resposta vazia do servidor");
      }

      if (resposta.headers["content-type"] == null ||
          !resposta.headers["content-type"]!.contains("application/json")) {
        debugPrint("Resposta não é JSON");
        debugPrint(resposta.body);
      }

      final dados = jsonDecode(resposta.body);

      debugPrint("Imóvel excluido com sucesso! $dados.mensagem");
    } catch (erro) {
      debugPrint("Falha ao conectar com o backend: $erro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Imóvel')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: excluirImovel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Apagar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(onPressed: () => {}, child: Text("Anúncio")),
                ],
              ),
              SizedBox(height: 70),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisExtent: 5,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 4,
                ),
                children: [
                  Column(
                    children: [
                      Text("ref:"),
                      TextField(controller: _refController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Categoria:"),
                      DropdownButton<String>(
                        value: "",
                        items: const [
                          DropdownMenuItem(
                            value: "",
                            child: Text("Selecione uma opção"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Sala Comercial",
                            child: Text("Sala Comercial"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Apartamento",
                            child: Text("Apartamento"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Casa",
                            child: Text("Casa"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Terreno",
                            child: Text("Terreno"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Galpão",
                            child: Text("Galpão"),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _categoria = value!;
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Situação:"),
                      DropdownButton<String>(
                        value: "",
                        items: const [
                          DropdownMenuItem(
                            value: "",
                            child: Text("Selecione uma opção"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Novo",
                            child: Text("Novo"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Usado",
                            child: Text("Usado"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Em construção",
                            child: Text("Em construção"),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _situacao = value!;
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Estado:"),
                      DropdownButton<String>(
                        value: "",
                        items: const [
                          DropdownMenuItem(
                            value: "",
                            child: Text("Selecione uma opção"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Bom",
                            child: Text("Bom"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Ótimo",
                            child: Text("Ótimo"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Regular",
                            child: Text("Regular"),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _estado = value!;
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Ocupação:"),
                      DropdownButton<String>(
                        value: "",
                        items: const [
                          DropdownMenuItem(
                            value: "",
                            child: Text("Selecione uma opção"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Desocupado",
                            child: Text("Desocupado"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Inquilino",
                            child: Text("Inquilino"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Proprietário",
                            child: Text("Proprietário"),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _ocupacao = value!;
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Status:"),
                      DropdownButton<String>(
                        value: "",
                        items: const [
                          DropdownMenuItem(
                            value: "",
                            child: Text("Selecione uma opção"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Venda",
                            child: Text("Venda"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Aluguel",
                            child: Text("Aluguel"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Venda e Aluguel",
                            child: Text("Venda e Aluguel"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Alugado",
                            child: Text("Alugado"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Vendido",
                            child: Text("Vendido"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Pendente",
                            child: Text("Pendente"),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _status = value!;
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Nome do condominio:"),
                      TextField(controller: _nomeCondominioController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Ano de Construção:"),
                      TextField(controller: _anoConstrucaoController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("CEP:"),
                      TextField(controller: _cepController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Rua:"),
                      TextField(controller: _ruaController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Número:"),
                      TextField(controller: _numeroController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Complemento:"),
                      TextField(controller: _complementoController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Bloco:"),
                      TextField(controller: _blocoController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Andar:"),
                      TextField(controller: _andarController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Bairro:"),
                      TextField(controller: _bairroController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Cidade:"),
                      TextField(controller: _cidadeController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("UF:"),
                      TextField(controller: _ufController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Salas:"),
                      TextField(controller: _salasController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Banheiros:"),
                      TextField(controller: _banheirosController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Vagas:"),
                      TextField(controller: _vagasController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Varandas:"),
                      TextField(controller: _varandasController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Quartos:"),
                      TextField(controller: _quartosController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Area Total:"),
                      TextField(controller: _areaTotalController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Area Privativa:"),
                      TextField(controller: _areaPrivativaController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Valor Venda:"),
                      TextField(controller: _valorVendaController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Valor Aluguel:"),
                      TextField(controller: _valorAluguelController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Valor Condominio:"),
                      TextField(controller: _valorCondominioController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Valor IPTU:"),
                      TextField(controller: _valorIPTUController),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
