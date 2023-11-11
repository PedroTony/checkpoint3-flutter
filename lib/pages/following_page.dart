import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/gists.dart';
import 'package:github_api_demo/models/repos.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late Future<List<Gists>> _futureGists;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureFollowings = api.getFollowing(widget.user.login);
    _futureFollowers = api.getFollowers(widget.user.login);
    _futureRepos = api.getRepos(widget.user.login);
    _futureGists = api.getGists(widget.user.login);
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
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                  "Seguindo",
                  style: TextStyle(color: Color.fromRGBO(255, 145, 0, 1)),
                ),
              );
            },
          );
        } else {
          return const Center(
              child: Text('Nenhum usuário sendo seguido encontrado'));
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
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var follower = snapshot.data ?? [];
          return ListView.builder(
            itemCount: follower.length,
            itemBuilder: (context, index) {
              var user = follower[index];
              return ListTile(
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
                title: Text(user.login),
                trailing: const Text(
                  "Seguidor",
                  style: TextStyle(color: Color.fromRGBO(199, 113, 0, 1)),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Nenhum seguidor encontrado'));
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
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var repository = snapshot.data ?? [];
          return ListView.builder(
            itemCount: repository.length,
            itemBuilder: (context, index) {
              var user = repository[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.htmlUrl),
                onTap: () {
                  launchUrl(Uri.parse(user.htmlUrl));
                },
                trailing: Text(
                  "Repositório ${index + 1}",
                  style: const TextStyle(color: Color.fromRGBO(156, 89, 0, 1)),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Nenhum repositório encontrado.'));
        }
      },
    );
  }

  Widget _buildGistsWidget() {
    return FutureBuilder<List<Gists>>(
      future: _futureGists,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var repository = snapshot.data ?? [];
          return ListView.builder(
            itemCount: repository.length,
            itemBuilder: (context, index) {
              var user = repository[index];
              return ListTile(
                title: Text(user.filename),
                subtitle: Text(user.htmlUrl),
                onTap: () {
                  launchUrl(Uri.parse(user.htmlUrl));
                },
                trailing: Text(
                  "Gist ${index + 1}",
                  style: const TextStyle(color: Color.fromRGBO(156, 89, 0, 1)),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Nenhum Gist encontrado.'));
        }
      },
    );
  }

  List<Text> title = [
    const Text("Usuário"),
    const Text("Seguindo"),
    const Text("Seguidores"),
    const Text("Repositórios"),
    const Text("Gists"),
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
          _buildGistsWidget(),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox_sharp), label: 'Gists'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
