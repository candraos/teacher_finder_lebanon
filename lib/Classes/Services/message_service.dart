import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/message.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';

class MessageService with ChangeNotifier{
  final _supabase = Supabase.instance.client;
  Stream<List<dynamic>> getMessages(BuildContext context) {
    return _supabase.from("Message")
    .select()
    .or("user_from.eq.${context.read<LoginProvider>().user.id},user_to.eq.${context.read<LoginProvider>().user.id}")
    .order("created_at")
        .asStream()
        .map((maps) => maps
    .map((item) =>
    Message.fromJson(item, _supabase.auth.currentUser!.id)).toList());
  }

  Future<void> saveMessage(String content,String userToId,BuildContext context) async{
    final message = Message.create(
        content: content,
        userFrom: context.read<LoginProvider>().user.id,
        userTo: userToId
    );

    await _supabase.from("Message").insert(message.toMap());
  }
}