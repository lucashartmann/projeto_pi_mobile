import 'package:flutter/material.dart';
import 'package:projeto_pi_mobile/view/dados_cliente.dart';
import 'package:projeto_pi_mobile/view/estoque.dart';
import 'package:projeto_pi_mobile/view/atendimentos.dart';
import 'widgets/bottom-nav.dart';

class Opcoes extends StatefulWidget {
  const Opcoes({super.key});

  @override
  State<Opcoes> createState() => _OpcoesState();
}

class _OpcoesState extends State<Opcoes> {
  void abrirOpcoesCadastro(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Cadastrar Imóvel'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/cadastro_imovel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Cadastrar Pessoa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/cadastro_cliente');
              },
            ),
          ],
        );
      },
    );
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opções')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => abrirOpcoesCadastro(context),
              child: RichText(
                text: TextSpan(
                  text: 'Cadastro',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Estoque', style: TextStyle(fontSize: 16)),
              onPressed: () => {
                Navigator.pushReplacementNamed(context, '/estoque'),
              },
            ),
            ElevatedButton(
              child: Text('Atendimentos', style: TextStyle(fontSize: 16)),
              onPressed: () => {
                Navigator.pushReplacementNamed(context, '/atendimentos_cliente'),
              },
            ),
            ElevatedButton(
              child: Text('Meus Dados', style: TextStyle(fontSize: 16)),
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DadosCliente()),
                ),
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
