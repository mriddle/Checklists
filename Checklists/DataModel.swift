import Foundation

/**
 Helper singleton to save, load, and perform operations for data persistence using UserDefaults and DocumentsDirectory.
 */
class DataModel {
    
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    /**
     Returns the documents directory.
     - returns: NSString
     */
    func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0] as NSString
    }
    
    /**
     Returns the location of the file where the checklists will be saved.
     - returns: String
     */
    func dataFilePath() -> String {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    /**
     Saves the current list of checklists.
     */
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    /**
     Loads the checklists then sorts the checklists.
     */
    func loadChecklists() {
        print("Loading file \(dataFilePath())")
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                lists = unarchiver.decodeObject(forKey: "Checklists")
                    as! [Checklist]
                unarchiver.finishDecoding()
                sortChecklists()
            }
        }
    }
    
    /**
     Registers UserDefaults data to determine app's default state at startup.
     */
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1,
                          "FirstTime": true,
                          "ChecklistItemID": 0] as [String : Any]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    /**
     Handles the first time the app is opened. If it is the first time the app is opened, a new checklist with no items is created.
     */
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List", items: [], iconName: "No Icon")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    /**
     Sorts checklists in alphabetical order by name.
     */
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in return checklist1.name.localizedCompare(checklist2.name) == .orderedAscending })
    }
    
    /**
     Returns the current ChecklistItemID and then increments the itemID to keep track of all items in a checklist. The ChecklistItemID is used to keep track of notifications of a particular checklist item.
     - returns: Int
     */
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}
