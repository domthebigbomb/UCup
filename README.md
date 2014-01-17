UCup
====

UCup iOS App

Hi! Welcome to the UCup Readme.

This app pulls from the following API/SDK:
-Firebase
-Spotify
-Yelp
-Facebook (to be implemented)

Upon launch, the user will be directed to a screen with 6 options:
1) Create a party
2) Find a party
3) Weather
4) Pregame music
5) Food
6) Feedback

Create a party:
Users will be directed to view where he/she can input various details of an upcoming party such as the name, location,
time, number of guests, and whether or not the event is private.

Join a party:
Users will be directed to a view that trys to connect to the firebase server and pull a list of existing parties in the area (Parties are currently not localized)

Weather:
To be implemented...

Pregram Music:
Opens up a music player powered by Spotify (users will need a Premium account). Default playlist is defined by Spotify's
"Pre-Party" playlist.

Food:
Users will be directed to a table that lists nearby food location sorted by closest locations first. Tapping a cell will 
direct the user to a more detailed oriented view that will allow users to call the location or bring up directions to 
location.

Feedback:
Open Mail.app with appropriate subject and sender fields
