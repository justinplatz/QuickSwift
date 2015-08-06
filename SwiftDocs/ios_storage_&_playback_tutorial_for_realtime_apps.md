#iOS Storage & Playback Tutorial for Realtime Apps

##Storage & Playback Overview

`Requires that the Storage and Playback add-on is enabled for your key. How do I enable add-on features for my keys? - see http://www.pubnub.com/knowledge-base/discussion/644/how-do-i-enable-add-on-features-for-my-keys`

PubNub's Storage and Playback feature enables developers to store messages as they are published, and retrieve them at a later time. Before using this feature it must be enabled in the PubNub Admin Console.

####STORAGE APPLICATIONS

Being able to pull an archive of messages from storage has many applications:

* Populate chat, collaboration and machine configuration on app load.
* Store message streams with real-time data management.
* Retrieve historical data streams for reporting, auditing and compliance (HIPAA, SOX, Data Protection Directive, and more).
* Replay live events with delivery of real-time data during rebroadcasting.

####STORAGE API FEATURES

As needed, specific messages can be marked "do not archive" when published to prevent archiving on a per-message basis, and storage retention time can range from 1 day to forever.

####PUBNUB STORAGE OBJECTIVE-C CODE SAMPLES

`These code samples build off code defined in the Pub & Sub tutorial, so before proceeding, be sure you have completed the Pub & Sub tutorial first.`

####PREPARING THE CHANNEL FOR HISTORY OPERATIONS

To begin, lets populate a new channel with some test publishes that we'll pull from storage using the `historyForChannel` method:

	var client : PubNub
    var config : PNConfiguration
    
    override init() {
        config = PNConfiguration(publishKey: "Demo", subscribeKey: "Demo")
        client = PubNub.clientWithConfiguration(config)
        
        for(var i = 0; i < 50; i++){
            var message = "message\(i)"
            client.publish(message, toChannel: "my_channel", withCompletion: { (status) -> Void in
                // Check whether request successfully completed or not.
                if (!status.error) {
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
        
        super.init()
        client.addListener(self)
        client.subscribeToChannels(["my_channel"], withPresence: false)
    }


In the above example, we subscribe to `history_channel`, and onConnect, we'll publish a barrage of test messages to it. You should see these messages as they are published on the console.

Pulling from Storage with a simple `history` call Now that we've populated storage, we can pull from storage using the `historyForChannel` method call:

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
                // Request can be resent using: status.retry()
            }
        }
        
The response format is

	[["message1", "message2", "message3",... ],"Start Time Token","End Time Token"]

####SETTING THE COUNT
By default, `historyForChannel` returns the last 100 messages, first-in-first-out (FIFO). Although we specified 100 for the `limit`, that is the default, and if we hadn't specified a `limit`, we would have still received 100. Try this example again, but specify 5 for `limit` to see what is returned.

####SETTING REVERSE (TRAVERSAL DIRECTION)

Setting the reverse attribute to true will return the first 100 messages, first-in-first-out (FIFO). Try this example again, but specify `YES` for `reverse` to see what is returned.

####PAGING
Given this example, you will get the last two messages published to the channel:

 	client.historyForChannel("my_channel", start: nil, end: nil, limit: 2, reverse: false, includeTimeToken: true) { (result, status) -> Void in
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
                    
                    //////TODO
                }
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
        }
        
####RESPONSE
	
	[[498,499],14272454823679518,14272454845442942] 
	
To page for the next 2, use the set the `start` attribute to start timetoken value, and request again with all other settings the same:

	[[496,497],14272454791882580,14272454823679518]
	
As illustrated, paging with the default `reverse` as `YES` pages 2 at-a-time starting from newest, in FIFO order. If you repeat these Paging example steps with `reverse` as `NO`, you will page 2 at-a-time as well, starting instead from the oldest messages, but still in FIFO order. You will know you are at the end of history when the returned start timetoken is 0.

####RETRIEVING FROM A TIME INTERVAL

To pull from a slice of time, just include both `start` and `end` attributes:
 
	    let calendar = NSCalendar.currentCalendar()
        let twoDaysAgo = calendar.dateByAddingUnit(.CalendarUnitDay, value: -2, toDate: NSDate(), options: nil)
        var now = NSDate()
        now.timeIntervalSinceReferenceDate
        client.historyForChannel("my_channel", start: twoDaysAgo?.timeIntervalSinceReferenceDate , end: now.timeIntervalSinceReferenceDate, limit: 100) { (result, status) -> Void in
            // Check whether request successfully completed or not.
            if (!status.error) {
                
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
                
                print(result.data.messages)
            }
                // Request processing failed.
            else {
                
                // Handle message history download error. Check 'category' property to find
                // out possible issue because of which request did fail.
                //
                // Request can be resent using: status.retry()
            }
 
        }
 
####CONVERTING FROM TIMETOKENS TO UNIXTIME

The timetoken response value is a string, representing 17-digit precision unix time (UTC). To convert PubNub's timetoken to Unix timestamp (seconds), divide the timetoken number by 10,000,000 (10^7).


 
