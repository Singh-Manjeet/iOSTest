# iOSTest - User Stories
1. User can see the current location
2. User can save a note / remark for current location
3. User can see all notes / remarks added by him and other users on Map.
4. User can search for a note / remark on the basis of username and text.

# Installation guide

* Clone the project
* Open `Terminal` and `cd` to the project directory
* Run `pod install` 
* Wait for it to finish
* Open the `LandmarkRemark.xcworkspace` file

## Approach Used
Implemented the complete functionality mentioned in the User Stories.
1. Created an appropriate architecture, i.e. MVVM and extended it with a Router.
2. As suggested, i did use Realm Cloud - Trial for Data persistance, otherwise i would have used CoreData.
But i found Realm very cool.
3. To enable the User to view or delete the remarks added earlier, I have used a separate view controller ( Instead of just showing these over Map), Which offer better user convenience. 
4. Added an onboarding screen to let the user have a quick explaination of what the current screen offers. The intention was not to beautify but to make it more user friendly.
5. Each module serves their own role and can be tested accordingly.
6. For Listing, i have a VM but i further separated the datasource from the TableViewController. making it more modular.
7. I have extended the way we bind the TableViewDataSource with data ( mostly with viewModels ) by binding a cell with cellTypes, which can be a Loading Cell, An error cell or the DataCell. So when data takes much longer, we can display a nice animated cell instead of just showing a loading indicator over the screen. Same for an error cell. 
8. Added appropriate cocoa pods.
9. I have added individual storyboards instead of a common one. I found this as a solution to common issue of having a single storyboard, This is more convenient as we can work with Routers.

## Time Spent
Combined hours : 12-13 Hours

## Known Issues : 
Have not spent time on Unit tests.  But i can implement appropriate tests  :-)


## Swift Language Version Used:
Swift 5.0, Hurray !!

## Xcode Version
Xcode 10.2.1

## iPhone App:
The app works on all iPhone's in Portrait only.

## Reusable:
Added appropriate extension for UITableViewCells reusability.
The cleanest solution i have come up to dequeue the cells.

## Pods Used :
Realm & RealmSwift - For backend support
SwiftLint - to enforce Swift style and conventions

## Backend Used:
Realm Mobile Platform: Free trial

## Storyboards
The app contains storyboards
