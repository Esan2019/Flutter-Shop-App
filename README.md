# Flutter Shop App

A Flutter cross-platform shop app.

### Features:
- 60fps animations
- Lots of gestures
- Lots of animations
- Login & Registration
- Smooth loading from back-end
- Browser the products catalog anonymously
- Favorites system
- Database with Google Firebase
- Cart & Orders system
- Admin product management (create, edit, delete products)

# How to run the app
### Obs.: if you don't want to run the app locally and just want to see it working, go to the preview section just below this one
Now, if you do want to run the app locally, you need to have Flutter SDK installed on your machine. If you don't, head over to the [official installation guide](https://flutter.dev/docs/get-started/install).

After installing Flutter SDK, follow these steps in order to run the application successfully:
1. Clone this repository or download the source code as ``.zip``
2. On the root folder of the project, run the following command to download the project dependencies: ``flutter pub get``
3. Now that you've downloaded the dependencies, the application is ready to go. Just run it with the following command: ``flutter run``

Note: for the third step, you need to have an AVD (Android Virtual Device) running on your machine, or a physical device connected via USB with debug permissions.
If you don't have any of these, here are some links on [how to set up and run an AVD](https://developer.android.com/studio/run/managing-avds) or [grant debug permission on a physical device](https://developer.android.com/studio/run/device).

# Preview the app
Warnings:
- Although in the "Features" section I stated that the animations are at 60 frames per second, the gifs shown below are at a lower frame rate due to file size restrictions
- It is possible to notice some kind of grid in the gifs, but it's only a recording bug, they're not visible in the app

### Welcome, login and registration page
<img src="https://i.imgur.com/zPGbIMI.gif" height="500px"> <img src="https://i.imgur.com/n9W0C3F.gif" height="500px"> <img src="https://i.imgur.com/qYypBgQ.gif" height="500px">

### Gestures and Product Management
- On the client side:
  - Slide a product from left to right to add/remove from cart
  - Double tap a product to add/remove from favorites (just like Instagram!)
  - Slide from the left side of the screen to go back
- On the admin product management:
  - Slide a product from left to right to edit it
  - Slide a product from right to left to delete it

<img src="https://i.imgur.com/8x4rKKG.gif" height="500px"> <img src="https://i.imgur.com/AUTgmvw.gif" height="500px">

### Product overview and No products found
<img src="https://i.imgur.com/x9N9jJj.gif" height="500px"> <img src="https://i.imgur.com/01W3Hot.gif" height="500px">

### Cart and Order System
<img src="https://i.imgur.com/wmChwUG.gif" height="500px">

### Anonymous browsing and Smooth loading
<img src="https://i.imgur.com/v13SyPM.gif" height="500px">
