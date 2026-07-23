import 'dart:ffi';

import 'package:flutter/material.dart';

class CadastroImovel extends StatefulWidget {
  const CadastroImovel({super.key});

  @override
  State<CadastroImovel> createState() => _CadastroImovelState();
}

class _CadastroImovelState extends State<CadastroImovel> {
  String categoria = "";
  String situacao = "";
  String estado = "";
  String ocupacao = "";
  String status = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Imóvel')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(onPressed: () => {}, child: Text('Apagar')),
                  ElevatedButton(onPressed: () => {}, child: Text("Salvar")),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: () => {}, child: Text('Cadastro')),
                  ElevatedButton(onPressed: () => {}, child: Text("Anúncio")),
                ],
              ),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  Column(children: [Text("ref:"), TextField()]),
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
                          categoria = value!;
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
                          situacao = value!;
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
                          estado = value!;
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
                          ocupacao = value!;
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
                          status = value!;
                        }),
                      ),
                    ],
                  ),
                  Column(children: [Text("Nome do condominio:"), TextField()]),
                  Column(children: [Text("Ano de Construção:"), TextField()]),
                  Column(children: [Text("CEP:"), TextField()]),
                  Column(children: [Text("Rua:"), TextField()]),
                  Column(children: [Text("Número:"), TextField()]),
                  Column(children: [Text("Complemento:"), TextField()]),
                  Column(children: [Text("Bloco:"), TextField()]),
                  Column(children: [Text("Andar:"), TextField()]),
                  Column(children: [Text("Bairro:"), TextField()]),
                  Column(children: [Text("Cidade:"), TextField()]),
                  Column(children: [Text("UF:"), TextField()]),
                  Column(children: [Text("Salas:"), TextField()]),
                  Column(children: [Text("Banheiros:"), TextField()]),
                  Column(children: [Text("Vagas:"), TextField()]),
                  Column(children: [Text("Varandas:"), TextField()]),
                  Column(children: [Text("Quartos:"), TextField()]),
                  Column(children: [Text("Area Total:"), TextField()]),
                  Column(children: [Text("Area Privativa:"), TextField()]),
                  Column(children: [Text("Valor Venda:"), TextField()]),
                  Column(children: [Text("Valor Aluguel:"), TextField()]),
                  Column(children: [Text("Valor Condominio:"), TextField()]),
                  Column(children: [Text("Valor IPTU:"), TextField()]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
