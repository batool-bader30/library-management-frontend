import 'package:flutter/material.dart';
import 'package:library_management_web_front/data/models/responses/user.dart';
import 'package:library_management_web_front/views/screens/AuthorDetailsScreen.dart';
import 'package:library_management_web_front/views/screens/BookDetailsPage.dart';
import 'package:library_management_web_front/views/screens/BorrpowingHistory.dart';
import 'package:library_management_web_front/views/screens/CreateAccount.dart';
import 'package:library_management_web_front/views/screens/Home/homapage.dart';
import 'package:library_management_web_front/views/screens/Reviewspage.dart';
import 'package:library_management_web_front/views/screens/aboutus.dart';
import 'package:library_management_web_front/views/screens/admin/AdminDashboardPage.dart';
import 'package:library_management_web_front/views/screens/admin/AuthorsManagementScreen.dart';
import 'package:library_management_web_front/views/screens/admin/BookManagemenpaget.dart';
import 'package:library_management_web_front/views/screens/admin/UserManagementScreen.dart';
import 'package:library_management_web_front/views/screens/feedback.dart';
import 'package:library_management_web_front/views/screens/login.dart';
import 'package:library_management_web_front/views/screens/profilepage.dart';
import 'package:library_management_web_front/views/screens/read_hub_home_page/homepage.dart';

import '../../views/screens/admin/Userinfo.dart';

class NavigatorUtils {
  static void navigateToCreateAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const CreateAccountScreen()),
    );
    
  }
  static void navigateToLogInScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>const LoginScreen()),
    );
    
  }
  static void navigareadhybhomInScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>const ReadHubHomePage()),
    );
    
  }
  static void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>const HomePage()),
    );
    
  }

  static void navigateToBorrowingHistoryScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>const BorrowingHistoryScreen()),
    );
    
  }
  static void navigateToFeedbackScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const FeedbackScreen()),
      
    );
    
  }
  static void navigateToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const UserProfileScreen()),
    );
    
  }
   static void navigateToBookDetailsScreen(BuildContext context,id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailsScreen(id: id,)),
    );
    
  }
  static void navigateToReviewsScreen(BuildContext context,bookid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewsScreen(bookid: bookid,)),
    );
    
  }
   static void navigateToAuthorDetailsScreen(BuildContext context,id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authordetailsscreen(id: id,)),
    );
    
  }
  static void navigateToBookManagementScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BooksManagementScreen()),
    );
    
  }
   static void navigateToAuthorManagementScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Authorsmanagementscreen()),
    );
    
  }
   static void navigateToAboutUsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
    );
    
  }
   static void navigateToUsersManagementScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Usermanagementscreen()),
    );
    
  }
   static void navigateToUserInfoScreen(BuildContext context,user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  UserProfilePage(user: user,)),
    );
    
  }
   static void navigateToOverviewScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  AdminDashboardScreen()),
    );
    
  }

  
}
