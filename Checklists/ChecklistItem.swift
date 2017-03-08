//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Matthew Riddle on 27/04/2016.
//  Copyright © 2016 Matthew Riddle. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding {
    
    //MARK: - Properties
    var text: String
    var checked: Bool
    var itemID: Int /// used to keep track of notifications for a given checklist item
    var dueDate = Date()
    var shouldRemind = false
    
    //MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(itemID, forKey: "ItemID")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
    }
    
    //MARK: - Initialization
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextChecklistItemID()
    }
    
    //MARK: - Methods
    
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
        /**
         Cancels any notifications already scheduled by the same item. If the user enables the app to remind them about the item, schedules a notification at the set due date.
         */
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            UIApplication.shared.cancelLocalNotification(notification)
        }
        if shouldRemind && dueDate.compare(Date()) != .orderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = TimeZone.current
            localNotification.alertBody = "I am a local notification!"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        /**
         Returns the notification for a given checklist item.
         - returns UILocalNotification
         */
        let allNotifications = UIApplication.shared.scheduledLocalNotifications!
        
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int, number == itemID {
                return notification
            }
        }
        return nil
    }
    
    deinit {
        if let notification = notificationForThisItem() {
            print("Remove existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
}
