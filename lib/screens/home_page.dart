import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: userData.when(
          data: (userData) {
            List<UserModel> userList = userData.map((e) => e).toList();
            return ListView.builder(
              itemCount: userList.length,
                itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(
                        '${userList[index].firstName}  ${userList[index].lastName}',

                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                      subtitle: Text(
                        '${userList[index].email}',
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          userList[index].avatar.toString()
                        ),
                      ),
                    ),
                  )
                );
                }
            );
          },
          error: (error, s) => Text(error.toString()),
          loading: ()=> const Center(
            child: CircularProgressIndicator(),
          )
      ),
    );
  }
}

class ApiService {
  String userUrl = 'https://reqres.in/api/users?page=2';

  Future<List<UserModel>> getUsers() async {
    Response response = await get(Uri.parse(userUrl));
    if(response.statusCode == 20) {
      final List result = jsonDecode(response.body)['data'];

      return result.map((e) => UserModel.fromJson(e)).toList();

    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final userProvider = Provider<ApiService>((ref) => ApiService());

final userDataProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(userProvider).getUsers();
});


class UserModel {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  UserModel({this.id, this.email, this.firstName, this.lastName, this.avatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }
}