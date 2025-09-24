import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


// O runApp() inicia o aplicativo.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// ----------------------------------------------------------------------------
// Classe principal do aplicativo
// ----------------------------------------------------------------------------
// A classe MyApp é um StatelessWidget porque não precisa mais gerenciar o estado
// de uma lista local de pacientes.
// O Firebase cuidará disso.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// ----------------------------------------------------------------------------
// Widgets para as telas de login e cadastro
// ----------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Carrega a logo da pasta 'assets' do projeto.
Image.asset(
            'assets/HealthCare-Photoroom.png',
            height: 120,
          ),
          const SizedBox(height: 10),
          // Novo texto "HealthCare"
          Text(
            'HealthCare',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white, // mesma cor do "Entre com sua conta"
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Entre com sua conta',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
            ),
          ),

            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                hintText: 'MarielIacoelho@gmail.com',
                labelStyle: const TextStyle(color: Colors.white70),
                hintStyle: const TextStyle(color: Colors.white54),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: const Color(0xFF9b77eb),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: const Color(0xFF9b77eb),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    String message =
                        'Ocorreu um erro. Por favor, tente novamente.';
                    if (e.code == 'user-not-found') {
                      message = 'Nenhum usuário encontrado para esse e-mail.';
                    } else if (e.code == 'wrong-password') {
                      message = 'Senha incorreta.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Erro ao entrar: $message"),
                          backgroundColor: Colors.red),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Erro ao entrar: $e"),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroScreen(),
                  ),
                );
              },
              child: const Text(
                'Não tem cadastro? CLIQUE AQUI',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text.rich(
              TextSpan(
                text: 'Clique aqui para ler os ',
                children: [
                  TextSpan(
                    text: 'Termos de Serviço',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  TextSpan(text: ' e '),
                  TextSpan(
                    text: 'Política de Privacidade',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isCuidadorChecked = true;
  bool _isFamiliarChecked = false;
  bool _isTermsChecked = false;

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Cadastro', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Mariella Coelho Salvadori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF9b77eb),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text('E-mail', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Mariellacoelho@gmail.com.br',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF9b77eb),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text('Telefone', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '(DD) NNNNN-NNNN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF9b77eb),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text('Senha', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF9b77eb),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text('Confirmar Senha',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF9b77eb),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Selecione o seu perfil:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _isCuidadorChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCuidadorChecked = value ?? false;
                        if (value == true) _isFamiliarChecked = false;
                      });
                    },
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                  ),
                  const Text('Cuidador;', style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isFamiliarChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFamiliarChecked = value ?? false;
                        if (value == true) _isCuidadorChecked = false;
                      });
                    },
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                  ),
                  const Text('Familiar;', style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isTermsChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isTermsChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                  ),
                  const Flexible(
                    child: Text.rich(
                      TextSpan(
                        text: 'Clique aqui para ler os ',
                        children: [
                          TextSpan(
                            text: 'Termos de Serviço',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (!_isTermsChecked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Você deve aceitar os termos de serviço e privacidade.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('As senhas não coincidem.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                      await FirebaseFirestore.instance
                          .collection('usuarios')
                          .doc(userCredential.user!.uid)
                          .set({
                        'nome': _nameController.text,
                        'email': _emailController.text,
                        'perfil':
                            _isCuidadorChecked ? 'cuidador' : 'familiar',
                        'telefone': _phoneController.text,
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                      _showSuccessMessage("Cadastro realizado com sucesso!");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message =
                          'Ocorreu um erro. Por favor, tente novamente.';
                      if (e.code == 'weak-password') {
                        message = 'A senha fornecida é muito fraca.';
                      } else if (e.code == 'email-already-in-use') {
                        message = 'Já existe uma conta para esse e-mail.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Erro ao cadastrar: $message"),
                            backgroundColor: Colors.red),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Erro: $e"),
                            backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text(
                    'CONCLUIR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Classe Paciente
// ----------------------------------------------------------------------------
// Esta classe agora inclui o id e ownerId para uso com o Firestore
class Paciente {
  final String id;
  final String nome;
  final String local;
  final String genero; // 'homem' ou 'mulher'
  final String bpm;
  final String temperatura;
  final String alerta;
  final List<String> prontuario;
  final String ownerId;

  Paciente({
    required this.id,
    required this.nome,
    required this.local,
    required this.genero,
    required this.bpm,
    required this.temperatura,
    required this.alerta,
    required this.prontuario,
    required this.ownerId,
  });
  // Construtor de fábrica para criar uma instância de Paciente a partir de um DocumentSnapshot
  factory Paciente.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Paciente(
      id: doc.id,
      nome: data['nome'] ?? '',
      local: data['local'] ?? 'Não especificado',
      genero: data['genero'] ?? 'homem',
      bpm: data['bpm'] ?? '---',
      temperatura: data['temperatura'] ?? '---',
      alerta: data['alerta'] ?? 'NENHUM ALERTA',
      prontuario: List<String>.from(data['prontuario'] ?? []),
      ownerId: data['ownerId'] ?? '',
    );
  }
}

// ----------------------------------------------------------------------------
// HomeScreen
// ----------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CadastroDispositivoScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ConfiguracoesScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Retorna para a tela de login se não houver usuário logado
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pacientes')
                    .where('ownerId', isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Nenhum paciente cadastrado.'));
                  }

                  final pacientes = snapshot.data!.docs
                      .map((doc) => Paciente.fromFirestore(doc))
                      .toList();

                  final filteredPacientes = pacientes
                      .where((p) => p.nome.toLowerCase().contains(_searchQuery))
                      .toList();

                  // Prioriza pacientes com alerta
                  filteredPacientes.sort((a, b) {
                    final aHasAlert = a.alerta != 'NENHUM ALERTA';
                    final bHasAlert = b.alerta != 'NENHUM ALERTA';
                    if (aHasAlert && !bHasAlert) {
                      return -1;
                    }
                    if (!aHasAlert && bHasAlert) {
                      return 1;
                    }
                    return 0;
                  });

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredPacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = filteredPacientes[index];
                      final Color cardColor = paciente.genero == 'homem'
                          ? const Color(0xFFE2F4FF)
                          : paciente.genero == 'mulher'
                              ? const Color(0xFFF3E5F5)
                              : const Color(0xFFD3D3D3);

                      // Verifica se o paciente tem alerta para ativar a animação
                      final hasAlert = paciente.alerta != 'NENHUM ALERTA';

                      return BlinkingContainer(
                        isBlinking: hasAlert,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalhesPacienteScreen(pacienteId: paciente.id),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nome: ${paciente.nome}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Local: ${paciente.local}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.vaccines,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.error_outline,
                                    color: hasAlert
                                        ? Colors.red.shade400
                                        : Colors.transparent,
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// DetalhesPacienteScreen
// ----------------------------------------------------------------------------
class DetalhesPacienteScreen extends StatelessWidget {
  final String pacienteId;
  const DetalhesPacienteScreen({super.key, required this.pacienteId});

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFC3D9C9), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style:
                  TextStyle(fontSize: 16, color: valueColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('pacientes').doc(pacienteId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erro ao carregar dados: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Paciente não encontrado.')),
          );
        }

        final paciente = Paciente.fromFirestore(snapshot.data!);

        final Color appBarColor = paciente.genero == 'homem'
            ? const Color(0xFFE2F4FF)
            : paciente.genero == 'mulher'
                ? const Color(0xFFF3E5F5)
                : const Color(0xFFC3D9C9);
        final Color? alertaColor =
            paciente.alerta != 'NENHUM ALERTA' ? Colors.red : null;

        return Scaffold(
          backgroundColor: const Color(0xFF8663ea),
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Dados do usuário',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildInfoRow('Nome', paciente.nome),
                    _buildInfoRow('Quarto', paciente.local),
                    _buildInfoRow('BPM', paciente.bpm),
                    _buildInfoRow('Temperatura', paciente.temperatura),
                    _buildInfoRow(
                      'Alerta de Queda',
                      paciente.alerta,
                      valueColor: alertaColor,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlertasScreen(pacienteId: paciente.id),
                            ),
                          );
                        },
                        child: const Text(
                          'Alertas',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProntuarioScreen(prontuario: paciente.prontuario),
                            ),
                          );
                        },
                        child: const Text(
                          'Prontuário',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------------
// ConfiguracoesScreen
// ----------------------------------------------------------------------------
class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9b77eb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildConfigItem(context, 'Adicionar nova pessoa/dispositivo', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CadastroDispositivoScreen(),
              ),
            );
          }),
          _buildConfigItem(context, 'Remover pessoa/dispositivo', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RemoverScreen(),
              ),
            );
          }),
          _buildConfigItem(context, 'Dados pessoais', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DadosPessoaisScreen(),
              ),
            );
          }),
          _buildConfigItem(context, 'Senha e segurança', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SenhaSegurancaScreen(),
              ),
            );
          }),
          _buildConfigItem(context, 'Termos de serviço e privacidade', () {}),
          _buildConfigItem(context, 'Excluir conta', () {}),
          _buildConfigItem(context, 'Sair', () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConfigItem(
    BuildContext context,
    String title,
    Function() onPressed,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF9b77eb), width: 1.0),
        ),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onPressed,
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Nova Tela de Cadastro de Dispositivo
// ----------------------------------------------------------------------------
class CadastroDispositivoScreen extends StatefulWidget {
  const CadastroDispositivoScreen({super.key});

  @override
  State<CadastroDispositivoScreen> createState() =>
      _CadastroDispositivoScreenState();
}

class _CadastroDispositivoScreenState extends State<CadastroDispositivoScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _outrosController = TextEditingController();
  final TextEditingController _medicamentosController = TextEditingController();
  final TextEditingController _alergiaController = TextEditingController();

  bool _isMasculino = true;
  bool _isFeminino = false;
  bool _hasAlzheimer = false;
  bool _hasDiabetes = false;
  bool _hasCatarata = false;
  bool _hasDepressao = false;
  bool _hasDoencasCardiacas = false;
  bool _hasDoencasRespiratorias = false;
  bool _hasOsteoporose = false;

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localController.dispose();
    _dataNascimentoController.dispose();
    _outrosController.dispose();
    _medicamentosController.dispose();
    _alergiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9b77eb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cadastro de nova pessoa/dispositivo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Código do dispositivo', 'ABC001'),
              _buildTextField(
                'Nome do usuário',
                'Filipe Bueno',
                controller: _nomeController,
              ),
              _buildTextField(
                'Data de nascimento',
                'DD / MM / AAAA',
                controller: _dataNascimentoController,
              ),
              const SizedBox(height: 15),
              const Text('Sexo:', style: TextStyle(fontSize: 16, color: Colors.white)),
              Row(
                children: [
                  _buildCheckbox('Feminino', _isFeminino, (value) {
                    setState(() {
                      _isFeminino = value!;
                      _isMasculino = !value;
                    });
                  }),
                  _buildCheckbox('Masculino', _isMasculino, (value) {
                    setState(() {
                      _isMasculino = value!;
                      _isFeminino = !value;
                    });
                  }),
                ],
              ),
              // NOVO: Campo de local do paciente
              _buildTextField(
                'Local do paciente',
                'Ex: Quarto 1',
                controller: _localController,
              ),
              const SizedBox(height: 15),
              const Text('Prontuário:', style: TextStyle(fontSize: 16, color: Colors.white)),
              const Text(
                'Selecione o que mais se adequa ao usuário:',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(height: 10),
              _buildCheckbox('Alzheimer', _hasAlzheimer, (value) {
                setState(() => _hasAlzheimer = value!);
              }),
              _buildCheckbox('Diabetes', _hasDiabetes, (value) {
                setState(() => _hasDiabetes = value!);
              }),
              _buildCheckbox('Catarata', _hasCatarata, (value) {
                setState(() => _hasCatarata = value!);
              }),
              _buildCheckbox('Depressão', _hasDepressao, (value) {
                setState(() => _hasDepressao = value!);
              }),
              _buildCheckbox('Doenças cardíacas', _hasDoencasCardiacas, (
                value,
              ) {
                setState(() => _hasDoencasCardiacas = value!);
              }),
              _buildCheckbox(
                'Doenças respiratórias',
                _hasDoencasRespiratorias,
                (value) {
                  setState(() => _hasDoencasRespiratorias = value!);
                },
              ),
              _buildCheckbox('Osteoporose', _hasOsteoporose, (value) {
                setState(() => _hasOsteoporose = value!);
              }),
              _buildTextField(
                'Outros:',
                'ex. Bronquite, labirintite',
                controller: _outrosController,
              ),
              _buildTextField(
                'Usuário já realizou cirurgias?',
                'Quais?',
                controller: _medicamentosController,
              ),
              _buildTextField(
                'Usuário tem algum tipo de alergia?',
                'Quais?',
                controller: _alergiaController,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_nomeController.text.isNotEmpty) {
                      final newProntuario = <String>[];
                      if (_hasAlzheimer) newProntuario.add('Alzheimer');
                      if (_hasDiabetes) newProntuario.add('Diabetes');
                      if (_hasCatarata) newProntuario.add('Catarata');
                      if (_hasDepressao) newProntuario.add('Depressão');
                      if (_hasDoencasCardiacas) {
                        newProntuario.add('Doenças cardíacas');
                      }
                      if (_hasDoencasRespiratorias) {
                        newProntuario.add('Doenças respiratórias');
                      }
                      if (_hasOsteoporose) newProntuario.add('Osteoporose');
                      if (_outrosController.text.isNotEmpty) {
                        newProntuario.add('Outros: ${_outrosController.text}');
                      }
                      if (_medicamentosController.text.isNotEmpty) {
                        newProntuario.add(
                          'Cirurgias: ${_medicamentosController.text}',
                        );
                      }
                      if (_alergiaController.text.isNotEmpty) {
                        newProntuario.add(
                          'Alergias: ${_alergiaController.text}',
                        );
                      }

                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('pacientes')
                              .add({
                            'nome': _nomeController.text,
                            'local': _localController.text.isNotEmpty ? _localController.text : 'Não especificado',
                            'genero': _isMasculino ? 'homem' : 'mulher',
                            'bpm': '---',
                            'temperatura': '---',
                            'alerta': 'NENHUM ALERTA',
                            'prontuario': newProntuario,
                            'ownerId': user.uid,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          _showSuccessMessage(
                            'Nova pessoa cadastrada com sucesso!',
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao cadastrar paciente: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, preencha o nome do usuário.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'CONCLUIR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: const Color(0xFF9b77eb),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
            checkColor: Colors.white),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// Tela de Remover Pessoa/Dispositivo
// ----------------------------------------------------------------------------
class RemoverScreen extends StatelessWidget {
  const RemoverScreen({super.key});

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _removePatient(BuildContext context, String pacienteId) async {
    try {
      await FirebaseFirestore.instance.collection('pacientes').doc(pacienteId).delete();
      _showSuccessMessage(context, 'Item removido com sucesso!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao remover: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9b77eb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Remover', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Selecione uma pessoa/dispositivo para remover:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pacientes')
                    .where('ownerId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Nenhum paciente para remover.'));
                  }

                  final pacientes = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = Paciente.fromFirestore(pacientes[index]);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          tileColor: const Color(0xFF9b77eb),
                          title: Text(paciente.nome, style: const TextStyle(color: Colors.white)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _removePatient(context, paciente.id),
                            child: const Text(
                              'Remover',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Nova Tela de Dados Pessoais
// ----------------------------------------------------------------------------
class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Nenhum usuário logado.'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9b77eb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dados pessoais',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('Erro ao carregar dados do usuário.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              _buildInfoRow('Nome:', data['nome'] ?? 'Não informado'),
              _buildInfoRow('E-mail:', data['email'] ?? 'Não informado'),
              _buildInfoRow('Telefone:', data['telefone'] ?? 'Não informado'),
              _buildInfoRow('Perfil:', data['perfil'] ?? 'Não informado'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Funcionalidade de edição não implementada.',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Editar dados pessoais',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Tela de Senha e Segurança
// ----------------------------------------------------------------------------
class SenhaSegurancaScreen extends StatefulWidget {
  const SenhaSegurancaScreen({super.key});

  @override
  State<SenhaSegurancaScreen> createState() => _SenhaSegurancaScreenState();
}

class _SenhaSegurancaScreenState extends State<SenhaSegurancaScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Senha e Segurança',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Senha atual', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 5),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                filled: true,
                fillColor: Color(0xFF9b77eb),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),
            const Text('Nova senha', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 5),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                filled: true,
                fillColor: Color(0xFF9b77eb),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Nenhum usuário logado.'),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }

                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: _currentPasswordController.text,
                    );
                    await user.reauthenticateWithCredential(credential);
                    await user.updatePassword(_newPasswordController.text);
                    _showSuccessMessage('Senha alterada com sucesso!');
                    _currentPasswordController.clear();
                    _newPasswordController.clear();
                  } on FirebaseAuthException catch (e) {
                    String message =
                        'Erro ao alterar a senha. Verifique a senha atual.';
                    if (e.code == 'wrong-password') {
                      message = 'A senha atual está incorreta.';
                    } else if (e.code == 'weak-password') {
                      message = 'A nova senha é muito fraca.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(message), backgroundColor: Colors.red),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro: $e'), backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text(
                  'Alterar Senha',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Telas auxiliares
// ----------------------------------------------------------------------------
class ProntuarioScreen extends StatelessWidget {
  final List<String> prontuario;

  const ProntuarioScreen({super.key, required this.prontuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9b77eb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Prontuário', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: prontuario.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(
              Icons.assignment,
              size: 32,
              color: Colors.white,
            ),
            title: Text(prontuario[index], style: const TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}

class AlertasScreen extends StatelessWidget {
  final String pacienteId;

  const AlertasScreen({super.key, required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    // Este código simula a busca de alertas no Firestore
    // Você pode adaptar isso para a sua lógica de alertas real.
    // Exemplo: 'pacientes/{pacienteId}/alertas'
    final List<Map<String, String>> alertasMock = [
      {
        'titulo': 'Queda detectada',
        'data': '19/08/2025',
      },
      {
        'titulo': 'Batimento cardíaco elevado',
        'data': '18/08/2025',
      },
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF8663ea),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9b77eb),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Alertas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: alertasMock.length,
        itemBuilder: (context, index) {
          final alerta = alertasMock[index];
          return ListTile(
            leading: const Icon(Icons.error, color: Colors.red, size: 32),
            title: Text(alerta['titulo']!, style: const TextStyle(color: Colors.white)),
            subtitle: Text(alerta['data']!, style: const TextStyle(color: Colors.white70)),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class BlinkingContainer extends StatefulWidget {
  final Widget child;
  final bool isBlinking;

  const BlinkingContainer({
    super.key,
    required this.child,
    required this.isBlinking,
  });

  @override
  State<BlinkingContainer> createState() => _BlinkingContainerState();
}

class _BlinkingContainerState extends State<BlinkingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isBlinking) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }
}
