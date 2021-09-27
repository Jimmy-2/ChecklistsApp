//
//  Checklist.swift
//  Checklists
//
//  Created by Jimmy  on 9/25/21.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    
    //new empty array that can hold ChecklistItem objects (individual to-do items in each checklist object) and assigns it to the items property
    var items = [ChecklistItem]()
    // can also be written as var items: [ChecklistItem] = []
    
    
    //this initializer takes a parameter called name and places it into the (property) var name
    //use self.name to refer to the property(instance variable)
    // basically var name(self.name) = name (from parameter of init)
    init(name: String) {
        self.name = name
        super.init()
    }
}
