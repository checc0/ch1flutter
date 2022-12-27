import 'package:flutter/material.dart';
import 'appConfig.dart';
import 'dart:developer';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return SafeArea(
        child: Scaffold(
      //appBar: AppBar(
      //  title: const Text(appTitle),
      //),
      body: const SettingsForm(),
    ));
  }
}

// Create a Form widget.
class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  SettingsFormState createState() {
    return SettingsFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class SettingsFormState extends State<SettingsForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GraphQL Endpoint
          TextFormField(
            onSaved: (newValue) {
              appConfig.setAppRootID(newValue);
              log("savd");
            },
            initialValue: appConfig.getChEndPoint(),
            maxLines: null,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'GraphQL endpoint',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid graphql endpoint';
              }

              if (!Uri.parse(value).host.isNotEmpty) {
                return 'Please use valid url';
              }

              return null;
            },
          ),
          // Tokeb
          TextFormField(
            onSaved: (newValue) {
              appConfig.setToken(newValue);
            },

            maxLines: null,
            initialValue: appConfig.getToken(),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'X-GQL-Token',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid token';
              }

              return null;
            },
          ),
          TextFormField(
            onSaved: (newValue) {
              appConfig.setAppRootID(newValue);
            },
            maxLines: null,
            initialValue: appConfig.getAppRootID(),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Application ID',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid application id';
              }

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings saved')),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Confirm'),
                )),
                Spacer(flex: 1),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
