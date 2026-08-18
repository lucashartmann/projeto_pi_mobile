import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_pi_mobile/view/tela_inicial.dart';
import 'package:projeto_pi_mobile/view/cadastro_imovel.dart';
import '../apis/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void enviarNovaSenha() async {
    String email = _emailController.text;
    try {
      final uri = Uri.parse(
        "${dotenv.get('ADDRESS')}login.php?acao=recuperar_senha",
      );

      final resposta = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Cookie": sessionCookie ?? "",
        },
        body: jsonEncode({"email": email}),
      );

      final cookie = resposta.headers["set-cookie"];

      if (cookie != null) {
        sessionCookie = cookie.split(";").first;
        debugPrint("Cookie salvo: $sessionCookie");
      }

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

      if (data["status"] == "erro") {
        debugPrint("Usuário não logado: ${data["mensagem"]}");
        return null;
      }

      if (data["status"] == "sucesso") {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Senha enviada para o email cadastrado!")));
        return;
      }
    } catch (e) {
      debugPrint("ERRO: login.dart - enviarNovaSenha: $e");
      return null;
    }
  }

  Future<void> fazerLogin(BuildContext context) async {
    String usuario = _emailController.text;
    String senha = _senhaController.text;

    try {
      final uri = Uri.parse("${dotenv.get('ADDRESS')}login.php?acao=login");
      final resposta = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "senha": senha}),
      );

      final cookie = resposta.headers["set-cookie"];

      if (cookie != null) {
        sessionCookie = cookie.split(";").first;
        debugPrint("Cookie salvo: $sessionCookie");
      }

      if (resposta.statusCode != 200) {
        debugPrint("Erro HTTP: ${resposta.statusCode}");
        return;
      }

      final contentType = resposta.headers["content-type"];

      if (contentType == null || !contentType.contains("application/json")) {
        debugPrint("Resposta não é JSON");
        debugPrint(resposta.body);
        return;
      }

      debugPrint(resposta.body);

      Map<String, dynamic> data = jsonDecode(resposta.body);

      if (data["status"] == "sucesso") {
        final tipoUsuario = data["usuario"]["tipo"];

        debugPrint("Tipo de usuário: $tipoUsuario");

        if (!context.mounted) {
          debugPrint("Context não montado");
          return;
        }

        if (tipoUsuario == "CLIENTE") {
          debugPrint("Cliente!");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const TelaInicial()),
          );
          return;
        }

        if (tipoUsuario == "ADMIN") {
          debugPrint("ADMIN!");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => CadastroImovel()),
          );
          return;
        }
        debugPrint("Tipo de usuário desconhecido: $tipoUsuario");
      }
    } catch (e) {
      debugPrint("ERRO: login.dart - fazerLogin: $e");
      return;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = 'administrador1@outlook.com';
    _senhaController.text = 'Administrador1#';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextButton(onPressed: () => {}, child: const Text("Criar Conta")),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextButton(
              onPressed: () => {},
              child: const Text("Esqueci minha senha"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                fazerLogin(context);
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                fazerLogin(context);
              },
              child: const Text('Entrar com Google'),
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text("Problema com o login"),
            ),
            TextButton(onPressed: () {}, child: const Text("Privacidade")),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 5),
    );
  }
}
