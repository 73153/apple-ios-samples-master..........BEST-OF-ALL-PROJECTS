### LaunchMe ###

================================================================================
DESCRIPTION:

The LaunchMe sample application demonstrates how to implement a custom URL scheme to allow other applications to interact with your application.  It registers the "launchme" URL scheme, of which URLs contain an HTML color code (for example, #FF0000 or #F00).  The sample shows how to handle an incoming URL request by overriding -application:openURL:sourceApplication:annotation: to properly parse and extract information from the requested URL before updating the user interface.

Refer to the "Implementing Custom URL Schemes" section of the "iOS App Programming Guide" for information about registering a custom URL scheme, including an overview of the necessary info.plist keys.
<https://developer.apple.com/library/ios/redirect/DTS/CustomURLSchemes>

================================================================================
BUILD REQUIREMENTS:

iOS 6.0 SDK or later

================================================================================
RUNTIME REQUIREMENTS:

iOS 5.0 or later

================================================================================
PACKAGING LIST:

LaunchMeAppDelegate.{h,m}
    The application's delegate class.  Handles incoming URL requests.
    
RootViewController.{h,m}
    The application's root view controller.

================================================================================
CHANGES FROM PREVIOUS VERSIONS:

Version 1.7
- Now demonstrates a use case of custom URL schemes.
- Migrated to Storyboards and ARC.
- Upgraded to build with the iOS 6 SDK.
- Deployment target changed to iOS 5. 

Version 1.6
- Upgraded project to build with the iOS 4.0 SDK.

Version 1.5
- Updated for and tested with iPhone OS 2.0. First public release.

Version 1.4
- Updated for Beta 6.
- Added LSRequiresIPhoneOS key to Info.plist.

Version 1.3
- Updated for Beta 4.

Version 1.2
- Added code signing.
 
Version 1.1 
- Updated for Beta 3.

================================================================================
Copyright (C) 2008-2013 Apple Inc. All rights reserved.