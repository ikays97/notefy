# Home:

1. In this Section I have implemented "http" library for network calls and "shared_preferences" to store necessary data to local storage.

2. I used jsonplaceholder.typicode.com to fetch data and list in home page.

3. I saved the user search queries to local storage and updated the ui according using state management.

4. Once Search input field submitted, all data get fetched from network and returns appropriate list of posts to the view, this functionality could be done better, but for simplicity I found this ok.

# All Tasks and Complete Tasks

This section/screen you will need to demonstrate your skills related to state management. Please use a state management lib of your choice i.e provider, bloc, riverpod, getX etc.
Its a simple todo app where you will need to fetch data from firebase firestore and update the ui according to there completed status.
The user should be able to complete, read, update and delete the tasks i.e CRUD operations.
The data should be update according in firebase firestore as well as reflect in the ui according as soon as one of the operations is done. Try to notify the user by showing some sort of message based on there operations.

The ui should be updated accordingly based on the status completed for tasks. This state should updates the UI. Therefore you should be able to complete a task on the 'Tasks' page and it appears on the 'Completed Tasks' page

# Test Cases:

Unit and widget testings are done. They are under test folder.

# Additional

Even this is simple todo app, I have structured app with an production ready structure. Please check starting from entrance (app_service.dart) to the test folder and run the app and see the output in action. All actions shows message on there operations too.
