//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Matthew Riddle on 27/04/2016.
//  Copyright © 2016 Matthew Riddle. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
  var text: String
  var checked: Bool
  
  init(text: String, checked: Bool) {
    self.text = text
    self.checked = checked
  }
  
  func toggleChecked() {
    checked = !checked
  }

  
}