//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Jimmy  on 9/25/21.
//

import UIKit
//AllListsViewController is the deletegate for ListDetailViewController and UINavigationController and implicitly for UItableView
class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    
    //! is necessary because dataModel will temporarily be nil when app boots
    var dataModel: DataModel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //enables large titles for this view controller
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        //no longer using the following code due to needing ot use subtitle style for check count. However dequeueReuseableCell doesnt allow us to specify a custom table view cell style
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        //intializaers are written as:
        //var object = ObjectName(parameter1: value1, parameter2: value2,...)
        /*
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "abc")
        lists.append(list)
        
        for list in lists {
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }
        */

        
    }
    
    //this method is called before viewDidAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    //UIKit automatically calls this method after the view controller becomes visible
    //viewdidappear is called everytime you land on the screen(main screen) while viewdidload is only called once when the app loads
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)

      navigationController?.delegate = self
        
      //let index = UserDefaults.standard.integer(forKey: "ChecklistIndex") changed into
      let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
        let checklist = dataModel.lists[index]
        performSegue(
          withIdentifier: "ShowChecklist",
          sender: checklist)
      }
        print("viewdidappear")
    }

    
    // MARK: - Navigation Controller Delegates
    
    //this method is called whenever navigation controller shows a new screen
    func navigationController(
      _ navigationController: UINavigationController,
      willShow viewController: UIViewController,
      animated: Bool
    ) {
      // Was the back button tapped?
      if viewController === self {
        
        //UserDefaults.standard.set(-1, forKey: "ChecklistIndex") changed into
        dataModel.indexOfSelectedChecklist = -1
      }
        print("willshow")
    }
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

   
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UITableViewCell! //constant that will hold the newly created cell
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        }else {
            cell = UITableViewCell (style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        //put some text into the cells so we can see the some text
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        //the cell's detailTextLabel property can be used to access the subtitle label
        //cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining"
        
        let count = checklist.countUncheckedItems()
        //checks if item count of checklist object is empty or not
        //checklist.items.count is the total number of items in the checklist
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        }else {
            //if statement happens (code after ? occurs) else (:)
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        
        //sets icon to be equal to checklist.iconName(from Checklist.swift. currently "No Icon" icon)
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    //this table view delegate method is evoked when a row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //store index of selected row into UserDefaults under key "ChecklsitIndex"
        //UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex") changed into
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    //allows user to delete checklists
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //
    override func tableView(
      _ tableView: UITableView,
      accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
      let controller = storyboard!.instantiateViewController(
        withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self

        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist

        navigationController?.pushViewController(
            controller,
            animated: true)
    }

    
    // MARK: - Navigation
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - List Detail View Controller Delegates
    
    //these methods are called when user presses cancel or done inside the new add/edit checklist screen
    func listDetailViewControllerDidCancel(
      _ controller: ListDetailViewController
    ) {
      navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishAdding checklist: Checklist
    ) {
        /*
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
 
    */
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishEditing checklist: Checklist
    ) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        
        /*
        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
 
        */
    }

    
}
