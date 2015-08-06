#iOS Data Stream Controller Tutorial for Realtime Apps

##Stream Controller Overview

`Requires that the Stream Controller add-on is enabled for your key. How do I enable add-on features for my keys? - see http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys`

When enabled via the PubNub admin console (http://admin.pubnub.com), the Stream Controller feature provides PubNub developers the ability to efficiently subscribe to multiple channels via Channel Multiplexing (MXing) and Channel Groups.

#####NAME CONSIDERATIONS FOR CHANNELS AND CHANNEL GROUPS
Channel and Channel Group names are UTF-8 compatible. Name length is limited to 64, and prohibited chars in a channel group are:

* comma: `,`
* slash: `/`
* backslash: `\`
* period: `.`
* asterisks: `*`
* colon: `:`

#####CHANNEL MULTIPLEXING
Channel Multiplexing enables developers to subscribe to up to 50 channels (not within a channel group) over a single TCP socket. On mobile devices, its easy to realize the network bandwidth and battery power savings gained from channel multiplexing.

#####CHANNEL MULTIPLEXING CODE SAMPLES
NOTE: These code samples build off code defined in the Pub & Sub tutorial, so before proceeding, be sure you have completed the Pub & Sub tutorial first. Alternatively, you may download the Pub & Sub tutorial here.

The examples below demonstrate how to subscribe and unsubscribe from multiple channels with a single call. The use of callbacks will give you a way to know when your operations complete successfully or with errors.

#####SUBSCRIBING USING A LIST OF CHANNELS


	  
	   	var client : PubNub
    	var config : PNConfiguration

	   override init() {
        	config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        	client = PubNub.clientWithConfiguration(config)
        	
        	super.init()
        	  
        	//Subscription process results arrive to listener which should adopt to PNObjectEventListener protcol and registered using:     	
        	client.addListener(self)
        	
        	//Listeners callbacks:       
        	client.subscribeToChannels(["My_Channel1", "My_Channel2"], withPresence: false) 
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
    	
#####PASS A CSV LIST OF CHANNELS TO UNSUBSCRIBE

	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        super.init()
        client.addListener(self)
    }
    
    client.unsubscribeFromChannels(["My_Channel1","My_Channel2"], withPresence: false)

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
    	
#####CHANNEL GROUPS
Channel Groups allows PubNub developers to bundle thousands of channels into a "group" that can be identified by name. These Channel Groups can then be subscribed to, receiving data from the many backend-channels the channel group contains.

#####CHANNEL GROUP DESIGN CONSIDERATIONS

When building with channel-groups, you may create an unlimited number of these uniquely named channel groups, each with up to 2000 channels in them. Up to 10 channel groups may be subscribed to per PubNub instance. The below diagram depicts this design pattern and default limits:

![image](http://www.pubnub.com/sites/all/themes/pubnub/images/cg1.png)

As an example, for a group chat application, the channel group name would describe the conversation, and the channel names would be the chat audiences’ channels.

For a user `justin`: `family`, `friends` and `work` are the chat room names (channel groups) and the channels are the contact’s (channels), your design may look something like this:

* justin : family : wife
* justin : family : daughter
* justin : family : son
* justin : friends : joe
* justin : friends : todd
* justin : friends : stephen
* justin : work : tim
* justin : work : tom

Given the above design pattern `family`, `friends` and `work` are the 3 channel groups, which each contain a handful of channels in different combinations such as wife, son, tim, joe, stephen, etc. Similarly for user `alex`: `mychats` is the chat room name (channel group) and the channels `general-a-messages`, `general-a-keyboard-presence`, `general-j-messages`, `general-j-keyboard-presence`, `general-m-messages` and `general-m-keyboard-presence`, your design may look something like this:

* alex : mychats : general-a-messages
* alex : mychats : general-a-keyboard-presence
* alex : mychats : general-j-messages
* alex : mychats : general-j-keyboard-presence
* alex : mychats : general-m-messages
* alex : mychats : general-m-keyboard-presence

Please contact support@pubnub.com if you feel this design pattern and/or default limits will not accommodate your application's design.

`Each Channel Group and associated channel(s) is identified by a unique name. These names may be a string of up to 64 Unicode characters, excluding reserved characters: , , : , . , / , *, non-printable ASCII control characters and Unicode zero.`

#####CHANNEL GROUP CODE SAMPLES

Before you use a channel group, you must first add a channel to it. Channels can be added from either a client-side (mobile phone, web page), or a server-side (Java, Ruby, Python) device.

For our example, lets create a chat application around channel groups. Each channel group will contain the members' topic channels for the group.

#####FIRST, WE'LL DEFINE OUR CHANNEL GROUP MESSAGE AND ERROR CALLBACK:

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
        	}
        	else if (status.category == PNStatusCategory.PNReconnectedCategory) {
            	// Happens as part of our regular operation. This event happens when
            	// radio / connectivity is lost, then regained.
        	}
        	else if (status.category == PNStatusCategory.PNDecryptionErrorCategory) {
            	// Handle message decryption error. Probably client configured to
            	// encrypt messages and on live data feed it received plain text.
        	}
    	}
    	
#####NEXT, WE'LL IMPLICITLY DEFINE A CHANNEL GROUP CALLED "FAMILY".
Before we do that, first we'll define some default callbacks and names:
	
	var channelGroup = "family"

#####ADDING A CHANNEL TO A CHANNEL GROUP

	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        super.init()
        client.addListener(self)
    }
	
	var channelGroup = "family"
	
	client?.addChannels(["wife"], toGroup: channelGroup, withCompletion:
        { (status) -> Void in
             // Check whether request successfully completed or not.
            if let Status = status{
                // Handle successful channels list modification for group.
            }
            // Request processing failed.
            else{
				// Handle channels list modificatoin for group error. Check 'category' property
       			// to find out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry();
            }
    })


#####FOLLOWING THE SAME EXAMPLE, WE CAN ADD SON AND DAUGHTER CHANNELS TO THIS CHANNEL GROUP:

	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        super.init()
        client.addListener(self)
    }
    
    client?.addChannels(["son","daughter"], toGroup: channelGroup, withCompletion:
        { (status) -> Void in
             // Check whether request successfully completed or not.
            if let Status = status{
                // Handle successful channels list modification for group.
            }
            // Request processing failed.
            else{
                // Handle channels list modification for group error. Check 'category' property
                // to find out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry();
            }
    })
    
#####SUBSCRIBING TO THE CHANNEL GROUP
Now that we've added some channels to the Channel Group (implicitly defining it), we need to subscribe to it. When a message arrives published to any of the channel group members, the message will arrive via the m variable in message callback. The c variable will contain the source channel name.

	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        client.subscribeToChannelGroups(channelGroup, withPresence: false)
        
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
        	}
        	else if (status.category == PNStatusCategory.PNReconnectedCategory) {
            	// Happens as part of our regular operation. This event happens when
            	// radio / connectivity is lost, then regained.
        	}
        	else if (status.category == PNStatusCategory.PNDecryptionErrorCategory) {
            	// Handle message decryption error. Probably client configured to
            	// encrypt messages and on live data feed it received plain text.
        	}
    }

#####TO ENABLE RECEIVING PRESENCE MESSAGES FOR THE CHANNEL_GROUP, JUST SET THE "PRESENCE" ATTRIBUTE TO THE CALLBACK YOU WISH TO SEND PRESENCES MESSAGES TO AT SUBSCRIBE-TIME:


	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        client.subscribeToChannelGroups(channelGroup, withPresence: true)
        
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
        	}
        	else if (status.category == PNStatusCategory.PNReconnectedCategory) {
            	// Happens as part of our regular operation. This event happens when
            	// radio / connectivity is lost, then regained.
        	}
        	else if (status.category == PNStatusCategory.PNDecryptionErrorCategory) {
            	// Handle message decryption error. Probably client configured to
            	// encrypt messages and on live data feed it received plain text.
        	}
    }
    
We'll learn more about using PubNub `Presence` features in the [Presence](http://www.pubnub.com/docs/ios-objective-c/presence-sdk-v4) tutorial.

#####REMOVING A CHANNEL FROM A CHANNEL GROUP

Lets assume that our son no longer wants to be part of the family chat app, because he is getting irritated with his sister's comments. To remove his channel from the group, we'd just call the following method:

        client.removeChannels("son", fromGroup: channelGroup) { (status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle successful channel group removal.
            }
                // Request processing failed.
            else {
                
                // Handle channel group removal error. Check 'category' property to find out possible issue
       			// because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
        }

If he had permissions to remove his sister from the group, he probably would just do that instead, but if PAM was implemented, we could make it so that he only has permissions to either add or remove himself to the group, not add or remove others. We'll discuss PAM in more detail in the "PAM, SSL, and AES256 Message Encryption" tutorial.

#####LISTING DEFINED CHANNEL GROUPS

	 client.channelGroupsWithCompletion { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                 // Handle downloaded list of groups using: result.data.groups
            }
                // Request processing failed.
            else {
                
                // Handle channel group removal error. Check 'category' property to find out possible issue
       			// because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
     }
     
#####LISTING CHANNELS DEFINED WITHIN A CHANNEL GROUP

To get a list of all the channels defined within a channel group, call the following method. In this example, we dump all the channels within "justin:family":

	 client.channelsForGroup(myChannel, withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                 // Handle downloaded list of channels using: result.data.channels
            }
                // Request processing failed.
            else {
                
                // Handle channel group removal error. Check 'category' property to find out possible issue
       			// because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
    })
    
#####REMOVING CHANNEL GROUPS BY NAME

To remove a Channel Group by name, use the following method:

	 client.removeChannelsFromGroup(myChannel, withCompletion: { (status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle successful channel group removal.
            }
                // Request processing failed.
            else {
                
                // Handle channel group removal error. Check 'category' property to find out possible issue
       			// because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
     })
     
     