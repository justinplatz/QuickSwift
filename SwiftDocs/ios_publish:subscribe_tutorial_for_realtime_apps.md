#iOS Publish/Subscribe Tutorial for Realtime Apps

##Publish and Subscribe Overview
PubNub utilizes a Publish/Subscribe model for real-time data streaming and device signaling which lets you establish and maintain persistent socket connections to any device and push data to global audiences in less than ¼ of a second.

The atomic components that make up a data stream are API Keys, Messages, and Channels.

####API Keys
To build an application that leverages the PubNub Network for Data Streams with Publish and Subscribe, you will need PubNub API Keys which we provide when you [Sign-Up](http://admin.pubnub.com/free-trial).

You will need at the minimum a `subscribeKey` and `publishKey`. If a client will only subscribe, and not publish, then the client only need to initialize with the `subscribeKey`. For clients who will be publishing only, or publishing and subscribing (a client can both publish and subscribe), it will need to initialize with both the `subscribeKey` and the `publishKey`.

You only need to supply the `publishKey` to clients that will publish (send) data to your application over the PubNub network. A read-only client for example would not need to initialize with this key.

`Although a secretKey is also provided to you along with your publish and subscribe keys in the admin portal, it is not required for plain-old publish and subscribe. You’ll only need the secretKey if you are using PAM functionality, which we discuss more in the PAM Feature Tutorial.`

####MESSAGES OVERVIEW
A message consists of a channel, and its associated data payload. A publishing client publishes messages to a given channel, and a subscribing client receives only the messages associated with the channels its subscribed to.

PubNub Message payloads can contain any JSON data including Booleans, Strings, Numbers, Arrays, and Objects. Simply publish the native type per your platform, and the clients will JSON serialize the data for you. Subscribers will automatically deserialize the JSON for you into your platform’s associated native type.

####MESSAGE DESIGN CONSIDERATIONS
When creating a message, keep these limits in mind:

* Maximum message size is 32KB
* The message size includes the channel name
* The message size is calculated after all URL encoding and JSON serialization has occurred. Depending on your data, this could add > 4X the original message size.

Keeping your messages < 1.5KB in size will allow them to fit into a single TCP packet!

####CHANNEL DESIGN PATTERNS: UNICAST VS MULTICAST
Channels are created on-the-fly, and do not incur any additional charges to use one or many in your application. When you create a PubNub application, all messages will be associated with a channel.

In a unicast (AKA 1:1) design pattern, the channels can be unique for each client in one-to-one communication. For example, user1 subscribes to user1-private, and user2 subscribes to user2-private. Using this pattern, each client listens on a channel which only relevant data to that client is sent.  It has the advantage of minimal network usage (each client receives only the data it needs) and minimal processing (no need for filtering unneeded data).

![image](http://www.pubnub.com/static/images/old/pubnub-galaxy.gif)

In a multicast (AKA 1:Many) design pattern, a “public” (AKA ‘system’, ‘global’, or ‘admin’) channel is used for global communications amongst all clients. For example, building off our previous example, while a user can speak to any other user on their “private” channel, since each client in the application is listening on their private channel AND the public channel, they can receive on either. When receiving a message on the ‘public’ channel, it may or may not be relevant for that particular receiving client -- to get around this, the client can filter on some sort of ‘key’, allowing them to selectively process messages with specific interest to them.

![image](http://www.pubnub.com/static/images/old/pubnub-pulse-1.gif)

In many cases, based on the use case of your application, the pattern you choose may be unicast, multicast, or a combination. There is no right or wrong pattern to implement, but based on your use case, there may be an optimal, most efficient pattern.

####CHANNEL NAME DESIGN CONSIDERATIONS
Since the text length of the channel name is counted as part of the entire message, and as such, as part of the maximum message length, it is best to keep the channel name as short as efficiency and utility allows.

Channel names are UTF-8 compatible. Prohibited chars in a channel name are:

* comma: `,`
* slash: `/`
* backslash: `\`
* period: `.`
* asterisks: `*`
* colon: `:`

####DATA STREAMS CODE SAMPLES

#####PUBLISHING AND SUBSCRIBING REQUIRES ONLY A FEW SIMPLE-TO-USE APIS:

* Include the PubNub library.
* `PubNub` - instantiate a PubNub instance.
* `subscribeToChannels` - additively subscribe to a specific channel.
* `publish` - send a message on a specific channel.
* `unsubscribeFromChannels()` - additively unsubscribe to a specific channel.

#####INCLUDE THE PUBNUB LIBRARY.
To include PubNub iOS SDK in your project you need to use CocoaPods 
Install cocoapods gem by following the procedure defined under [How to Get It](http://www.pubnub.com/docs/cocoa-objective-c/pubnub-objective-c-sdk-v4#how_to_get_it).

To add the PubNub iOS SDK to your project with CocoaPods, there are three basic tasks to complete which are covered below:

1. Create new Xcode project.
2. Create Podfile in new Xcode project root folder
	
		$ touch Podfile 
3. Edit Podfile by adding following content:
		
		platform :ios, '8.0'
		target 'YourProject' do
		source 'https://github.com/CocoaPods/Specs.git'
		pod 'PubNub', '~>4.0'
		end
		target 'YourProjectTests' do
		end
4. Add PubNub SDK using next command:

	$ pod install
	
The next thing we need to do to connect our Swift app to our pods is create an Objective-C bridging header. To do this you need to create a new File (File -> New -> File) of type Objective-C File. Call this whatever you like because we will end up deleting this file. Here I have just called it testHeader.

When you see “Would you like to configure an Objective-C bridging header?” select Yes. This is the file we really care about, so you can delete the .m file you just created.

Now it will add some new files to your project. Click on the File: YourProject-Bridging-Header.h. Underneath the commented code we need to add an #import to our project to use the PubNub iOS SDK. To do this we simply add the following lines into this file:

	#import <PubNub/PubNub.h>
	
Complete application delegate configuration

	class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {    

    	var client : PubNub
    	
    	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    	    	...
    	 }
    	
    	...
    	
    }

#####INITIALIZE THE API
If this PubNub instance will only be subscribing, you only need to pass the subscribe_key to initialize the instance. If this instance will be subscribing and publishing, you must also include the publish_key parameter.

		
    var client : PubNub
    var config : PNConfiguration
    
    override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        super.init()
        client.addListener(self)
    }
    
    
#####PUBLISHING AND SUBSCRIBING TO A CHANNEL

The channel the messages will be published over is called `my_channel`. And for this example, we want the same instance to both publish and subscribe. To do this, we’ll publish a message to the channel, but only after we’re sure we’ve first successfully subscribed to the channel.

The `publish` and `subscribeToChannels` methods are pretty simple to use. For both `publish` and `subscribeToChannels`, the channel attribute defines the channel in use.

For `subscribeToChannels` the message callback is where received messages are called-back to:

    var client : PubNub
    var config : PNConfiguration
    
    override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        client.subscribeToChannels(["Your_Channel1","Your_Channel2"], withPresence: false)
        
        super.init()
        client.addListener(self)
    }
    
    
     func client(client: PubNub!, didReceiveMessage message: PNMessageResult!, withStatus status: PNErrorStatus!) {
        // Handle new message stored in message.data.message
        if let messageData = message.data.actualChannel{
            // Message has been received on channel group stored in
            // message.data.subscribedChannel
        }
        else {
            // Message has been received on channel stored in
            // message.data.subscribedChannel
        }
        println("Received message: \(message.data.message) on channel \(message.data.subscribedChannel) at \(message.data.timetoken)")
    }
    
    
    func client(client: PubNub!, didReceiveStatus status: PNSubscribeStatus!) {
        
        	if(status.category == PNStatusCategory.PNUnexpectedDisconnectCategory){
            	// This event happens when radio / connectivity is lost
        	}
        	else if(status.category == PNStatusCategory.PNConnectedCategory){
            	// Connect event. You can do stuff like publish, and know you'll get it.
            	// Or just use the connected event to confirm you are subscribed for
            	// UI / internal notifications, etc
            
            	client.publish("Hello from the PubNub Swift SDK", toChannel: "my_channel", withCompletion: { (status) -> Void in
                	// Check whether request successfully completed or not.
                	if(!status.error){
                   		// Message successfully published to specified channel.
                	}
                	// Request processing failed.
                	else {
                    
                    	// Handle message publish error. Check 'category' property to find out possible issue
                    	// because of which request did fail.
                    	//
                    	// Request can be resent using: status.retry()
                	}
            	})
        	}
        	else if (status.category == PNStatusCategory.PNReconnectedCategory) {
            	// Happens as part of our regular operation. This event happens when
            	// radio / connectivity is lost, then regained.
        	}
        	else if (status.category == PNStatusCategory.PNDecryptionErrorCategory) {
            	// Handle messsage decryption error. Probably client configured to
            	// encrypt messages and on live data feed it received plain text.
        	}
    	}
    }
    
During your application’s lifecycle, you can call `subscribeToChannels()` repeatedly to additively subscribe to additional channels.

For `publish`, the message attribute contains the data you are sending.

	        
 	client.publish("Hello from PubNub + Swift!", toChannel: "my_channel", storeInHistory: true) { (status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                // Message successfully published to specified channel.
            }
            // Request processing failed.
            else {
                // Handle message publish error. Check 'category' property to find out possible issue
                // because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
        
        
The above code demonstrates how to subscribe, and how to publish. But what if your use-case requires that client instance not only subscribes and publishes, but also that its guaranteed to start publishing only AFTER it’s successfully subscribed? -- In other words, you want to guarantee it receives all of its own publishes?

The Swift client SDK, like many of the PubNub SDKs, is asynchronous -- publish() can, and most likely will, fire before the previously executed subscribe() call completes. The result is, for a single-client instance, you would never receive (via subscribing) the message you just published, because the subscribe operation did not complete before the message was published.

To get around this common case, we can take advantage of the optional ‘connect’ callback in the subscribe method.

#####PUBLISH AFTER SUBSCRIBE CONNECT

	var client : PubNub
    var config : PNConfiguration
    
    override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        client.subscribeToChannels(["Your_Channel1","Your_Channel2"], withPresence: false)
        
        super.init()
        client.addListener(self)
    }
	func client(client: PubNub!, didReceiveStatus status: PNSubscribeStatus!) {
        	if(status.category == PNStatusCategory.PNUnexpectedDisconnectCategory){
            	// This event happens when radio / connectivity is lost
        	}
        	else if(status.category == PNStatusCategory.PNConnectedCategory){
            	// Connect event. You can do stuff like publish, and know you'll get it.
            	// Or just use the connected event to confirm you are subscribed for
            	// UI / internal notifications, etc
            
            	client.publish("Hello from the PubNub Swift SDK", toChannel: "Your_Channel1", withCompletion: { (status) -> Void in
                	// Check whether request successfully completed or not.
                	if(!status.error){
                   		// Message successfully published to specified channel.
                	}
                	// Request processing failed.
                	else {
                    
                    	// Handle message publish error. Check 'category' property to find out possible issue
                    	// because of which request did fail.
                    	//
                    	// Request can be resent using: status.retry()
                	}
            	})
        	}
        	else if (status.category == PNStatusCategory.PNReconnectedCategory) {
            	// Happens as part of our regular operation. This event happens when
            	// radio / connectivity is lost, then regained.
        	}
        	else if (status.category == PNStatusCategory.PNDecryptionErrorCategory) {
            	// Handle messsage decryption error. Probably client configured to
            	// encrypt messages and on live data feed it received plain text.
        	}
    	}

By following this pattern on a client that both subscribes and publishes when you want to be sure to subscribe to your own publishes, you’ll never miss receiving a message.

#####UNSUBSCRIBING FROM A CHANNEL

While you are subscribed to a channel, you will continue to receive messages published to that channel. To stop receiving messages on a given channel, you must `unsubscribeFromChannels()` from the channel.

	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        super.init()
        client.addListener(self)
    }
    
    client.unsubscribeFromChannels(["my_channel1","my_channel2"], withPresence: false)

	func client(client: PubNub!, didReceiveStatus status: PNSubscribeStatus!) {
        	if(status.category == PNStatusCategory.PNUnexpectedDisconnectCategory){
            	// This event happens when radio / connectivity is lost
        	}
        	else if(status.category == PNStatusCategory.PNConnectedCategory){
            		// Connect event. You can do stuff like publish, and know you'll get it.
            		// Or just use the connected event to confirm you are subscribed for
            		// UI / internal notifications, etc
        	}
        	else if (status.category == PNStatusCategory.PNReconnectedCategory) {
            	// Happens as part of our regular operation. This event happens when
            	// radio / connectivity is lost, then regained.
        	}
        	else if (status.category == PNStatusCategory.PNDecryptionErrorCategory) {
            	// Handle messsage decryption error. Probably client configured to
            	// encrypt messages and on live data feed it received plain text.
        	}
    	}
    	
Like `subscribeToChannels()`, `unsubscribeFromChannels()` can be called multiple times to successively remove different channels from the active subscription list.
    
    