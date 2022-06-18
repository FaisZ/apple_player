# apple_player
 Apple player app

This app search tracks based on artist name and enable users to play the track previews.
The app uses API from https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html.

Supported Devices
- Tested on Nexus 5X API 33 Android Emulator
- Tested on Samsung S21

Features
- Search tracks based on artist
- Track list, album art, and track information
- Play and pause track previews from tracks
- Track playing progress bar and buffering bar
- Track seeking

Build Requirements
- run pub get after cloning this repository

Instructions to build and deploy
- run flutter build apk in terminal
- find the apk in build\app\outputs\flutter-apk\app-release.apk

Installation note:

The app is not registered in Google Play, therefore warnings on installation will be given. Please ignore the warnings, the app is safe.
Enable installation from unknown sources to enable installing APKs not from Google Play Store.
 