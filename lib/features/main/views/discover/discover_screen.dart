import 'package:collab/features/main/views/home/home_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  final _searchController = TextEditingController();
  int _selectedIndex = 1;


  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  _buildSearchBar(),
        actions: [

        ],
      ),
      body: Stack(

        children: [
          ListView.builder(
              itemCount: 10,
              itemBuilder: (context,index)
              {
                return Container(
                  height: size.height * 0.4,
                  margin: EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 0.1,
                        offset: const Offset(0,2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.2,
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage('assets/images/home/piano.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                              right: 70,
                              bottom: 10,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: (){},
                                  icon: const Icon(Icons.ios_share
                                  ),
                                  color: KAppColors.kPrimary,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 10,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: (){},
                                  icon: const Icon(Icons.favorite_border_outlined
                                  ),
                                  color: KAppColors.kPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: KAppColors.kPrimary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Image.asset('assets/icons/google.png', width: 20, height: 20, fit: BoxFit.fill,),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text('Olivia Oscar', style: TextStyle(fontSize: 16),
                          ),

                        ],
                      ),
                      SizedBox(height: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text('Vintage Piano', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),),
                          SizedBox(height: 30,),
                          Container(
                            height: 3.48,
                            width: 358,
                            child: Center(
                              child: LinearProgressIndicator(
                                color: Colors.deepPurple,
                                value: 0.7,

                              ),

                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 21,
                            width: 358.18,
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.gift),
                                SizedBox(width: 5,height: 5,),
                                Text("150\$ Backed"),
                                Expanded(child:
                                Text("70%",textAlign: TextAlign.end,),)
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
          //custom floating dock
          Align(alignment: Alignment.bottomCenter,child: _navbar(),)



        ],


      ),
    );

  }
  Widget _navbar(){
    return Container(

      margin: const EdgeInsets.only(
          right: 24,
          bottom: 24,
          left: 24

      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(75),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Adjust shadow color
            spreadRadius: 3, // Adjust spread
            blurRadius: 5,  // Adjust blur
            offset: Offset(0, 3), // Adjust offset for direction
          ),
        ],
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
          child: GNav(

              tabActiveBorder: Border.all(color: Colors.deepPurple, width: 1),
              style: GnavStyle.google,
              padding: EdgeInsets.all(16),
              gap: 8,
              activeColor: Colors.deepPurple,
              tabs: [

                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Home',
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const HomeScreen();
                        },
                      ),
                    );
                  },
                ),
                GButton(
                  icon: CupertinoIcons.compass,
                  text: 'Discover',


                ),
                GButton(
                  icon: CupertinoIcons.add,
                  text: 'New',
                ),
                GButton(
                  icon: CupertinoIcons.chat_bubble,
                  text: 'Chat',
                ),
                GButton(
                  icon: CupertinoIcons.profile_circled,
                  text: 'Profile',
                )
              ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

          )
      ),
    );
  }


}