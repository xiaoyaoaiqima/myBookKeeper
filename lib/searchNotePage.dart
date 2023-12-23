import 'package:flutter/material.dart';
import 'package:mytest3/utils/Myformat.dart';
import 'package:provider/provider.dart';

import 'Provider/user_provider.dart';
import 'db/AccountBean.dart';
import 'db/openDB.dart';

class SearchNotePage extends StatefulWidget {
  final DatabaseManager dbManager;
  const SearchNotePage({super.key, required this.dbManager});

  @override
  _SearchNotePageState createState() => _SearchNotePageState();
}

class _SearchNotePageState extends State<SearchNotePage> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<AccountBean>> _searchResult = Future.value([]);

  void _search(String username) {
    setState(() {
      _searchResult = widget.dbManager.searchNote(
        username,
        _controller.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20,),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: '输入备注',
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _search(currentUser.name);
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<AccountBean>>(
                future: _searchResult,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.isEmpty) {
                    return const Text('没有结果');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return buildResult(context,snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}