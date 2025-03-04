import 'package:flutter/material.dart';

class OurCollege extends StatefulWidget {
  const OurCollege({Key? key}) : super(key: key);

  @override
  State<OurCollege> createState() => _OurCollegeState();
}

class _OurCollegeState extends State<OurCollege> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        title: Text(
          'Our College',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF1A3C40),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("asset/شعار-خطوة-بنج2.png", width: 36),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset('asset/vision_assets/Collage_normal.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Establishment",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "The College of Information Technology was established at the inception of the university in 1997 under the name of the College of Applied Sciences. It was among the first colleges in the kingdom to offer a specialization in information technology.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Name Changes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "In 2004, the college's name was changed to the Prince Abdullah bin Ghazi College of Science and Information Technology, and in 2011, it was renamed the Prince Abdullah bin Ghazi College of Communications and Information Technology. Since its founding, the college has offered an information technology program.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Program Expansion",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Due to the rapid advancements in information technology sciences and their widespread use in various fields, the college began, in 2002, to divide this specialization into several major areas: Computer Science, Computer Information Systems, and Software Engineering at the bachelor's degree level, in addition to offering a master's program in Computer Science. In the second semester of the 2016/2017 academic year, a new specialization in computer graphics and animation was introduced at the bachelor's degree level.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Goals and Objectives",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "The goals of the Prince Abdullah bin Ghazi College of Communications and Information Technology are derived from the general objectives of Al-Balqa Applied University in keeping pace with scientific and technological development and adapting it to serve the Jordanian community. The college strives for excellence locally and globally in the field of information technology by offering diverse and distinguished academic programs that meet local and international standards of quality and accreditation, and fulfill the current and future needs of the job market.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
