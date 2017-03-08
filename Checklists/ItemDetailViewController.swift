//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Matthew Riddle on 28/04/2016.
//  Copyright © 2016 Matthew Riddle. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate as Date
        }
        
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // Open the keyboard when the view controller is presented
    }
    
    //MARK: - Actions
    
    @IBAction func done() {
        /**
         If the item is already in a checklist, finishes editing the item and sets the new values for the item. If a checklist does not exist, creates a new checklist and adds this item to the checklist.
         */
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        /**
         Closes the keyboard when the switch is toggled and schedules a notification if the switch is on.
         */
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3 // item name, due date, and shouldRemind switch
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         Only selectable table cell is the date picker cell. Opens date picker when if the date picker cell is selected.
         */
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            datePickerVisible ? hideDatePicker() : showDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /**
         Sets placeholder text as the current item name. Checks if the new text is different from the old text, and if it is, allows the user to change the item name to the new text.
         */
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
    //MARK: - Date helper functions
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium /// example medium style date - November 23, 1983
        formatter.timeStyle = .short /// example short style time - 3:30 pm
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let IndexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [IndexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
}
