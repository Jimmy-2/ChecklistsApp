//
//  ViewController.swift
//  Checklists
//
//  Created by Jimmy  on 9/16/21.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        
        navigationController?.popViewController(animated: true)
        
        //saveChecklistItems()
    }
    func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishEditing item: ChecklistItem
    ) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        //saveChecklistItems()
    }
    
    /*
    var row0item = ChecklistItem()
    var row1item = ChecklistItem()
    var row2item = ChecklistItem()
    var row3item = ChecklistItem()
    var row4item = ChecklistItem()
    */
    
    //list of checklist items displayed on the screen
    //var items = [ChecklistItem]()
    
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true // makes title of navigation bar large
        navigationItem.largeTitleDisplayMode = .never
        /*
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
        
        */
        //loadChecklistItems()
        
        title = checklist.name
        
        //for debug purposes, showing where the data file is
        //print("Documents folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
    }

    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView, //caller is UITableView //parameter 1
        numberOfRowsInSection section: Int // parameter 2 section number
    ) -> Int { //return value
        return checklist.items.count //tells table view that we have only 1 row of data if return 1
        
    }
    
    override func tableView( //this method name is cellForRowAt
        //this method is where you would put row data into the cell and return it
        //method signatures: tableView(_:cellForRowAt:)
        _ tableView: UITableView, //parameter 1
        cellForRowAt indexPath: IndexPath // parameter 2
    ) -> UITableViewCell { // return value
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        
        //
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table View Delegate
    
    
    //gets called whenever the user taps on a cell
    //toggling the checkmark on a row
    override func tableView(
        _ tableView: UITableView, //parameter 1
        didSelectRowAt indexPath: IndexPath //parameter 2
    ) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            //calls this method to update the view
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        //saveChecklistItems()
    }
    
    //swipe to delete function
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        checklist.items.remove(at: indexPath.row) //remove item from data model, in addItem you append, here you remove
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) //delete corresponding row from table view
        
        //saveChecklistItems()
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
    
    
    //the following commented out methods were used to load ans save checklist items from a file. It is no longer the responsibility of this view controller but instead in Checklist object
    /*
    //returns full path to the documents folder (where we will be storing the data for our app)
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
    //uses documentsDirectory() to construct full path to the file that will store the check list items
    //file will be called Checklists.plist
    //iOS uses file:// URL to refer to files
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    //save checklist items into a file
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data =  try encoder.encode(items)
            
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    //load checklist items file
    func loadChecklistItems() {
        //put results of dataFilePath() in a temp constant called path
        let path = dataFilePath()
        
        
        //try and load contents of Checklists.plist into a new Data object
        //try? attempts to create Data object but returns nil if fails to do so, if let is added on
        //for example, when app is loaded for the very first time and has no data file
        if let data = try? Data(contentsOf: path) {
            //if app finds a Checklsits.plist file, it will load entried array and contents from the file using PropertyListDecoder
            let decoder = PropertyListDecoder()
            do{
                //load saved data back into items using the decoder's decode method. Decoder needs to know the type of data and you can let it know by indicated that it is an array of ChecklistItem objects
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    */
    
    
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
            let controller = segue.destination as! ItemDetailViewController
            
            controller.delegate = self
        }else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self

            if let indexPath = tableView.indexPath(
              for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
        
    }
    
}

