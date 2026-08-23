import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_pi_mobile/view/tela_inicial.dart';
import 'package:projeto_pi_mobile/view/cadastro_imovel.dart';
import '../apis/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_theme.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _carregando = false;

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["mensagem"] ?? "Erro ao enviar senha")),
        );
        return null;
      }

      if (data["status"] == "sucesso") {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Senha enviada para o email cadastrado!"),
          ),
        );
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

    if (usuario.isEmpty || senha.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Preencha todos os campos")));
      return;
    }

    setState(() => _carregando = true);

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao conectar ao servidor")),
        );
        setState(() => _carregando = false);
        return;
      }

      final contentType = resposta.headers["content-type"];

      if (contentType == null || !contentType.contains("application/json")) {
        debugPrint("Resposta não é JSON");
        debugPrint(resposta.body);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao processar resposta")),
        );
        setState(() => _carregando = false);
        return;
      }

      debugPrint(resposta.body);

      Map<String, dynamic> data = jsonDecode(resposta.body);

      if (data["status"] == "sucesso") {
        final tipoUsuario = data["usuario"]["tipo"];

        debugPrint("Tipo de usuário: $tipoUsuario");

        if (!mounted) {
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
            MaterialPageRoute(builder: (_) => const CadastroImovel()),
          );
          return;
        }
        debugPrint("Tipo de usuário desconhecido: $tipoUsuario");
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["mensagem"] ?? "Erro ao fazer login")),
        );
      }
    } catch (e) {
      debugPrint("ERRO: login.dart - fazerLogin: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => _carregando = false);
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
    _emailController.text = 'administrador1@gmail.com';
    _senhaController.text = 'Administrador1#';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Ícone principal
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.hoverColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  size: 40,
                  color: AppColors.hoverColor,
                ),
              ),
              const SizedBox(height: 24),
              // Título
              Text(
                'Bem-vindo',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Subtítulo
              Text(
                'Faça login para continuar',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),
              // Campo Email
              TextField(
                controller: _emailController,
                enabled: !_carregando,
                decoration: InputDecoration(
                  labelText: 'Email ou Usuário',
                  hintText: 'Digite seu email',
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 24),
              // Campo Senha
              TextField(
                controller: _senhaController,
                enabled: !_carregando,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _senhaVisivel = !_senhaVisivel);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Esqueci senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _carregando ? null : enviarNovaSenha,
                  child: const Text("Esqueci minha senha"),
                ),
              ),
              const SizedBox(height: 32),
              // Botão Entrar
              ElevatedButton(
                onPressed: _carregando
                    ? null
                    : () {
                        fazerLogin(context);
                      },
                child: _carregando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 24),
              // Divisor
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'ou',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 24),
              // Botão Google
              OutlinedButton(
                onPressed: _carregando ? null : () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.g_mobiledata),
                    const SizedBox(width: 8),
                    const Text('Entrar com Google'),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Links inferiores
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Problema com o login?"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Política de Privacidade"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 5),
    );
  }
}
