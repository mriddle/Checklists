import UIKit

class Checklist: NSObject, NSCoding {
    
    //MARK: - Properties
    
    var name: String
    var items: [ChecklistItem]
    var iconName: String
    
    //MARK: - Initialization
    
    init(name: String, items: [ChecklistItem], iconName: String) {
        self.name = name
        self.items = items
        self.iconName = iconName
        super.init()
    }
    
    //MARK: - Methods
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    //MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
}
