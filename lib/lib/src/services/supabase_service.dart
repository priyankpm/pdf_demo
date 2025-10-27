import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton instance
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // ------------------------
  // CORE INVOKE METHOD
  // ------------------------
  Future<dynamic> _invokeFunction({
    required BuildContext context,
    required String functionName,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.functions.invoke(
        functionName,
        method: method,
        body: body,
        headers: headers,
      );

      debugPrint("✅ Supabase [$method] '$functionName' response: ${response.data}");
      return response.data;

    } on FunctionException catch (fe) {
      print('===fe=====${fe}');
      // Custom handler for Supabase function exceptions
      _raiseForStatus(fe, context);
      return null;

    } catch (e) {
      // Unexpected error handler
      debugPrint('❌ Exception during Supabase request: $e');
      _showSnackBar(context, 'Unexpected error: $e');
      return null;
    }
  }

  // ------------------------
  // PUBLIC METHODS
  // ------------------------
  Future<dynamic> get(
      BuildContext context, {
        required String functionName,
        Map<String, String>? headers,
      }) {
    return _invokeFunction(
      context: context,
      functionName: functionName,
      method: HttpMethod.get,
      headers: headers,
    );
  }

  Future<dynamic> post(
      BuildContext context, {
        required String functionName,
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) {
    return _invokeFunction(
      context: context,
      functionName: functionName,
      method: HttpMethod.post,
      body: body,
      headers: headers,
    );
  }

  Future<dynamic> put(
      BuildContext context, {
        required String functionName,
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) {
    return _invokeFunction(
      context: context,
      functionName: functionName,
      method: HttpMethod.put,
      body: body,
      headers: headers,
    );
  }

  Future<dynamic> patch(
      BuildContext context, {
        required String functionName,
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) {
    return _invokeFunction(
      context: context,
      functionName: functionName,
      method: HttpMethod.patch,
      body: body,
      headers: headers,
    );
  }

  Future<dynamic> delete(
      BuildContext context, {
        required String functionName,
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) {
    return _invokeFunction(
      context: context,
      functionName: functionName,
      method: HttpMethod.delete,
      body: body,
      headers: headers,
    );
  }

  // ------------------------
  // ERROR HANDLING
  // ------------------------
  void _raiseForStatus(FunctionException exception, BuildContext context) {
    final int statusCode = exception.status;
    debugPrint("❌ Supabase Error [$statusCode]: ${exception.details}");

    if (statusCode == 401) {
      _showSnackBar(context, 'Unauthorized. Please log in again.');
      // TODO: Navigate to login / reset session if needed
    } else if (statusCode == 400) {
      _showSnackBar(context, 'Bad request: ${exception.details}');
    } else if (statusCode == 404) {
      _showSnackBar(context, 'Function not found or invalid endpoint.');
    } else if (statusCode >= 500) {
      _showSnackBar(context, 'Server error: ${exception.details}');
    } else {
      _showSnackBar(context, 'Error: ${exception.details} (code: $statusCode)');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
