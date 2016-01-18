# Swiflytics

## Build Instructions

* First install pods using `$ pod install`

* Go to Google developer console : `https://console.developers.google.com/project`
* Click on "create project"
* Give project name : swiftlytics-demo
* Click on create

* Go to : https://developers.google.com/identity/sign-in/ios/start-integrating
* Click Get a configuration file button

* Select App name as project you created
* Enter bundle identifier: com.company.swiflytics
* Click next

* Click enable google sign-in button
* Click continue to generate configuration file
* Click download `GoogleService-Info.plist`
* Copy the file inside project root folder

* Open plist, copy `value` of REVERSED_CLIENT_ID , it'll look something like `com.googleusercontent.apps.*`
* Select project in Xcode Navigator
* Click Info tab
* Under URL Types click plus button
* In URL Schemes paste the above copied `REVERSED_CLIENT_ID`
* Change the first URL Types's URL Scheme to your bundle id (com.company.swiflytics)

* Build and Run
