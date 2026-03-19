import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void handleSubmit() {
    final username = usernameController.text;
    final password = passwordController.text;
    print("username: $username");
    print("password: $password");
    if (username=="admin" && password=="123") {
      context.go("/chat");
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid username or password")),
      );
    }

  }
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Local chat Home page")),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Padding(
              padding:EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child:TextField(controller: usernameController, decoration:InputDecoration(border: OutlineInputBorder(),hintText:'Username')
              ),
          ),
           Padding(
              padding:EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child:TextField(controller:passwordController, obscureText:true, decoration:InputDecoration(border: OutlineInputBorder(),hintText:'Password')
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 19),
            child: ElevatedButton(onPressed: handleSubmit, child: Text("Submit")),
          )
        ],
      )
    );
  }
}