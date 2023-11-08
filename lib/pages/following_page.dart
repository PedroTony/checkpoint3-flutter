import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/repos.dart';
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
  late Future<List<User>> _futureFollowers;
  late Future<List<Repos>> _futureRepos;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureFollowings = api.getFollowing(widget.user.login);
    _futureFollowers = api.getFollowers(widget.user.login);
    _futureRepos = api.getRepos(widget.user.login);
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
                const SizedBox(height: 50),
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
          return const Center(child: Text('No Following users found.'));
        }
      },
    );
  }

  Widget _buildFollowersWidget() {
    return FutureBuilder<List<User>>(
      future: _futureFollowers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var follower = snapshot.data ?? [];
          return ListView.builder(
            itemCount: follower.length,
            itemBuilder: (context, index) {
              var user = follower[index];
              return ListTile(
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
                title: Text(user.login),
                trailing: Text(
                  "Follower",
                  style: TextStyle(color: Colors.blueAccent.shade700),
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
    return FutureBuilder<List<Repos>>(
      future: _futureRepos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var repository = snapshot.data ?? [];
          return ListView.builder(
            itemCount: repository.length,
            itemBuilder: (context, index) {
              var user = repository[index];
              return ListTile(
                title: Text(user.name),
                trailing: Text(
                  "Repositório ${index + 1}",
                  style: TextStyle(color: Colors.blueAccent.shade700),
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

  List<Text> title = [
    const Text("Usuário"),
    const Text("Seguindo"),
    const Text("Seguidores"),
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
          _buildFollowersWidget(),
          _buildRepositoryWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: 'Seguindo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt), label: 'Seguidores'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined), label: 'Repositórios'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
