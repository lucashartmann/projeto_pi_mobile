import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';

class CadastroCliente extends StatefulWidget {
  const CadastroCliente({super.key});

  @override
  State<CadastroCliente> createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pessoa')),
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
                      DropdownButton<String>(
                        value: "",
                        items: const [
                          DropdownMenuItem(
                            value: "",
                            child: Text("Selecione uma opção"),
                          ),
                          DropdownMenuItem<String>(
                            value: "PROPRIETARIO",
                            child: Text("Proprietário"),
                          ),
                          DropdownMenuItem<String>(
                            value: "FINANCEIRO",
                            child: Text("Financeiro"),
                          ),
                          DropdownMenuItem<String>(
                            value: "CAPTADOR",
                            child: Text("Captador"),
                          ),
                          DropdownMenuItem<String>(
                            value: "CORRETOR",
                            child: Text("Corretor"),
                          ),
                          DropdownMenuItem<String>(
                            value: "CLIENTE",
                            child: Text("Cliente"),
                          ),
                          DropdownMenuItem<String>(
                            value: "VISTORIADOR",
                            child: Text("Vistoriador"),
                          ),
                          DropdownMenuItem<String>(
                            value: "GERENTE",
                            child: Text("Gerente"),
                          ),
                          DropdownMenuItem<String>(
                            value: "ADMIN",
                            child: Text("Administrador"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            // _selectedValue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(children: [Text("Telefone:"), TextField()]),
                  Column(children: [Text("Nome:"), TextField()]),
                  Column(children: [Text("Email:"), TextField()]),
                  Column(children: [Text("Rua:"), TextField()]),
                  Column(children: [Text("Número:"), TextField()]),
                  Column(children: [Text("Complemento:"), TextField()]),
                  Column(children: [Text("Bloco:"), TextField()]),
                  Column(children: [Text("Bairro:"), TextField()]),
                  Column(children: [Text("Cidade:"), TextField()]),
                  Column(children: [Text("UF:"), TextField()]),
                  Column(children: [Text("CEP:"), TextField()]),
                  Column(children: [Text("Data de nascimento:"), TextField()]),
                  Column(children: [Text("CPF/CNPJ:"), TextField()]),
                  Column(children: [Text("RG:"), TextField()]),
                  Column(children: [Text("Sálario:"), TextField()]),
                  Column(children: [Text("Creci:"), TextField()]),
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
