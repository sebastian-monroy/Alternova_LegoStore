import 'package:alternova_prueba/providers/login_form_provider.dart';
import 'package:alternova_prueba/providers/theme_provider.dart';
import 'package:alternova_prueba/services/auth_service.dart';
import 'package:alternova_prueba/ui/input_decorations.dart';
import 'package:alternova_prueba/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox( height: 250,),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Ingreso', style: Theme.of(context).textTheme.headlineSmall,),
                    SizedBox(height: 30,),

                    ChangeNotifierProvider(
                      create: (_)=> LoginFormProvider(),
                      child: _LoginForm(),
                    )
                    

                  ],
                ),
              ),
              SizedBox(height: 50),
            TextButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'login');
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(StadiumBorder())
              ),
              child: Text(
                '¿Ya tienes una cuenta?', 
                style: TextStyle(
                  fontSize: 18, 
                  color: isDarkMode ? Colors.white : Colors.black87
                ),
              )
            ),
              SizedBox(height: 50),
            ],
          ),
        )
      )
    );
  }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final loginform = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginform.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'example@gmail.com',
                labelText: 'Correo Electronico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: (value) => loginform.email = value,
              validator: (value){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                ? null
                : 'El valor ingresado no luce como correo';
              },
            ),

            SizedBox(height: 30,),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: (value) => loginform.password = value,
              validator: (value) {
                return (value != null && value.length >= 6) 
                ? null
                : 'la contraseña debe de ser de 6 caracteres';
              },
            ),

            SizedBox(height: 30,),


            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
              onPressed: loginform.isloading ? null: () async {

                FocusScope.of(context).unfocus();

                final authService = Provider.of<AuthService>(context, listen: false);

                if( !loginform.isValidForm()) return;

                loginform.isLoading = true;

                final String? errorMessage = await authService.createUser(loginform.email, loginform.password);

                if (errorMessage == null){
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  print(errorMessage);
                }

                loginform.isLoading = false;

              }
              
            )
          ],
        ),
      ),
    );
  }
}