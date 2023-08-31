import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/profileImg.jpeg'),
                      backgroundColor: Colors.orange,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 40),
                        title: Text('TRACKER',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color:
                                      const Color.fromARGB(255, 183, 115, 14),
                                )),
                        subtitle: Text('Developed by Team',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.orange,
                                )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                itemDashboard(
                  'ABOUT',
                  CupertinoIcons.question,
                  Colors.white70,
                  () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const AboutPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                itemDashboard(
                  'DEVELOPERS',
                  CupertinoIcons.device_phone_portrait,
                  Colors.white,
                  () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const DeveloperPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset(0.0, 0.0);
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                itemDashboard('GITHUB', CupertinoIcons.device_laptop,
                    Colors.white, _launchGitHubUrl),
                const SizedBox(height: 20),
                itemDashboard('BLOGS', CupertinoIcons.mail, Colors.white, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BlogsPage()));
                }),
                const SizedBox(height: 20),
                itemDashboard(
                    'FEEDBACK', CupertinoIcons.reply_thick_solid, Colors.white,
                    () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FeedbackForm(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset(0.0, 0.0);
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Version 1.1.0',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 121, 117, 112),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDashboard(
      String title, IconData iconData, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Icon(
          iconData,
          size: 30,
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Colors.orange,
        ),
        tileColor: color,
        onTap: onTap,
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('About'),
        backgroundColor: const Color.fromARGB(255, 231, 129, 19),
        elevation: 50,
      ),
      body: const Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight),
            Text(
              'Tracker App',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat\\',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.1.0',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'Proxima Nova',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Developed by an Awesome Team',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'Proxima Nova',
              ),
            ),
            SizedBox(height: 24),
            Text(
              'The GPS App using Arduino is an exciting and educational project that combines hardware and software to create a basic GPS tracking and display system. By integrating an Arduino board with a GPS module, this project allows you to retrieve location data from satellites and display it in a human-readable format. Whether it\'s monitoring your journey on a computer through the Arduino IDE Serial Monitor or using an optional display module, such as on a phone or laptop screen, this app empowers you to explore the world around you with technology.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Proxima Nova',
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developers'),
        backgroundColor: const Color.fromARGB(255, 231, 129, 19),
        elevation: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRectangleBox(
              'ROHIT KUMAR',
              'Mobile App Developer',
              '',
              FontAwesomeIcons.github,
              FontAwesomeIcons.linkedin,
              'assets/profile1.jpg',
            ),
            const SizedBox(height: 20),
            _buildRectangleBox(
              'SIDHANT RAJ',
              'Mobile App Developer',
              '',
              FontAwesomeIcons.github,
              FontAwesomeIcons.linkedin,
              'assets/profile2.jpg',
            ),
            const SizedBox(height: 20),
            _buildRectangleBox(
              'JAYAM GUPTA',
              'UI/UX Designer',
              '',
              FontAwesomeIcons.github,
              FontAwesomeIcons.linkedin,
              'assets/profile3.jpg',
            ),
            const SizedBox(height: 20),
            _buildRectangleBox(
              'ADITYA BANKA',
              'Software Engineer',
              '',
              FontAwesomeIcons.github,
              FontAwesomeIcons.linkedin,
              'assets/profile4.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRectangleBox(String title, String role, String description,
      IconData githubIcon, IconData linkedinIcon, String imagePath) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(4, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 70),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 0),
              Row(
                children: [
                  Icon(githubIcon, size: 30),
                  const SizedBox(width: 20),
                  Icon(linkedinIcon, size: 30, color: Colors.blue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BlogsPage extends StatelessWidget {
  const BlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: const Center(
        child: Text('Blogs Page Content'),
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Color.fromARGB(255, 231, 129, 19),
        elevation: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(labelText: 'Feedback'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GitHub URL
Uri githubUrl = Uri.parse('https://github.com/Sidhant-raj/Tracker');

// Function to open the GitHub URL
Future<void> _launchGitHubUrl() async {
  if (await canLaunchUrl(githubUrl)) {
    await launchUrl(githubUrl);
  } else {
    throw 'Could not launch $githubUrl';
  }
}
