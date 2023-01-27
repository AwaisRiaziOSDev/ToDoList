//
//  LocalNotification.swift
//  To-Do List
//
//  Created by Awais Malik on 26/01/2023.
//

import Foundation
import UIKit
class LocalNotification{
    
    // Register Local notification
    func schecduleNotificaion(identifier: String, title: String, body: String, dateTime: Date){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateTime) //log ▿ year: 2018 month: 10 day: 20 hour: 18 minute: 11 second: 0 isLeapMonth: false
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                
                print(error)
            }
        })
    }
        
 // remove local notification with identifier
   func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
   }
        
}
