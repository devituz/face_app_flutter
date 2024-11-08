import 'package:face/constants/colors.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/constants/sizedbox.dart';
import 'package:face/features/login/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  const Text('Login',style: TextStyle(color: Colors.teal),),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(

                        height: screenHeight * 0.09,
                        child: TextField(
                          cursorColor: Colors.teal,
                          maxLength: 9  , // Maksimal yozilishi mumkin bo'lgan raqamlar soni
                          controller: phoneController,

                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(

                            filled: true,
                            // Ichki rangni to'ldirish uchun
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            // hintText: 'Telefon raqamni kiriting',
                            prefixText: '+998 ',

                            labelText: 'Phone number',
                            labelStyle: const TextStyle(color: Colors.teal),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                              // Ichiga kirmasdan oldingi rang
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            counterText: '', // Hisoblagich matnini ko'rsatmaslik
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: screenWidth * 0.8,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenHeight * 0.09,
                        child: TextField(
                          cursorColor: Colors.teal,
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.teal),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.teal,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sizedBoxHeight25,
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  state.maybeWhen(
                    error: (message) {
                      Helpers.showCustomSnackBar(context, message);
                    },
                    success: () {},
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return state.when(
                    initial: () => SizedBox(
                      width: screenWidth * 0.8,
                      child: Container(
                        height: 45, // Tugma balandligi
                        child: ElevatedButton(
                          onPressed: () {

                            final phone = '+998' + phoneController.text;
                            final password = passwordController.text;
                            print('Yuborilgan telefon raqami: "$phone" ');
                            print('Yuborilgan parol: "$password" ');
                            context
                                .read<AuthCubit>()
                                .verifyOtp(phone, password, context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.teal,
                            // Tugma rangi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Tugma qirralarini yumshatish
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFEFEFE), // Matn rangi
                            ),
                          ),
                        ),
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                    success: () =>SizedBox(
                      width: screenWidth * 0.8,
                      child: Container(
                        height: 45, // Tugma balandligi
                        child: ElevatedButton(
                          onPressed: () {

                            final phone = '+998' + phoneController.text;
                            final password = passwordController.text;
                            print('Yuborilgan telefon raqami: "$phone" ');
                            print('Yuborilgan parol: "$password" ');
                            context
                                .read<AuthCubit>()
                                .verifyOtp(phone, password, context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.teal,
                            // Tugma rangi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Tugma qirralarini yumshatish
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFEFEFE), // Matn rangi
                            ),
                          ),
                        ),
                      ),
                    ),
                    error: (message) => SizedBox(
                      width: screenWidth * 0.8,
                      child: Container(
                        height: 45, // Tugma balandligi
                        child: ElevatedButton(
                          onPressed: () {

                            final phone = '+998' + phoneController.text;
                            final password = passwordController.text;
                            print('Yuborilgan telefon raqami: "$phone" ');
                            print('Yuborilgan parol: "$password" ');
                            context
                                .read<AuthCubit>()
                                .verifyOtp(phone, password, context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.teal,
                            // Tugma rangi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Tugma qirralarini yumshatish
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
