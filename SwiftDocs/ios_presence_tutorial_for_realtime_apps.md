#iOS Presence Tutorial for Realtime Apps

##Presence Overview
`Requires that the Presence add-on is enabled for your key. How do I enable add-on features for my keys? - see http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys`

PubNub's Channel Presence empowers your applications to Track online and offline status of users and devices in realtime. Before using this feature it must be enabled in the PubNub Admin Console.

Presence provides authoritative information on:

* when a user has joined or left a channel
* who, and how many, users are subscribed to a particular channel
* which channel(s) an individual user is subscribed to
* associated state information for these users (lat/long, typing status, etc)

#####DEFAULT PRESENCE EVENTS

By default, a user may trigger the following presence events against the channels he is subscribed to:

* `join` - A user subscribes to channel
* `leave` - A user unsubscribes from channel
* `timeout` - A user unexpectedly loses connection from a channel (device poweroff, network interruption, etc)

#####UUID

Presence events are always tied to a specific device, and that specific device is identified via the PubNub UUID. More info on setting UUIDs is available in the API Reference.

In addition to the default presence events of `join`, `leave` and `timeout`, the developer may add `custom state` attributes, which when modified, emit `state-change` events.

For example, assuming we have a device set to `UUID` = `Stephen`, when a user begins typing, you could locally set an `isTyping` attribute to `TRUE`. This would result in a presence event of `isTyping:TRUE` for user `Stephen`. Upon pausing, you could set the same attribute to `FALSE`, resulting in a presence event of `isTyping:FALSE` for user `Stephen`.

In addition to receiving default and custom presence events in realtime, PubNub provides the following APIs to pull specific presence details on-demand:

* Here Now - who, and how many, users are subscribed to a particular channel
* Where Now - which channel(s) an individual user is subscribed to

#####PUBNUB PRESENCE SWIFT CODE SAMPLES

#####SETTING A UUID
To add context to which device (connected to which user) is doing what, we'll need to assign a `UUID` to it. To do this, be sure you initialize your client with a `UUID`:

	
 	var client : PubNub
    var config : PNConfiguration
    
	override init() {
		config.uuid = "Stephen"
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        super.init()
        client.addListener(self)
    }
    
#####RECEIVING PRESENCE JOIN, LEAVE, AND TIMEOUT EVENTS IN REALTIME
Now that we've set our `UUID`, we can enable realtime presence events along with our subscribe call:

	var client : PubNub
    var config : PNConfiguration
    
	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        super.init()
        client.addListener(self)
        
        client.subscribeToPresenceChannels(["my_channel"])
    }
    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout,
        // state-change).
        if let Data = event.data.actualChannel{
            
            // Presence event has been received on channel group stored in
            // event.data.subscribedChannel
        }
        else{
            
            // Presence event has been received on channel stored in
            // event.data.subscribedChannel
        }
        println("Did receive presence event: \(event.data.presenceEvent)")
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
    
In the above example, we subscribe to the channel `my_channel`, receiving messages received on `my_channel` to the "message" callback, and we subscribe to the presence channel for my_channel (under the covers, its a regular channel, called `my_channel-pnpres`, sending presence messages to the "presence" callback.

The resulting data received on presence channels will follow this format:

* `action` - A string, which is either join, leave, timeout, or state-change
* `timestamp` - A number, which is the timestamp of when the event occurred
* `uuid` - a string, which correlates with the UUID set on the device
* `occupancy` - a number, which represents the current occupancy of the channel
* `data` - a JSON Object, which contains any custom state information
* `channel` - a string, which depicts the name of the channel the event occurred on

#####SAMPLE RESPONSES

#####JOIN EVENT

	{
    	"action": "join",
    	"timestamp": 1345546797,
    	"uuid": "175c2c67-b2a9-470d-8f4b-1db94f90e39e",
    	"occupancy": 2
	}
	
#####LEAVE EVENT
	
	{
    	"action": "leave",
    	"timestamp": 1345546797,
    	"uuid": "175c2c67-b2a9-470d-8f4b-1db94f90e39e",
    	"occupancy": 1
	}

#####TIMEOUT EVENT

	{
    	"action": "timeout",
    	"timestamp": 1345546797,
    	"uuid": "76c2c571-9a2b-d074-b4f8-e93e09f49bd",
    	"occupancy": 0
	}
	
#####CUSTOM PRESENCE EVENT (STATE CHANGE)

	{
    	"action": "state-change",
    	"uuid": "76c2c571-9a2b-d074-b4f8-e93e09f49bd",
    	"timestamp": 1345549797,
    	"data": {
        	"isTyping": true
    	}
	}	

#####ON-DEMAND PRESENCE CALLS
Whereas the `Join`,`Leave`,`Timeout`,`State-Change` events occur in realtime when subscribed to the presence channel, PubNub provides the ability to audit on-demand for presence-specifics with the `Here Now`, and `Where Now` commands.

#####HERE NOW
To get a list of "who is here now" for a given channel, use the `hereNowForChannel` method:

	  client?.hereNowForChannel("my_channel", withVerbosity: PNHereNowVerbosityLevel.UUID, completion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if(!status.error){
                //   result.data.uuids - dictionary with active subscriber. Each entry will have next
                //                       fields: "uuid" - identifier and "state" if it has been provided.
                //   result.data.occupancy - total number of active subscribers.
            }
            // Request processing failed.
            else{
                // Handle presence audit error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
      })
      
The resulting data received from `hereNowForChannel` will follow this format:

* `uuids` - Array of Strings - List of UUIDs currently subscribed to the channel.
* `occupancy` - Number - Total current occupancy of the channel.

#####EXAMPLE RESPONSE

	{
    	occupancy: 4,
    	uuids: [‘123123234t234f34fq3dq’, ‘143r34f34t34fq34q34q3’, ‘23f34d3f4rq34r34rq23q’, ‘w34tcw45t45tcw435tww3’, ]
	}
	
#####GLOBAL HERE NOW

To get a list of everyone on every channel, just omit the channel parameter:

	var client : PubNub
    var config : PNConfiguration
    
	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        super.init()
        client.addListener(self)
        
        client.subscribeToPresenceChannels(["my_channel"])
    }
    
    client.hereNowWithCompletion { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded presence information using:
                //   result.data.channels - dictionary with active channels and presence information on
                //                          each. Each channel will have next fields: "uuids" - list of
                //                          subscribers; occupancy - number of active subscribers.
                //                          Each uuids entry has next fields: "uuid" - identifier and
                //                          "state" if it has been provided.
                //   result.data.totalChannels - total number of active channels.
                //   result.data.totalOccupancy - total number of active subscribers.
            }
                // Request processing failed.
            else {
                
                // Handle presence audit error. Check 'category' property to find out possible issue because
                // of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
     }
     
The response groups the data by channel:

	{
    	"status": 200,
    	"message": "OK",
    	"payload": {
        	"channels": {
            	"81d8d989-b95f-443c-a726-04fac323b331": {
                	"uuids": [
                    	"70fc1140-22b5-4abc-85b2-ff8c17b24d59"],
                	"occupancy": 1
            	},
            	"81b7a746-d153-49e2-ab70-3037a75cec7e": {
                	"uuids": [
                    	"91363e7f-584b-49cc-822c-52c2c01e5928"],
                	"occupancy": 1
            	},
            	"c068d15e-772a-4bcd-aa27-f920b7a4eaa8": {
                	"uuids": [
                   		"ccfac1dd-b3a5-4afd-9fd9-db11aeb65395"],
                	"occupancy": 1
            	}
        	},
        	"total_channels": 3,
        	"total_occupancy": 3
    	},
    	"service": "Presence"
	}
	
#####WHERE NOW
To get a list of "which channel(s) is UUID on right now", use the whereNowUUID method:

	client.whereNowUUID(self.client.uuid(), withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded presence 'where now' information using: result.data.channels
            }
                // Request processing failed.
            else {
                
                // Handle presence audit error. Check 'category' property to find out possible issue because
                // of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
     })
     
The resulting data received from `whereNowUUID` will follow this format:

* channels - Array of Strings - List of channels a uuid is subscribed to.

#####EXAMPLE RESPONSE

	{
    	"channels": [
        	"lobby",
        	"game01",
        	"chat"]
	}

#####SETTING CUSTOM PRESENCE STATE

The `state` API is used to get or set custom presence key/value pairs for a specific `UUID`.

To retrieve `state` for jbonham on channel `my_channel`, we'd call:

	var client : PubNub
    var config : PNConfiguration
    
	override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        super.init()
        client.addListener(self)
    }
    client.stateForUUID(self.client.uuid(), onChannel: "chat") { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded state information using: result.data.state
            }
                // Request processing failed.
            else {
                
                // Handle client state audit error. Check 'category' property to find out possible
                // issue because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
    }
    
To set `state` (setter) for jbonham on channel `my_channel`, we'd use the same call, but with a 'state' attribute:

	client.setState(["key":"value"], forUUID: self.client.uuid(), onChannel: "my_channel") { (status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Client state successfully modified on specified channel.
            }
                // Request processing failed.
            else {
                
                // Handle client state modification error. Check 'category' property to find out possible
                // issue because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
     }
     
After setting `state`, if you were subscribed to presence for the channel `my_channel`, you would receive a `state-change` event in realtime similar to:

	{
    	"action": "state-change",
    	"uuid": "jbonham",
    	"timestamp": 1345549797,
    	"data": {
        	"full_name": "James Patrick Page"
    	}
	}
	
Now that `state` is set, you could also pull it (again) via the `stateForUUID` getter method.

In addition to setting state via the `setState` setter method, you can subscribe to a channel and set state in a single call with `subscribeToChannels`:
