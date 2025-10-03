
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final userRepoProvider = Provider<UserRepo>((ref) => UserRepo());
final userFutureProvider = FutureProvider.autoDispose.family<User, String>((ref, id) async {
  final cancel = CancelToken();
  ref.onDispose(cancel.cancel);

  final repo = ref.read(userRepoProvider);
  return repo.fetchUser(id, cancel);

});

class UserScreen extends ConsumerWidget{
  const UserScreen(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userFutureProvider(id));
    return asyncUser.when(
        data: (u)=> Text(u.name),
        error: (e, s)=> Text('Error: $e'),
        loading: ()=> const CircularProgressIndicator(),
    );
  }
}



class User {
  final String id;
  final String name;
  User(this.id, this.name);
}

class UserRepo{
  Future<User> fetchUser(String id, CancelToken token) async {
    for(int i =0; i<20; i++) {
      if(token.isCancelled) throw Exception("Cancelled");

      await Future.delayed(const Duration(microseconds: 50));
    }

    return User(id, 'RiverPod');
  }
}


class CancelToken{
  bool _cancelled = false;
  void cancel(){
    _cancelled = true;
  }
  bool get isCancelled=> _cancelled;
}