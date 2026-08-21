import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_pi_mobile/apis/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CadastroCliente extends StatefulWidget {
  const CadastroCliente({super.key});

  @override
  State<CadastroCliente> createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _blocoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _creciController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  String _tipo = "";

  var telefoneFormatador = new MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var cpfCnpjFormatador = new MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var cepFormatador = new MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var dataNascimentoFormatador = new MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

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

  void salvar() async {
    Map<String, dynamic> pessoa = {
      "tipo": _tipo,
      "telefone": _telefoneController.text,
      "nome": _nomeController.text,
      "email": _emailController.text,
      "cpf_cnpj": _cpfCnpjController.text,
      "data_nascimento": _dataNascimentoController.text,
      "salario": _salarioController.text,
      "creci": _creciController.text,
      "rg": _rgController.text,
      "cep": _cepController.text,
      "rua": _ruaController.text,
      "numero": _numeroController.text,
      "complemento": _complementoController.text,
      "bloco": _blocoController.text,
      "bairro": _bairroController.text,
      "cidade": _cidadeController.text,
      "uf": _ufController.text,
      "id": _idController.text.isNotEmpty
          ? int.tryParse(_idController.text) ?? 0
          : 0,
    };

    if (pessoa.isNotEmpty) {
      try {
        final uri = Uri.parse(
          "${dotenv.get('ADDRESS')}usuarios.php?acao=cadastro",
        );

        final resposta = await http.post(uri, body: jsonEncode(pessoa));
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
          debugPrint("Erro ao salvar pessoa: ${dados["mensagem"]}");
        } else {
          debugPrint("Pessoa salva com sucesso! ${dados["mensagem"]}");
        }
      } catch (erro) {
        debugPrint("Falha ao conectar com o backend: $erro");
      }
    } else {
      debugPrint("Erro: Dados da pessoa estão vazios");
    }
  }

  void excluirImovel() async {
    int idPessoa = _idController.text.isNotEmpty
        ? int.tryParse(_idController.text) ?? 0
        : 0;
    if (idPessoa <= 0) {
      debugPrint("ID da pessoa inválido: $idPessoa");
    }
    try {
      final uri = Uri.parse(
        "${dotenv.get('ADDRESS')}usuarios.php?acao=apagar&id=$idPessoa",
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
        debugPrint("Erro ao excluir pessoa: ${dados["mensagem"]}");
      } else {
        debugPrint("Pessoa excluida com sucesso! ${dados["mensagem"]}");
      }
    } catch (erro) {
      debugPrint("Falha ao conectar com o backend: $erro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pessoa')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Visibility(
                visible: false,
                maintainState: true,
                child: TextFormField(controller: _idController),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => {},
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
                    onPressed: () => {},
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
                      Text("Tipo:"),
                      DropdownMenu<String>(
                        label: Text("Selecione uma opção"),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: "",
                            label: "Selecione uma opção",
                          ),
                          DropdownMenuEntry(
                            value: "PROPRIETARIO",
                            label: "Proprietário",
                          ),
                          DropdownMenuEntry(
                            value: "FINANCEIRO",
                            label: "Financeiro",
                          ),
                          DropdownMenuEntry(
                            value: "CAPTADOR",
                            label: "Captador",
                          ),
                          DropdownMenuEntry(
                            value: "CORRETOR",
                            label: "Corretor",
                          ),
                          DropdownMenuEntry(value: "CLIENTE", label: "Cliente"),
                          DropdownMenuEntry(
                            value: "VISTORIADOR",
                            label: "Vistoriador",
                          ),
                          DropdownMenuEntry(value: "GERENTE", label: "Gerente"),
                          DropdownMenuEntry(
                            value: "ADMIN",
                            label: "Administrador",
                          ),
                        ],
                        onSelected: (value) {
                          setState(() {
                            _tipo = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Telefone:"),
                      TextField(
                        controller: _telefoneController,
                        inputFormatters: [telefoneFormatador],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Nome:"),
                      TextField(controller: _nomeController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Email:"),
                      TextField(controller: _emailController),
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
                      Text("CEP:"),
                      TextField(
                        controller: _cepController,
                        inputFormatters: [cepFormatador],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Data de nascimento:"),
                      TextField(
                        controller: _dataNascimentoController,
                        inputFormatters: [dataNascimentoFormatador],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("CPF/CNPJ:"),
                      TextField(
                        controller: _cpfCnpjController,
                        inputFormatters: [cpfCnpjFormatador],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("RG:"),
                      TextField(controller: _rgController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Sálario:"),
                      TextField(controller: _salarioController),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Creci:"),
                      TextField(controller: _creciController),
                    ],
                  ),
                  Column(children: [Text("Interessado em:"), TextField()]),
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
