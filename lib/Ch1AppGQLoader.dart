import 'package:ch1flutter/appConfig.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

//const chEndPoint = String.fromEnvironment('chEndPoint',
//    defaultValue:
//        'https://content-api.sitecorecloud.io/api/content/v1/preview/graphql');

// X-GQL-Token
//const chToken = String.fromEnvironment('chToken',
//    defaultValue:
//        'SmNmakFPVXlzUzAxRzkrR0E2bjBjQ3ZJL3d3Sk5OUTdkNlFsRGtCSUxpZz18aGMtc2FsZXMtMTItZWEtZjEwOTQ=');

//const chAppRootID = String.fromEnvironment('chAppRootID',
//    defaultValue: 'Libej7UF9EW9UJUnY5FoNg');

// Portal cloud: https://portal.sitecorecloud.io/
// Content hub one: https://content.sitecorecloud.io/?tenantName=hc-sales-12-ea-f1094
//
// Graphql Playground https://content-api.sitecorecloud.io/api/content/v1/preview/graphql/ide/
//
// {
//   "X-GQL-Token":"SmNmakFPVXlzUzAxRzkrR0E2bjBjQ3ZJL3d3Sk5OUTdkNlFsRGtCSUxpZz18aGMtc2FsZXMtMTItZWEtZjEwOTQ="
// }

String readAppRoot = """
{
  approot(id: "${appConfig.getAppRootID()}") {
    appTitle
    appIntroText
    heroes {
      results {
        ... on Fdeheroimage {
          longTitle
          description
          heroMessage
          heroimage {
            results {
              fileUrl
            }
          }
        }
      }
    }
    sections {
      results {
        ... on Chpage {
          title,
          summary,
          materialIconName,
          body,
          issueDate,
          image {
            results{
              fileUrl
            }
          }
        }
      }
    }
  }
}

""";

//
// Create ch1 graphql client
//
GraphQLClient _createGQClient() {
  HttpLink httpLink = HttpLink(
    appConfig.getChEndPoint(),
    defaultHeaders: {
      'X-GQL-Token': appConfig.getToken(),
    },
  );

  // Create GraphQLClient
  return GraphQLClient(
    link: httpLink,
    // The default store is the InMemoryStore, which does NOT persist to disk
    //cache: GraphQLCache(store: HiveStore()),
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
      subscribe: Policies(fetch: FetchPolicy.noCache),
      watchMutation: Policies(fetch: FetchPolicy.noCache),
      watchQuery: Policies(fetch: FetchPolicy.noCache),
    ),
  );
}

// This is the graphql loader for the app, this widget load the app or return an informative/error widget
//
//
class Ch1AppGQLoader extends StatefulWidget {
  // Callback function to create the application widget, this function will be invoked as a constructor
  // the function accept a map object of the json app and a callback function to force the reload of the app self
  final Widget Function(Map node, VoidCallback updateFunction)
      applicationBuilder;

  const Ch1AppGQLoader({super.key, required this.applicationBuilder});

  @override
  _Ch1AppGQLoader createState() => _Ch1AppGQLoader();
}

class _Ch1AppGQLoader extends State<Ch1AppGQLoader> {
  // An helper function to create the material app with an error message in case
  // of failure or else call a cosntruct function
  Widget _createErrorMessage(String message) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
        debugShowCheckedModeBanner: false,
        home: Center(
          child: Text(message),
        ));
  }

  void _reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Create our GQ edge
    ValueNotifier<GraphQLClient> client = ValueNotifier(_createGQClient());

    // Query Options
    QueryOptions queryOpts = QueryOptions(
      document: gql(readAppRoot),
      // only return result from network
      fetchPolicy: FetchPolicy.networkOnly,
    );

    // Return a loading information widget or error, the applicationBuilder
    // function is invoked when results are ready
    return GraphQLProvider(
      client: client,
      child: Query(
          options: queryOpts,
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            // Set the app title with the exception information if something goes wrong
            if (result.hasException) {
              log("Exception: ${result.exception.toString()}");
              return _createErrorMessage(result.exception.toString());
            }

            // just show app loading
            if (result.isLoading) {
              return MaterialApp(
                theme: ThemeData.dark()
                    .copyWith(scaffoldBackgroundColor: darkBlue),
                debugShowCheckedModeBanner: false,
                home: const Center(child: CircularProgressIndicator()),
              );
            }

            // Get AppTitle and Image link from the json
            if (result.data == null) {
              return _createErrorMessage("No results.");
            }

            // Create the ch1 main view, the updateresult function is used to let the view update this the wrapper query (this widget)
            return widget.applicationBuilder(result.data?['approot'], () {
              // Force the reload of data.
              _reload();
            });
          }),
    );
  }
}
