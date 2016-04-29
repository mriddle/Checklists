import UIKit

class AllListsViewController: UITableViewController {

  var lists = [
    Checklist(name: "Birthdays"),
    Checklist(name: "Groceries"),
    Checklist(name: "Cool Apps"),
    Checklist(name: "To Do")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = cellForTableView(tableView)
    
    let checklist = lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .DetailDisclosureButton
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let checklist = lists[indexPath.row]
    performSegueWithIdentifier("ShowChecklist", sender: checklist)
  }
  
  func cellForTableView(tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
  }
}
