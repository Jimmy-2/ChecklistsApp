//
//  ViewController.swift
//  Checklists
//
//  Created by Jimmy  on 9/16/21.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        
        navigationController?.popViewController(animated: true)
    }
    func addItemViewController(
      _ controller: AddItemViewController,
      didFinishEditing item: ChecklistItem
    ) {
      if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated: true)
    }
    
    /*
    var row0item = ChecklistItem()
    var row1item = ChecklistItem()
    var row2item = ChecklistItem()
    var row3item = ChecklistItem()
    var row4item = ChecklistItem()
    */
    
    //list of checklist items displayed on the screen
    var items = [ChecklistItem]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true // makes title of navigation bar large
        // Do any additional setup after loading the view.
        let item1 = ChecklistItem()
        item1.text = "walk the dog"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "brush my teech"
        item2.checked = true
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "soccer"
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "ios"
        item4.checked = true
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "eat ice"
        items.append(item5)
        
        let item6 = ChecklistItem()
        item6.text = "ewqwe"
        item6.checked = true
        items.append(item6)
        
    }

    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView, //caller is UITableView //parameter 1
        numberOfRowsInSection section: Int // parameter 2 section number
    ) -> Int { //return value
        return items.count //tells table view that we have only 1 row of data if return 1
        
    }
    
    override func tableView( //this method name is cellForRowAt
        //this method is where you would put row data into the cell and return it
        //method signatures: tableView(_:cellForRowAt:)
        _ tableView: UITableView, //parameter 1
        cellForRowAt indexPath: IndexPath // parameter 2
    ) -> UITableViewCell { // return value
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        
        //
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table View Delegate
    //gets called whenever the user taps on a cell
    override func tableView(
        _ tableView: UITableView, //parameter 1
        didSelectRowAt indexPath: IndexPath //parameter 2
    ) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            //calls this method to update the view
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        items.remove(at: indexPath.row) //remove item from data model, in addItem you append, here you remove
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) //delete corresponding row from table view
    }
    
    
    //sets accessory, does not toggle, forexample, the checkmarks are originally set to false in the instance variables. this method helps display them at the very beginning accurately
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        }else {
            label.text = ""
        }
    }
    
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    
    ) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Actions
    
    /*
    
    @IBAction func addItem() {
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = true
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section:0)
        let indexPaths = [indexPath] // [indexPath1,indexPath2, etc] if you want to insert more than 1 row
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
 
    */
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue, sender: Any?
    ) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            
            controller.delegate = self
        }else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self

            if let indexPath = tableView.indexPath(
              for: sender as! UITableViewCell) {
              controller.itemToEdit = items[indexPath.row]
            }
        }
        
    }
    
}

