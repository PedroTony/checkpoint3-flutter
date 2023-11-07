import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import '../models/user.dart';

class FollowingPage extends StatefulWidget {
  final User user;

  const FollowingPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final api = GitHubApi();
  late Future<List<User>> _futureFollowings;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureFollowings = api.getFollowing(widget.user.login);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildUserWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.user.avatarUrl),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.user.login,
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingWidget() {
    return FutureBuilder<List<User>>(
      future: _futureFollowings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var followings = snapshot.data ?? [];
          return ListView.builder(
            itemCount: followings.length,
            itemBuilder: (context, index) {
              var user = followings[index];
              return ListTile(
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
                title: Text(user.login),
                trailing: const Text(
                  "Following",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No followers found.'));
        }
      },
    );
  }

  Widget _buildRepositoryWidget() {
    // Placeholder para o widget de repositórios
    return Center(child: Text('Repositórios'));
  }

  List<Text> title = [
    const Text("Usuário"),
    const Text("Seguindo"),
    const Text("Repositórios"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title[_selectedIndex],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          _buildUserWidget(),
          _buildFollowingWidget(),
          _buildRepositoryWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: 'Seguindo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined), label: 'Repositórios'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
