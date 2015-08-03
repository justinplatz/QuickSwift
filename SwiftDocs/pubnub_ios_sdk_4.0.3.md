#PubNub iOS SDK 4.0.3
#Swift Guide

##How to Get It: Cocoapods
CocoaPods is a dependency manager for Objective-C projects and this is by far the easiest and quickest way to get started with PubNub iOS SDK!

Be sure you are running CocoaPods 0.26.2 or above! You can install the latest cocopods gem (If you don't have pods installed yet you can check CocoaPods installation section for installation guide):
	
	gem install cocoapods
	
If you've already installed you can upgrade to the latest cocoapods gem using:
	
	gem update cocoapods
	
PubNub SDK itself has dependencies on AFNetworking and CocoaLumberjack. These libraries will be added to your project as well.

##How to Get It: Git
Add the PubNub iOS SDK folder to your project.

##How to Get It: Source
https://github.com/pubnub/objective-c/

---
Also Available In The PubNub iOS Family:
Objective-C

---
##Hello World
To include PubNub iOS SDK in your project you need to use CocoaPods 
Install cocoapods gem by following the procedure defined under How to Get It.

To add the PubNub iOS SDK to your project with CocoaPods, there are three basic tasks to complete which are covered below:

1. Create new Xcode project.
2. Create Podfile in new Xcode project root folder
		
		touch Podfile
3.	Your Podfile should be in the root of the directory and look something like this:
<script src="https://gist.github.com/jzucker2/e4b7b9687e6b2b504518.js"></script>

If you have any other pods you’d like to include, they should be added to this Podfile. If you have other targets you’d like to add, like a test target, then you can add them to this Podfile. Cocoapods has great documentation for this on their site.


4. Install your pods by running “pod install” via the command line from the directory that contains your Podfile. Keep in mind, that after installing your Pods you should only be working within the workspace specified in your Podfile.

###How To Add Objective-C Bridging-Header

Now to add the bridging header

Great! You now have a Swift project with the PubNub SDK installed. So how do you access the PubNub SDK? With a [Swift Bridging Header](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html) of course! In order to install this, Apple has provided us with some handy shortcuts.

Create a new File (File -> New -> File) of type Objective-C File. Call this whatever you like because we will end up deleting this file. Here I have just called it willDelete.

When you see “Would you like to configure an Objective-C bridging header?” select Yes. 

There are now two small steps remaining. The first is to delete that unnecessary Objective-C file we just added (it’s easier to let Apple configure the header for us using this method than actually tweaking the project settings ourselves). So delete that file (I called mine willDelete.m)

Click on the File: YourProject-Bridging-Header.h. Underneath the commented code we need to add an #import to our project to use the PubNub iOS SDK. To do this we simply add the following lines into this file:

	        #import <PubNub/PubNub.h>

###Complete Application Delegate Configuration
Add the PNObjectEventListener protocol to AppDelegate
<script src="https://gist.github.com/justinplatz/7eceacfe28b3f76679d5.js"></script>

###Initialize the PN Instance, Subscribe and Publish a Message
<script src="https://gist.github.com/justinplatz/2a8fdb0a42612f425b6a.js"></script>

##Copy and paste examples:
###INIT
Instantiate a new PubNub instance. Only the subscribeKey is mandatory. Also include publishKey if you intend to publish from this instance, and the secretKey if you wish to perform PAM administrative operations from this instance.

***It is not a best practice to include the secret key in client-side code for security reasons.***

	let client : PubNub
	let config : PNConfiguration
	config = PNConfiguration(publishKey: "Your_Pub_Key", subscribeKey: "Your_Sub_Key")
  	client = PubNub.clientWithConfiguration(config)
  	
 ***PubNub instance should be placed as a property in a long-life object(otherwise PubNub instance will be automatically removed as autoreleased object). ***
 
 Not sure what to put here *****
 
###Time
Call timeWithCompletion to verify the client connectivity to the origin:
<script src="https://gist.github.com/justinplatz/f23097dbd63a5cd70b91.js"></script>

###Subscribe
Subscribe (listen on) a channel (it's async!):
<script src="https://gist.github.com/justinplatz/d081f5ecda368a78aac0.js"></script>

###Publish
Publish a message to a channel:
<script src="https://gist.github.com/justinplatz/064bc8c542f100b20639.js"></script>

###Here Now
Get occupancy of who's here now on the channel by UUID:

<script src="https://gist.github.com/justinplatz/c45ae9135df50dc18dc5.js"></script>

###Presence
Subscribe to real-time Presence events, such as join, leave, and timeout, by UUID. Setting the presence attribute to a callback will subscribe to presents events on my_channel:

***Requires that the Presence add-on is enabled for your key. How do I enable add-on features for my keys? - see http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys ***

<script src="https://gist.github.com/justinplatz/d30f8a40379cc98abc22.js"></script>

###History
Retrieve published messages from archival storage:

***Requires that the Storage and Playback add-on is enabled for your key. How do I enable add-on features for my keys? - see http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys***

<script src="https://gist.github.com/justinplatz/953fcf08589aa48b8313.js"></script>

###Unsubscribe
Stop subscribing (listening) to a channel.
<script src="https://gist.github.com/justinplatz/37772e5635c33739ee1d.js"></script>