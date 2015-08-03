#iOS Swift API Reference for Realtime Apps
Swift complete API reference for building Realtime Applications on PubNub, including basic usage and sample code

NATIVE DOCS LINKS

[View on CocoaDocs](http://cocoadocs.org/docsets/PubNub/4.0.1/)

##Add Channels to Channel Group
####Description
This function adds a channel to a channel group
#####Method(s)
To `Add Channels to Channel Group` you can use the following method(s) in the Swift SDK

	Void addChannels(channels: [AnyObject]!, toGroup: String!, withCompletion: PNChannelGroupChangeCompletionBlock!(PNAcknowledgmentStatus!) -> Void)
	
Parameter | Type | Required | Description
--- | --- | --- | ---
`channels`| [AnyObject]! | Yes | Name of the `group` into which `channels` should be added.
`group`| String! | Yes | Name of the `group` into which `channels` should be added.
`block`| PNChannelGroupChangeCompletionBlock! | Yes | `Channels` addition process completion block which pass only one argument - request processing status to report about how data pushing was successful or not.

####Basic Usage
Add Channel to a channel group 

		var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        var channelGroup = "family"
        client?.addChannels(["wife"], toGroup: channelGroup, withCompletion:
        { (status) -> Void in
             // Check whether request successfully completed or not.
            if(!status.error){
                // Handle successful channels list modification for group.
            }
            // Request processing failed.
            else{
                // Handle channels list modificatoin for group error. Check 'category' property
                // to find out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        })
        
####Returns
None.

##Add Push Notifications On Channels
####Description
Enable push notifications on provided set of channels.

####Method(s)
To run `Add push notifications on channels` you can use the rolling method(s) in the Swift SDK

     Void addPushNotificationsOnChannels(channels: [AnyObject]!, withDevicePushToken: NSData!, andCompletion: PNPushNotificationsStateModificationCompletionBlock!(PNAcknowledgmentStatus!) -> Void)
     
Parameter | Type | Required | Description
--- | --- | --- | ---
`channels`| [AnyObject]! | Yes | List of `channel` names for which push notifications should be `enabled`.
`pushToken`| NSData! | Yes | Device push token which should be used to enabled push notifications on specified set of `channels`.
`block`| PNPushNotificationsStateModificationCompletionBlock! | Yes | Push notifications addition on `channels` processing completion `block` which pass only one argument - request processing status to report about how data pushing was successful or not.

####Basic Usage
Add Push Notifications On Channels:

        var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client?.addPushNotificationsOnChannels(["wwdc", "google.io"], withDevicePushToken: self.devicePushToken, andCompletion: { (status) -> Void in
        	// Check whether request successfully completed or not.
            if(!status.error){
            	// Handle successful push notification enabling on passed channels.
            }
            // Request processing failed.
            else{
                // Handle modification error. Check 'category' property to find out possible issue because
        		// of which request did fail.
        		//
        		// Request can be resent using: [status retry];
            }
        })
        
####Returns
None.

##Get Authentication Key
####Description
This function provides the capability to get a user’s `authKey`.
####Method(s)

	Not sure what goes here

####Basic Usage
	
	***This does not compile***
	var configuration:PNConfiguration = client?.currentConfiguration
    var authKey:NSString = configuration.authKey

####Returns
The current authentication key.

##Get State
####Description
The state API is used to get key/value pairs specific to a subscriber `uuid`.

State information is supplied as a JSON object of key/value pairs.

####Method(s)
To `Get State` you can use the following method(s) in the Swift SDK

`Void stateForUUID(uuid: String!, onChannel: String!, withCompletion: PNChannelStateCompletionBlock!(PNChannelClientStateResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`uuid`| String! | Yes | Reference on unique user identifier for which state should be retrieved.
`channel`| String! | Yes | Name of channel from which state information for `uuid` will be pulled out.
`block`| PNChannelStateCompletionBlock! | Yes | State audition for user on `channel` processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of client state retrieve operation; status - in case if `error` occurred during request processing.

`Void stateForUUID(uuid: String!, onChannelGroup: String!, withCompletion: PNChannelGroupStateCompletionBlock!(PNChannelGroupClientStateResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`uuid`| String! | Yes | Reference on unique user identifier for which state should be retrieved.
`group`| String! | Yes | Name of `channel group` from which state information for `uuid` will be pulled out.
`block`| PNChannelStateCompletionBlock | Yes | State audition for user on `channel` processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of client state retrieve operation; status - in case if `error` occurred during request processing.

####Basic Usage
Returning state information

		var client: PubNub
		let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client?.stateForUUID(config.uuid, onChannel: "chat", withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if(!status.error){
                // Handle downloaded state information using: result.data.state
            }
            // Request processing failed.
            else{
                // Handle client state audit error. Check 'category' property to find out possible
                // issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        })
        
####Returns
The state API returns a JSON Object containing key value pairs.

	{
  		first   : "Robert",
  		last    : "Plant",
  		age     : 59,
  		region  : "UK"
	}
	
##Global Here Now
####Description
Return `Occupancy` for all channels by calling the `hereNowWithCompletion` function in your application.

####Method(s)
To do `Global Here Now` you can use the following method(s) in the Swift SDK

`Void hereNowWithCompletion(block: PNGlobalHereNowCompletionBlock!(PNPresenceGlobalHereNowResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`block`| PNGlobalHereNowCompletionBlock | Yes | Here now processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of here now operation; status - in case if `error` occurred during request processing.

`Void	hereNowWithVerbosity(level: PNHereNowVerbosityLevel, completion: PNGlobalHereNowCompletionBlock!(PNPresenceGlobalHereNowResult!, PNErrorStatus!) -> Void)
`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`level`| PNHereNowVerbosityLevel | Yes | Reference on one of PNHereNowVerbosityLevel fields to instruct what exactly data it expected in response.
`block`| PNGlobalHereNowCompletionBlock | Yes | Here now processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of here now operation; status - in case if `error` occurred during request processing.

####Basic Usage

	 	var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client.hereNowWithCompletion { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if(!status.error){
                // Handle downloaded presence information using:
                // result.data.channels - dictionary with active channels and presence information on
                // each. Each channel will have next fields: "uuids" - list of
                // subscribers; occupancy - number of active subscribers.
                // Each uuids entry has next fields: "uuid" - identifier and
                // "state" if it has been provided.
                // result.data.totalChannels - total number of active channels.
                // result.data.totalOccupancy - total number of active subscribers.
            }
            // Request processing failed.
            else{
                // Handle presence audit error. Check 'category' property to find out possible issue because
                // of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
        
####Returns

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
	
##Here Now
####Description
You can obtain information about the current state of a channel including a list of unique user-ids currently subscribed to the channel and the total occupancy count of the channel by calling the `hereNowForChannel` function in your application.

####Method(s)
To do Here Now you can use the following method(s) in the Swift SDK

`hereNowForChannel(channel: String!, withCompletion: PNHereNowCompletionBlock!(PNPresenceChannelHereNowResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Reference on `channel` for which here now information should be received.
`block`| PNHereNowCompletionBlock | Yes | Here now processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of here now operation; status - in case if error occurred during request processing.

`hereNowForChannel(channel: String!, withVerbosity: PNHereNowVerbosityLevel, withCompletion: PNHereNowCompletionBlock!(PNPresenceChannelHereNowResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Reference on `channel` for which here now information should be received.
`level`| PNHereNowVerbosityLevel | Yes | Reference on one of PNHereNowVerbosityLevel fields to instruct what exactly data it expected in response.
`block`| PNHereNowCompletionBlock | Yes | Here now processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of here now operation; status - in case if error occurred during request processing.

####Basic Usage
Get a list of UUIDs subscribed to a channel:

	        client!.hereNowForChannel("my_channel", withVerbosity: PNHereNowVerbosityLevel.UUID) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if(!status.error){
                // Handle downloaded presence information using:
                //   result.data.uuids - list of uuids.
                //   result.data.occupancy - total number of active subscribers.
            }
            // Request processing failed.
            else{
                // Handle presence audit error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
        
####Returns
The `hereNowForChannel` function returns a list of UUIDs currently subscribed to the channel.

* `uuids:["String","String", … ,"String"]` - List of UUIDs currently subscribed to the channel.
* `occupancy: Number` - Total current occupancy of the channel.

		{
    		occupancy: 4,
    		uuids: [‘123123234t234f34fq3dq’, ‘143r34f34t34fq34q34q3’, ‘23f34d3f4rq34r34rq23q’, ‘w34tcw45t45tcw435tww3’, ]
		}


####Other Examples

* Returning State

	    	client?.hereNowForChannel("my_channel", withVerbosity: PNHereNowVerbosityLevel.State, withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if(!status.error){
                //   result.data.uuids - dictionary with active subscriber. Each entry will have next
                //   fields: "uuid" - identifier and "state" if it has been provided.
                //   result.data.occupancy - total number of active subscribers.
            }
            // Request processing failed.
            else{
                // Handle presence audit error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        })
        
Example Response:

	{
    	"status": 200,
    	"message": "OK",
    	"service": "Presence",
    	"uuids": [{
        	"uuid": "myUUID0"
    	}, {
        	"state": {
            	"abcd": {
                	"age": 15
            	}
        	},
        	"uuid": "myUUID1"
    	}, {
        	"uuid": "b9eb408c-bcec-4d34-b4c4-fabec057ad0d"
    	}, {
        	"state": {
            	"abcd": {
                	"age": 15
            	}
        	},
        	"uuid": "myUUID2"
    	}, {
        	"state": {
            	"abcd": {
                	"age": 24
            	}
        	},
        	"uuid": "myUUID9"
    	}],
    	"occupancy": 5
	}
	
* Return `Occupancy` Only

	    	client?.hereNowForChannel("my_channel", withVerbosity: PNHereNowVerbosityLevel.Occupancy, withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if(!status.error){
                //   result.data.occupancy - total number of active subscribers.                
            }
            // Request processing failed.
            else{
                // Handle presence audit error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        })
        
Example Response:

	{
    	"occupancy": 5
	}
	
* Returning `UUIDs` and `occupancy` for all `channels`.

You can return the list of `UUIDs` and `occupancy` for all `channels` by omitting the channel:

	   client?.hereNowForChannel(withVerbosity: PNHereNowVerbosityLevel.UUID, withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
    		if (!status.error) {
    		 
       			// Handle downloaded presence information using:
       			// result.data.channels - dictionary with active channels and presence information on 
       			// each. Each channel will have next fields: "uuids" - list of
       			// subscribers; "occupancy" - number of active subscribers.
       			// result.data.totalChannels - total number of active channels.
       			// result.data.totalOccupancy - total number of active subscribers.
    		}
    		// Request processing failed.
    		else {
       			// Handle presence audit error. Check 'category' property to find out possible issue because
       			// of which request did fail.
       			//
       			// Request can be resent using: [status retry];
    		}
      })
        
Example Response:

	{
    	"total_channels" : 2,
    	"total_occupancy" : 3,
    	"channels" : {
        	"lobby" : {
            	"occupancy" : 1,
            	"uuids" : [
                	"dara01"
            	]
        	},
        	"game01" : {
            	"occupancy" : 2,
            	"uuids" : [
                	"jason01",
                	"jason02"
            	]
        	}
    	}
	}



* Return `Occupancy` for all channels
You can return only the occupancy information by omitting channel and setting uuids to false

	   client?.hereNowForChannel(withCompletion: { (result, status) -> Void in
            // Check whether request successfully completed or not.
    		if (!status.error) {
    		 
       			// Handle downloaded presence information using:
       			// result.data.channels - dictionary with active channels and presence information on 
       			// each. Each channel will have next fields: "uuids" - list of
       			// subscribers; "occupancy" - number of active subscribers.
       			// result.data.totalChannels - total number of active channels.
       			// result.data.totalOccupancy - total number of active subscribers.
    		}
    		// Request processing failed.
    		else {
       			// Handle presence audit error. Check 'category' property to find out possible issue because
       			// of which request did fail.
       			//
       			// Request can be resent using: [status retry];
    		}
      })
        
Example Response:

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
	
##Here Now For Channel Groups
####Description 
Request information about subscribers on specific channel group. This API method will retrieve the list of UUIDs along with their state for each remote data object and the number of subscribers.

####Method(s)
To do `Here Now for Channel Groups` you can use the following method(s) in the Swift SDK

`Void hereNowForChannelGroup(group: String!, withCompletion: PNChannelGroupHereNowCompletionBlock!(PNPresenceChannelGroupHereNowResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`group`| String! | Yes | Reference on `channel group` for which here now information should be received.
`block`| PNHereNowCompletionBlock | Yes | Here now processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of here now operation; status - in case if `error` occurred during request processing.

`Void hereNowForChannelGroup(group: String!, withVerbosity: PNHereNowVerbosityLevel, completion: PNChannelGroupHereNowCompletionBlock!(PNPresenceChannelGroupHereNowResult!, PNErrorStatus!) -> Void)`

* Parameter | Type | Required | Description
--- | --- | --- | ---
`group`| String! | Yes | Reference on `channel group` for which here now information should be received.
`level`| PNHereNowVerbosityLevel | Yes | Reference on one of `PNHereNowVerbosityLevel` fields to instruct what exactly data it expected in response.
`block`| PNHereNowCompletionBlock | Yes | Here now processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of here now operation; status - in case if `error` occurred during request processing.

####Basic Usage
Here Now for Channel Groups:

	    var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client.hereNowForChannelGroup("developers", withCompletion: { (result, status) -> Void in
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
                // Request can be resent using: [status retry];
            }
        })
        
####Returns
The `hereNowForChannelGroup` function returns a list of uuid s currently subscribed to the channel.

* `uuids:["String","String", … ,"String"]` - List of UUIDs currently subscribed to the channel.
* `occupancy: Number` - Total current occupancy of the channel.

		{
    		occupancy: 4,
   			uuids: [‘123123234t234f34fq3dq’, ‘143r34f34t34fq34q34q3’, ‘23f34d3f4rq34r34rq23q’, ‘w34tcw45t45tcw435tww3’]
		}
		
##History
####Description
This function fetches historical messages of a channel.

PubNub Storage/Playback Service provides real-time access to an unlimited history for all messages published to PubNub. Stored messages are replicated across multiple availability zones in several geographical data center locations. Stored messages can be encrypted with AES-256 message encryption ensuring that they are not readable while stored on PubNub’s network.

It is possible to control how messages are returned and in what order, for example you can:

* Search for messages starting on the newest end of the timeline (default behavior - `reverse` = `NO`)
* Search for messages from the oldest end of the timeline by setting `reverse` to `YES`.
* Page through results by providing a `start` OR `end` timetoken.
* Retrieve a slice of the time line by providing both a `start` AND `end` timetoken.
* Limit the number of messages to a specific quantity using the `limit` parameter.

####Start & End parameter usage clarity:
If only the `start` parameter is specified (without `end`), you will receive messages that are older than and up to that `start` timetoken value.

If only the `end` parameter is specified (without `start`) you will receive messages that match that `end` timetoken value and newer.

Specifying values for both `start` and `end` parameters will return messages between those timetoken values (inclusive on the `end` value).

Keep in mind that you will still receive a maximum of 100 messages even if there are more messages that meet the timetoken values. Iterative calls to history adjusting the `start` timetoken is necessary to page through the full set of results if more than 100 messages meet the timetoken values.

####Method(s)
To run History you can use the following method(s) in the Swift SDK

`Void historyForChannel(channel: String!, withCompletion: PNHistoryCompletionBlock!(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`block`| PNHistoryCompletionBlock | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

`Void historyForChannel(channel: String!, start: NSNumber!, end: NSNumber!, withCompletion: PNHistoryCompletionBlock!##(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`startDate`| NSNumber! | Yes | Reference on time token for oldest event starting from which next should be returned events.
`endDate`| NSNumber! | Yes | Reference on time token for latest event till which events should be pulled out.
`block`| PNHistoryCompletionBlock | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

`Void historyForChannel(channel: String!, start: NSNumber!, end: NSNumber!, limit: UInt, withCompletion: PNHistoryCompletionBlock!(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`startDate`| NSNumber! | Yes | Reference on time token for oldest event starting from which next should be returned events.
`endDate`| NSNumber! | Yes | Reference on time token for latest event till which events should be pulled out.
`limit`| NSNumber! | Yes | Maximum number of events which should be returned in response (not more then 100).
`block`| UInt | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

`Void historyForChannel(channel: String!, start: NSNumber!, end: NSNumber!, includeTimeToken: Bool, withCompletion: PNHistoryCompletionBlock!(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`startDate`| NSNumber! | Yes | Reference on time token for oldest event starting from which next should be returned events.
`endDate`| NSNumber! | Yes | Reference on time token for latest event till which events should be pulled out.
`includeTimeToken`| Bool | Yes | Whether event dates (time tokens) should be included in response or not.
`block`| UInt | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

`Void historyForChannel(channel: String!, start: NSNumber!, end: NSNumber!, limit: UInt, includeTimeToken: Bool, withCompletion: PNHistoryCompletionBlock!(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`startDate`| NSNumber! | Yes | Reference on time token for oldest event starting from which next should be returned events.
`endDate`| NSNumber! | Yes | Reference on time token for latest event till which events should be pulled out.
`limit`| NSNumber! | Yes | Maximum number of events which should be returned in response (not more then 100).
`includeTimeToken`| Bool | Yes | Whether event dates (time tokens) should be included in response or not.
`block`| UInt | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

`historyForChannel(channel: String!, start: NSNumber!, end: NSNumber!, limit: UInt, reverse: Bool, withCompletion: PNHistoryCompletionBlock!(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`startDate`| NSNumber! | Yes | Reference on time token for oldest event starting from which next should be returned events.
`endDate`| NSNumber! | Yes | Reference on time token for latest event till which events should be pulled out.
`limit`| NSNumber! | Yes | Maximum number of events which should be returned in response (not more then 100).
`reverse`| Bool | Yes | Whether events order in response should be reversed or not.
`block`| UInt | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

`historyForChannel(channel: String!, start: NSNumber!, end: NSNumber!, limit: UInt, reverse: Bool, includeTimeToken: Bool, withCompletion: PNHistoryCompletionBlock!(PNHistoryResult!, PNErrorStatus!) -> Void)`

Parameter | Type | Required | Description
--- | --- | --- | ---
`channel`| String! | Yes | Name of the `channel` for which events should be pulled out from storage.
`startDate`| NSNumber! | Yes | Reference on time token for oldest event starting from which next should be returned events.
`endDate`| NSNumber! | Yes | Reference on time token for latest event till which events should be pulled out.
`limit`| NSNumber! | Yes | Maximum number of events which should be returned in response (not more then 100).
`reverse`| Bool | Yes | Whether events order in response should be reversed or not.
`includeTimeToken`| Bool | Yes | Whether event dates (time tokens) should be included in response or not.
`block`| UInt | Yes | History pull processing completion `block` which pass two arguments: result - in case of successful request processing data field will contain results of history request operation; status - in case if error occurred during request processing.

####Basic Usage
Retrieve the last 100 messages on a channel:

	    var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client.historyForChannel("my_channel", start: nil, end: nil, limit: 100) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
        
####Returns
The Swift SDK returns false on fail. An array is returned on success. The `historyForChannel` function returns a list of up to 100 messages, the time token of the first (oldest) message and the time token of the last (newest) message in the resulting set of messages. The output below demonstrates the format for a `historyForChannel` response:

	[["message1", "message2", "message3",... ],"Start Time Token","End Time Token"]
	
####Other Examples

Use `historyForChannel` to retrieve the three oldest messages by retrieving from the time line in reverse:

	    var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client.historyForChannel("my_channel", start: nil, end: nil, limit: 3, reverse: true) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }

####Response:
	
	[["Pub1","Pub2","Pub3"],13406746729185766,13406746780720711]
	
Use `historyForChannel` to retrieve messages newer than a given time token by paging from oldest message to newest message starting at a single point in time (exclusive):

	    var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client.historyForChannel("my_channel", start: 13406746780720711, end: nil, limit: 100, reverse: true) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
        
####Response

	[["Pub3","Pub4","Pub5"],13406746780720711,13406746845892666]

Use `historyForChannel` to retrieve messages until a given time token by paging from newest message to oldest message until a specific end point in time (inclusive):

	    var client: PubNub
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub.clientWithConfiguration(config)
        client.historyForChannel("my_channel", start: nil, end: 13406746780720711, limit: 100, includeTimeToken: false) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
        
####Response

	[["Pub3","Pub4","Pub5"],13406746780720711,13406746845892666]
	
Paging History Responses:
`Usage! You can call the method by passing null or a valid time token as the argument.`

	func requestHistoryWithStartDate(date: NSNumber){
        client.historyForChannel("my_channel", start: date, end: nil, limit: 100, includeTimeToken: true) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
                if (result.data.messages.count < 100) {
                    
                    // We received last message in the channel.
                }
                else {
                    
                    self.requestHistoryWithStartDate(result.data.end)
                }
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }
    }

##Init
####Description
This function is used for initializing the PubNub Client API environment. This function must be called before attempting to utilize any API functionality in order to establish account level credentials such as publishKey and subscribeKey, set origin server as well as any optional configurations such as uuid.

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

Initialize the PN instance, then subscribe and publish a message

	class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {    

    	var client : PubNub
    	var config : PNConfiguration


		override init() {
        	config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        	client = PubNub.clientWithConfiguration(config)       
        	client.subscribeToChannels(["My_Channel"], withPresence: false) 
        	super.init()       	
        	client.addListener(self)
    	}	
    
    	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    	    	...
    	 }
    	
    	...
    	
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
    
####Copy and paste examples:
#####Init

Instantiate a new Pubnub instance. Only the `subscribeKey` is mandatory. Also include `publishKey` if you intend to publish from this instance, and the `secretKey` if you wish to perform PAM administrative operations from this Swift instance.

`It is not a best practice to include the secret key in client-side code for security reasons.`
    		
    		var client : PubNub
			var config : PNConfiguration
            config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        	client = PubNub.clientWithConfiguration(config)
        	
 ^#***PubNub instance should be placed as a property in a long-life object(otherwise PubNub instance will be automatically removed as autoreleased object). ***
 
#####Time
Call `timeWithCompletion` to verify the client connectivity to the origin:

	   client.timeWithCompletion { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded server time token using: result.data.timetoken
            }
            // Request processing failed.
            else {
                
                // Handle tmie token download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
        }
     
#####Subscribe
Subscribe (listen on) a channel (it's async!):
 
 
 		var client : PubNub
    	var config : PNConfiguration

		override init() {
        	config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        	client = PubNub.clientWithConfiguration(config)
        	
        	super.init()
        	  
        	//Subscription process results arrive to listener which should adopt to PNObjectEventListener protcol and registered using:     	
        	client.addListener(self)
        	
        	//Listeners callbacks:       
        	client.subscribeToChannels(["My_Channel"], withPresence: false) 
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
    	
    	
#####Publish
Publish a message to a channel:

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
        
#####Here Now
Get occupancy of who's `here now` on the channel by UUID:

`Requires that the `Presence` add-on is enabled for your key. How do I enable add-on features for my keys? - see [http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys]`

 	client.hereNowForChannel("my_channel", withVerbosity: PNHereNowVerbosityLevel.UUID) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded presence information using:
                //   result.data.uuids - list of uuids.
                //   result.data.occupancy - total number of active subscribers.
            }
                // Request processing failed.
            else {
                
                // Handle presence audit error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: [status retry];
            }
        }


#####Presence
Subscribe to real-time Presence events, such as `join`, `leave`, and `timeout`, by UUID. Setting the presence attribute to a callback will subscribe to presents events on `my_channel`:

`Requires that the `Presence` add-on is enabled for your key. How do I enable add-on features for my keys? - see [http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys]`



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
    	
#####History
Retrieve published messages from archival storage:

`Requires that the `Storage and Playback` add-on is enabled for your key. How do I enable add-on features for my keys? - see http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys`

	client.historyForChannel("my_channel", start: nil, end: nil, limit: 100, withCompletion: { (PNHistoryResult result, PNErrorStatus status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry();
            }
        })
        
#####Unsubscribe
Stop subscribing (listening) to a channel.



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
