import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import '../../widget/ftext.dart';
import '../../models/user.dart';
import 'user_add.dart';
import 'user_detail.dart';

//ignore: must_be_immutable
class UserScreen extends StatelessWidget with ChangeNotifier {
  late List<User> _users;
  UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _users = context.watch<API>().users;
    return Scaffold(
      appBar: appBarSettings("Users"),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: new BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.3, color: Colors.grey)),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          NoTransition(
                            page: UserDetail(user: _users[index]),
                          ),
                        );
                      },
                      title: H2(
                        '${_users[index].userName}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              NoTransition(
                page: UserAdd(),
              ),
            );
          },
          child: H2("Add User"),
        ),
      ),
    );
  }
}