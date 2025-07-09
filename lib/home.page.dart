import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Page",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          height: 400,
          //color: Colors.black12,
          width: 400,
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("images/logo_barca.jpeg"),
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: loginController,
                    decoration: InputDecoration(
                      //icon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      //icon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String userName = loginController.text;
                        String password = passwordController.text;
                        if (userName == "admin" && password == "1234") {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/chat');
                        }
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
