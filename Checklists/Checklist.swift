import UIKit

class Checklist: NSObject, NSCoding {
  var name: String
  var items: [ChecklistItem]
  
  init(name: String, items: [ChecklistItem]) {
    self.name = name
    self.items = items
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObjectForKey("Name") as! String
    items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "Name")
    aCoder.encodeObject(items, forKey: "Items")
  }
}
