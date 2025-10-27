import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void raiseForStatus(FunctionException exception, BuildContext context) async {
  final int statusCode = exception.status;
  print("Error from raiseForStatus: $exception with status code: $statusCode");

//   handle 401, take user back to login screen (maybe reset supabase)
//   if 400, show alertdialog with body
  if (statusCode == 401) {
    // Handle unauthorized error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unauthorized access. Please log in again.'),
      ),
    );
    // Navigate to login screen or reset Supabase client as needed
  } else if (statusCode == 400) {
    // Handle bad request error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bad request: ${exception.details}'),
      ),
    );
  } else {
    // Handle other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${exception.details} (Status code: $statusCode)'),
      ),
    );
  }

}