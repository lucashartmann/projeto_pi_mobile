import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'package:projeto_pi_mobile/apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projeto_pi_mobile/apis/imoveis.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroImovel extends StatefulWidget {
  const CadastroImovel({super.key});

  @override
  State<CadastroImovel> createState() => _CadastroImovelState();
}

class _CadastroImovelState extends State<CadastroImovel> {
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
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  String _categoria = "";
  String _situacao = "";
  String _estado = "";
  String _ocupacao = "";
  String _status = "";

  var cepFormatador = new MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void salvar() async {
    Map<String, dynamic> imovel = {
      "ref": _refController.text,
      "categoria": _categoria,
      "situacao": _situacao,
      "estado": _estado,
      "ocupacao": _ocupacao,
      "status": _status,
      "nome_condominio": _nomeCondominioController.text,
      "ano_construcao": _anoConstrucaoController.text,
      "cep": _cepController.text,
      "rua": _ruaController.text,
      "numero": _numeroController.text,
      "complemento": _complementoController.text,
      "bloco": _blocoController.text,
      "andar": _andarController.text,
      "bairro": _bairroController.text,
      "cidade": _cidadeController.text,
      "uf": _ufController.text,
      "quantidade_salas": _salasController.text,
      "quantidade_banheiros": _banheirosController.text,
      "quantidade_vagas": _vagasController.text,
      "quantidade_varandas": _varandasController.text,
      "quantidade_quartos": _quartosController.text,
      "quantidade_suites": _suitesController.text,
      "area_total": _areaTotalController.text,
      "area_privativa": _areaPrivativaController.text,
      "valor_aluguel": _valorAluguelController.text,
      "valor_condominio": _valorCondominioController.text,
      "iptu": _valorIPTUController.text,
      "titulo": _tituloController.text,
      "descricao": _descricaoController.text,
    };

    if (imovel.isNotEmpty) {
      try {
        final uri = Uri.parse(
          "${dotenv.get('ADDRESS')}imoveis.php?acao=cadastrar",
        );

        final resposta = await http.post(uri, body: jsonEncode(imovel), headers: {"Cookie": sessionCookie ?? ""},);
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

        if (dados["status"] == "erro") {
          debugPrint("Erro ao salvar imóvel: ${dados["mensagem"]}");
        } else {
          debugPrint("Imóvel salvo com sucesso! ${dados["mensagem"]}");
        }
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

      if (dados["status"] == "erro") {
        debugPrint("Erro ao excluir imóvel: ${dados["mensagem"]}");
      } else {
        debugPrint("Imóvel excluido com sucesso! ${dados["mensagem"]}");
      }
    } catch (erro) {
      debugPrint("Falha ao conectar com o backend: $erro");
    }
  }

  void preencherEndereco(value) async {
    String cep = value.replaceAll(RegExp(r'\D'), "");

    _ruaController.text = "";
    _bairroController.text = "";
    _cidadeController.text = "";
    _ufController.text = "";

    if (cep.length < 8 || cep.length > 8) {
      return;
    }

    try {
      final uri = Uri.parse("https://viacep.com.br/ws/$cep/json/");

      final resposta = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
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

      final data = jsonDecode(resposta.body);

      _ruaController.text = data["logradouro"] ?? "";
      _bairroController.text = data["bairro"] ?? "";
      _cidadeController.text = data["localidade"] ?? "";
      _ufController.text = data["uf"] ?? "";
    } catch (error) {
      debugPrint("Falha ao conectar com o backend: $error");
    }
  }

  int telaSelecionada = 0;

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
                    onPressed: () => {
                      setState(() {
                        telaSelecionada = 0;
                      }),
                    },
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        telaSelecionada = 1;
                      }),
                    },
                    child: Text("Anúncio"),
                  ),
                ],
              ),
              SizedBox(height: 70),
              telaSelecionada == 0
                  ? GridView(
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
                            Row(
                              children: [
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 21,
                                  ),
                                ),
                                Text("Categoria:"),
                              ],
                            ),
                            DropdownMenu<String>(
                              label: Text("Selecione uma opção"),
                              onSelected: (value) => setState(() {
                                _categoria = value!;
                              }),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "",
                                  label: "Selecione uma opção",
                                ),
                                DropdownMenuEntry(
                                  value: "Sala Comercial",
                                  label: "Sala Comercial",
                                ),

                                DropdownMenuEntry(
                                  value: "Apartamento",
                                  label: "Apartamento",
                                ),

                                DropdownMenuEntry(value: "Casa", label: "Casa"),

                                DropdownMenuEntry(
                                  value: "Terreno",
                                  label: "Terreno",
                                ),

                                DropdownMenuEntry(
                                  value: "Galpão",
                                  label: "Galpão",
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Situação:"),
                            DropdownMenu<String>(
                              label: Text("Selecione uma opção"),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "",
                                  label: "Selecione uma opção",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Novo",
                                  label: "Novo",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Usado",
                                  label: "Usado",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Em construção",
                                  label: "Em construção",
                                ),
                              ],
                              onSelected: (value) => setState(() {
                                _situacao = value!;
                              }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Estado:"),
                            DropdownMenu<String>(
                              label: Text("Selecione uma opção"),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "",
                                  label: "Selecione uma opção",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Bom",
                                  label: "Bom",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Ótimo",
                                  label: "Ótimo",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Regular",
                                  label: "Regular",
                                ),
                              ],
                              onSelected: (value) => setState(() {
                                _estado = value!;
                              }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Ocupação:"),
                            DropdownMenu<String>(
                              label: Text("Selecione uma opção"),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "",
                                  label: "Selecione uma opção",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Desocupado",
                                  label: "Desocupado",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Inquilino",
                                  label: "Inquilino",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Proprietário",
                                  label: "Proprietário",
                                ),
                              ],
                              onSelected: (value) => setState(() {
                                _ocupacao = value!;
                              }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 21,
                                  ),
                                ),
                                Text("Status:"),
                              ],
                            ),
                            DropdownMenu<String>(
                              label: Text("Selecione uma opção"),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "",
                                  label: "Selecione uma opção",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Venda",
                                  label: "Venda",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Aluguel",
                                  label: "Aluguel",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Venda e Aluguel",
                                  label: "Venda e Aluguel",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Alugado",
                                  label: "Alugado",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Vendido",
                                  label: "Vendido",
                                ),
                                DropdownMenuEntry<String>(
                                  value: "Pendente",
                                  label: "Pendente",
                                ),
                              ],
                              onSelected: (value) => setState(() {
                                debugPrint("Status selecionado: $value");
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
                            Row(
                              children: [
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 21,
                                  ),
                                ),
                                Text("CEP:"),
                              ],
                            ),
                            TextField(
                              controller: _cepController,
                              inputFormatters: [cepFormatador],
                              onChanged: (value) => preencherEndereco(value),
                            ),
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
                    )
                  : GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 200,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                      ),
                      children: [
                        Column(
                          children: [
                            Text("Titulo:"),
                            TextField(
                              controller: _tituloController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 40.0,
                                  horizontal: 10.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Descrição:"),
                            TextField(
                              controller: _descricaoController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 90.0,
                                  horizontal: 10.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
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
