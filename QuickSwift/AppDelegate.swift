//
//  AppDelegate.swift
//  QuickSwift
//
//  Created by Justin Platz on 6/15/15.
//  Copyright (c) 2015 ioJP. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?
    
    var client:PubNub?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = PNConfiguration(
            publishKey: "pub-c-f83b8b34-5dbc-4502-ac34-5073f2382d96",
            subscribeKey: "sub-c-34be47b2-f776-11e4-b559-0619f8945a4f")
//        let config = PNConfiguration(
//            publishKey: "demo-36", subscribeKey: "demo-36"
//        )
        
        client = PubNub.clientWithConfiguration(config)
        
        client?.subscribeToChannels(["demo"], withPresence: false)
        
        client?.subscribeToPresenceChannels(["demo"])
        
//        NSNumber *startDate = @((unsigned long long)([[NSDate dateWithTimeIntervalSinceNow:-(60*60)] timeIntervalSince1970]*10000000));
//        NSNumber *endDate = @((unsigned long long)([[NSDate date] timeIntervalSince1970]*10000000));
    
        let startInterval:NSNumber = NSDate(timeIntervalSinceReferenceDate: -(60*60)).timeIntervalSince1970*10000000
        let endInterval:NSNumber = NSDate().timeIntervalSince1970*10000000
        
        var first:NSNumber = NSDate(timeIntervalSinceNow: -600).timeIntervalSince1970*10000000
        var second:NSNumber =  NSDate(timeIntervalSinceNow: -30).timeIntervalSince1970*10000000
        
//        var one: NSNumber = 14350904008290302
//        var two: NSNumber = 14350906104420848
        var one: NSNumber = NSNumber(longLong: 14350904008290302)
        var two: NSNumber = NSNumber(longLong: 14350906104420848)
        
        client?.historyForChannel("demo", start: one, end: two, includeTimeToken: true, withCompletion: { (result, status) -> Void in
            
            println(result!)
        })

//        client?.historyForChannel("demo", start: one, end: two, includeTimeToken: true, withCompletion: { (PNHistoryResult result, PNErrorStatus status) -> Void in
//            
//            // Check whether request successfully completed or not.
//            //if (!status.isError) {
//                
//                // Handle downloaded history using:
//                //   result.data.start - oldest message time stamp in response
//                //   result.data.end - newest message time stamp in response
//                //   result.data.messages - list of dictionaries. Each entry will include two keys:
//                //                          "message" - for body and "timetoken" for date when message has
//                //                          been sent.
//                println("******historyForChannel*****")
//                println("First is ")
//                println(first)
//                println("Second is ")
//                println(second)
//                println(result.data.start)
//                println(result.data.end)
//                println(result.data.messages)
//
//            //}
//                 //Request processing failed.
//            //else {
//                
//                 //Handle message history download error. Check 'category' property to find out possible
//                 //issue because of which request did fail.
//            
//                 //Request can be resend using: [status retry];
//            //}
//        })
        
        client?.publish("Swift + PubNub!", toChannel: "demo", compressed: false, withCompletion: nil)
        
        client?.addListener(self)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!, withStatus status: PNErrorStatus!) {
        println("******didReceiveMessage*****")
        println(message.data)
    }
    
    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        println("******didReceivePresenceEvent*****")
        println(event.data)
    }

}

