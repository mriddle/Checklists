import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var dataModel: DataModel!
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /**
         Executed when the app is opened for the first time. Performs segue to ChecklistViewController to prompt user to add items to a default checklist created on startup.
         */
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index != -1 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)
        /**
         Configures table cell to have the name, details, and image of the checklist.
         */
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if uncheckedItems == 0 {
            cell.detailTextLabel!.text = "All Done"
        } else {
            cell.detailTextLabel!.text = "\(checklist.countUncheckedItems())  Remaining"
        }
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         Opens the checklist that is tapped.
         */
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        /**
         Deletes the checklist.
         */
        dataModel.lists.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /**
         Presents the ListDetailViewController when the accessory button is tapped.
         */
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func cellForTableView(_ tableView: UITableView) -> UITableViewCell {
        /**
         Returns the cell from the table view.
         - returns: UITableViewCell
         */
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    //MARK: - Transition
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    //MARK: - ListDetailViewControllerDelegate
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        /**
         Adds new checklist to the list of all lists then sorts it.
         */
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
        /**
         When a checklist is finished editing (new checklist name and image), sorts all the checklists based on the new checklist name.
         */
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        /**
         If the initial view controller is the navigation view controller, set indexOfSelectedChecklist to -1 to go indicate that there are no checklists, so a new checklist is created by default.
         */
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
}
