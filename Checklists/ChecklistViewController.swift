//
//  ViewController.swift
//  Checklists
//
//  Created by Matthew Riddle on 27/04/2016.
//  Copyright © 2016 Matthew Riddle. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  var items: Array = [
    ChecklistItem(text: "Walk the dog", checked: false),
    ChecklistItem(text: "Brush teeth", checked: false),
    ChecklistItem(text: "Learn iOS development", checked: false),
    ChecklistItem(text: "Soccer practice", checked: false),
    ChecklistItem(text: "Eat ice cream", checked: false)
  ]


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
    let item = items[indexPath.row]
    
    configureTextForCell(cell, withChecklistItem: item)
    configureCheckmarkForCell(cell, withChecklistItem: item)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      let item = items[indexPath.row]
      item.checked = !item.checked
      
      configureCheckmarkForCell(cell, withChecklistItem: item)
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    if item.checked {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }
  }
  
  func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
}

