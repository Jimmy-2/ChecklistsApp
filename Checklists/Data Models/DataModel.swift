//
//  DataModel.swift
//  Checklists
//
//  Created by Jimmy  on 9/27/21.
//  Top-level data model for saving and loading
// taking over responsibilites from AllListsViewController

import Foundation

class DataModel {
    //new DataModel object with lists property
    var lists = [Checklist]()
    
    //if app tries to read value of indexOfSelectedChecklist, the code in get gets performed. If the app tries to put a new value into indexOfSelectedChecklist, the code in set gets performed
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(
          forKey: "ChecklistIndex")
      }
      set {
        UserDefaults.standard.set(
          newValue,
          forKey: "ChecklistIndex")
      }
    }

    
    //as soon as DataModel object is created, it will attempt to load Checklists.plist
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //creates new dictionary instance that adds the value -1 for the key "ChecklistIndex"
    func registerDefaults() {
        //this is not an array, it is a dictionary
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //method is called if user opens app for the first time
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        //if firsttime = true
        if firstTime {
            //create new checklist object called List and add it to the array
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            //seet indexOfSelectedChecklist to 0 because it is the index of this newly added Checklist object
            //to make sure the app will automatically segue to the new list in the viewDidAppear method in alllistviewcontroller.swift
            indexOfSelectedChecklist = 0
            //set value of FirstTime to false because it will no longer be the first time user opens app
            userDefaults.set(false, forKey: "FirstTime")
            
        }
    }
    
    // MARK: - Data Saving
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      return paths[0]
    }

    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    // this method is now called saveChecklists()
    func saveChecklists() {
      let encoder = PropertyListEncoder()
      do {
        // You encode lists instead of "items"
        let data = try encoder.encode(lists)
        try data.write(
          to: dataFilePath(),
          options: Data.WritingOptions.atomic)
      } catch {
        print("Error encoding list array: \(error.localizedDescription)")
      }
    }

    // this method is now called loadChecklists()
    func loadChecklists() {
      let path = dataFilePath()
      if let data = try? Data(contentsOf: path) {
        let decoder = PropertyListDecoder()
        do {
          // You decode to an object of [Checklist] type to lists
          lists = try decoder.decode(
            [Checklist].self,
            from: data)
        } catch {
          print("Error decoding list array: \(error.localizedDescription)")
        }
      }
    }

}
