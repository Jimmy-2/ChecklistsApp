//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Jimmy  on 9/18/21.
//

import UIKit

//protocol listing name of methods
protocol AddItemViewControllerDelegate: class {
    
    func addItemViewControllerDidCancel (
        _ controller: AddItemViewController)
    func addItemViewController(
        _ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    
    func addItemViewController(
      _ controller: AddItemViewController,
      didFinishEditing item: ChecklistItem
    )
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    //delegates are usually declared as being weak
    weak var delegate: AddItemViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    //keybaord will automatically show up when this screen is opened
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: - Actions
    
    @IBAction func cancel() {
        //tells navigation controller to close Add Item screen with an animation and go to back to the previous screen
        //navigationController?.popViewController(animated: true)
        
        //when user taps the cancel button, additemviewcontrollerdidcancel messages gets sent back to delegate
        delegate?.addItemViewControllerDidCancel(self)
    }
    
 
@IBAction func done() {
        //print("Contents of the text field: \(textField.text!)")
        //navigationController?.popViewController(animated: true)
    if let item = itemToEdit {
        item.text = textField.text!
        delegate?.addItemViewController(
            self,
            didFinishEditing: item)
        
    } else {
        let item = ChecklistItem()
        item.text = textField.text!
        //when done is tapped, additemviewcontroller(_:didfinishadding:) message gets passed along with new checklistitem object
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
}
    
    
    // MARK: = Table View Delegates
    
    //disable selections for row
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    
    ) -> IndexPath? {
        return nil
    }
    
    // a UITextField delegate method, invoked everytime user changes the text, by tapping on keyboard of cut/paste
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
       
        return true
    }
    
    //enables done button to be disabled when pressing the clear button on the text field
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

}
