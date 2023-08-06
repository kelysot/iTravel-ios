# 🗻 iTravel-ios 🗽

<br />
<p align="center">
    <a href="https://github.com/barelimelech/iTravel-ios">
      <img src="https://i.ibb.co/jRr9g5K/logo.jpg" alt="Logo" width="150" heigt="150">
  </a>
 </p>
 
 <p align="center">
 This is our final project in ios applications course, as part of our B.Sc. Computer Science studies that Dr. Eliav Menachi taught. </br>
 The app is designed to share itineraries between app users.</br>
 The app is written in Swift using MVC architecture, remote server Firebase, Core Data, OpenWeatherMap - Weather API, and MapKit.
 </br> </br>
</p>

## App Functionality 💻

1. Implementation of Users Identification and Users Registration:
	- Authentication and validation inputs of the users when entering the app.
	- Future logins to the app after registeration will login the user automatically.
2. Implementation of Firebase Database Architecture
	- Data served by the app is handled by a ModelFirebase that implements Firebase.
	- Local data is saved in a singleton parmeter.
	- The users and posts images are saved in the Storage of Firebase.
3. Profile creation and editing - The user need to enter the profile information:
	- Basic details: full name, user name, email, password and photo.
4. Home page - The user can scroll and see the posts of the itineraries that were shared in the app.
5. Upload and edit a post - The user can upload a post about the itinerary he went to.
6. Delete post - The user can delete his posts.
7. Logout - The user can logout from the app.
8. Map - It is possible for the user to add a place to the map where he has been, and it is possible for him to view all the places that other users have visited.
9. Weather API - Based on the user's location, weather information can be displayed by hourly and weekly temperatures.

## Getting Started... 🏃

#### Installation
- Export git repository to Xcode
- Build and run the application on iOS emulator


## 📱 Screenshots 📱

Intro Page | Login Page |  Sign Up Page
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://i.ibb.co/4sq5RDr/intro.png" alt="Intro" width="300">  | <img src="https://i.ibb.co/Fwcv54r/login.png" alt="Login" width="300">  |  <img src="https://i.ibb.co/2skyVzs/signup.png" alt="signup" width="300">

Home Page | Post Page |  Create Post Page 
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://i.ibb.co/NLpyjvG/home.png" alt="Home" width="300">  | <img src="https://i.ibb.co/CHjwnYm/post.png" alt="Post" width="300">  |  <img src="https://i.ibb.co/wSqrz6S/add-post.png" alt="Create Post" width="300">

Add Location In Map Page |  Map Page |  Weather Page
:-------------------------:|:-------------------------: |:-------------------------:
<img src="https://i.ibb.co/H2FDSqP/map-add.png" alt="Add Location" width="300">  |  <img src="https://i.ibb.co/GCFMp3Y/map-all-location.png" alt="Map" width="300">  |  <img src="https://i.ibb.co/Bz6RtBL/Weather-week.png" alt="Weather" width="300">

Edit Post Page |  Profile Page |  Edit Profile Page
:-------------------------:|:-------------------------: |:-------------------------:
<img src="https://i.ibb.co/bWsvL4t/edit-post.png" alt="Edit Post" width="300">  |  <img src="https://i.ibb.co/WtszJ5h/profile.png" alt="Profile" width="300"> |  <img src="https://i.ibb.co/X8njWTM/edit-profile.png" alt="Edit Profile" width="300">

