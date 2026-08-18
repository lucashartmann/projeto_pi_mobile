import 'package:flutter/material.dart';
import '../apis/usuario.dart';
import 'package:projeto_pi_mobile/view/login.dart';
import 'package:projeto_pi_mobile/view/widgets/bottom-nav.dart';

class DadosCliente extends StatefulWidget {
  const DadosCliente({super.key});

  @override
  State<DadosCliente> createState() => _DadosClienteState();
}

class _DadosClienteState extends State<DadosCliente> {
  late Future<Map<String, dynamic>?> _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = carregarUser();
    _usuario.then((dados) {
      if (!mounted) return;
      if (dados == null) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const TelaLogin()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados do Cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _usuario,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Nenhum dado encontrado.'));
                } else {
                  final usuario = snapshot.data!;
                  print(
                    "Data de Nascimento: ${usuario['usuario']['data_nascimento']}",
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dados básicos:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Nome: ${usuario['usuario']?['nome']}'),
                      Text('Email: ${usuario['usuario']?['email']}'),
                      Text('Telefone: ${usuario['usuario']?['telefones']?[0]}'),
                      Text('CPF/CNPJ: ${usuario['usuario']?['cpf_cnpj']}'),
                      Text('RG: ${usuario['usuario']?['rg']}'),
                      Text(
                        'Data de Nascimento: ${usuario['usuario']?['data_nascimento']}',
                      ),
                      Text(
                        'Data de Cadastro: ${usuario['usuario']?['data_cadastro']?['date']}',
                      ),
                      Text('Tipo: ${usuario['tipo']}'),
                      SizedBox(height: 16),
                      Text(
                        "Endereço:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Rua: ${usuario['usuario']?['endereco']?['rua']}'),
                      Text(
                        'Bairro: ${usuario['usuario']?['endereco']?['bairro']}',
                      ),
                      Text(
                        'Número: ${usuario['usuario']?['endereco']?['numero']}',
                      ),
                      Text(
                        'Complemento: ${usuario['usuario']?['endereco']?['complemento']}',
                      ),
                      Text('CEP: ${usuario['usuario']?['endereco']?['cep']}'),
                      Text(
                        'Cidade: ${usuario['usuario']?['endereco']?['cidade']}',
                      ),
                      Text('UF: ${usuario['usuario']?['endereco']?['uf']}'),
                    ],
                  );
                }
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 5),
    );
  }
}
