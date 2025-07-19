import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late TabController tabController;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Center(
                    child: Text(
                      'MyApp',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Welcome to My App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Sign up to continue',
                      style: TextStyle(color: Color.fromARGB(255, 127, 125, 125), fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        text: 'EMAIL ADDRESS',
                      ),
                      Tab(
                        text: 'PHONE NUMBER',
                      ),
                    ],
                    labelColor: Colors.black,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 6),
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: [AutofillHints.email],
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (emailController.text == '') {
                                    return 'This is a required field';
                                  }
                                  /* EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email";*/
                                },
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(color: Colors.blue, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Color.fromARGB(254, 57, 40, 71)),
                                  ),
                                  label: Row(children: const [
                                    Text(
                                      'Email',
                                      style: TextStyle(color: Color.fromARGB(254, 57, 40, 71), fontSize: 20),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(color: Colors.red, fontSize: 20),
                                    ),
                                  ]),
                                  hintText: 'example@gmail.com',
                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 158, 156, 156), fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                color: Colors.red,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() == true) {
                                    signUp();
                                  }
                                },
                                child: const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                              child: TextFormField(
                                controller: phoneController,
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.number,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.length != 10 && value.isNotEmpty) {
                                    return 'phone number must contain 10 numbers';
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(color: Colors.blue, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Color.fromARGB(254, 57, 40, 71)),
                                  ),
                                  label: Row(children: const [
                                    Text(
                                      'Phone',
                                      style: TextStyle(color: Color.fromARGB(254, 57, 40, 71), fontSize: 20),
                                    ),
                                  ]),
                                  prefixIcon: const Icon(Icons.phone),
                                  hintText: 'Your phone number',
                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 158, 156, 156), fontSize: 20),
                                ),
                              ),
                            ),
                            Center(
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                color: Colors.red,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() == true) {
                                    signUp();
                                  }
                                },
                                child: const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account..?  ",
                        style: TextStyle(fontSize: 16),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('login');
                                  },
                                text: 'Log In',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 17))
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {}
}