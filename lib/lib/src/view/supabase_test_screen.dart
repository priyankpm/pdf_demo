import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whiskers_flutter_app/src/common_utility/raise_for_status.dart';

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() => _SupabaseTestScreenState();
}

class _SupabaseTestScreenState extends State<SupabaseTestScreen> {
  void runTestRequest() async {
    print('Running test request to Supabase...');
    final supabase = Supabase.instance;
    try {
      FunctionResponse response = await supabase.client.functions.invoke(
          "reminders",
          body: {
            "Title": "Ahan's Test Task 2",
            "RemindAt": "00:00:00+05:30",
            // "ReminderFor": "user",
          },
          method: HttpMethod.post
      );
      print('Response from Supabase: ${response.data}');
      setState(() {
        responseText = response.data.toString();
      });
    } on FunctionException catch (fe) {
      raiseForStatus(fe, context);
      return;
    } catch (e) {
      print('Error during Supabase request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during Supabase request: $e'),
        ),
      );
      return;
    }
  }

  String responseText = 'Send request to see response here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Supabase Test Screen'),
          MaterialButton(
            child: Text('Run Test Request'),
            color: Colors.blue,
            onPressed: runTestRequest,
          ),
          AutoSizeText(
            responseText,
            maxLines: 8,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 32),
          ),
        ],
      ),
    );
  }
}
