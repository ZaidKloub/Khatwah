import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final List<Map<String, String>> teamMembers = [
    {
      'photo': 'asset/TeamPhotos/Salah.png',
      'name': 'Salah Al Abbadi',
      'linkedIn': 'https://www.linkedin.com/in/salah-alabbadi/',
      'facebook': 'https://www.facebook.com/salah.alslihat',
    },
    {
      'photo': 'asset/TeamPhotos/Assem.jpg',
      'name': 'Assem AL Hyari',
      'linkedIn': 'https://www.linkedin.com/in/assem-hyari/',
      'facebook': 'https://www.facebook.com/assem.hyari',
    },
    {
      'photo': 'asset/TeamPhotos/Zaid.png',
      'name': 'Zaid Kloub',
      'linkedIn': 'https://www.linkedin.com/in/zaid-kloub-20a4312a3/',
      'facebook': 'https://www.facebook.com/zaid.kloub.7',
    },
    {
      'photo': 'asset/TeamPhotos/Yosef.png',
      'name': 'Yosef Dabbas',
      'linkedIn': 'https://www.linkedin.com/in/yousef-aldabbas-81473b287/',
      'facebook': 'https://www.facebook.com/yosefdabbas1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Team',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF1A3C40),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: teamMembers.map((member) {
            return TeamMemberCard(
              memberPhoto: member['photo']!,
              memberName: member['name']!,
              linkedInUrl: member['linkedIn']!,
              facebookUrl: member['facebook']!,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String memberPhoto;
  final String memberName;
  final String linkedInUrl;
  final String facebookUrl;

  const TeamMemberCard({
    required this.memberPhoto,
    required this.memberName,
    required this.linkedInUrl,
    required this.facebookUrl,
    Key? key,
  }) : super(key: key);

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(memberPhoto),
            radius: 40,
          ),
          const SizedBox(height: 8),
          Text(
            memberName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.indigoAccent),
                onPressed: () => _launchURL(linkedInUrl),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                onPressed: () => _launchURL(facebookUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
