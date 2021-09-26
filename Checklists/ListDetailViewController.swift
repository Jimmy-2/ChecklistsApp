//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Jimmy  on 9/25/21.
//  View controller for the list of checklists screen

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
  func listDetailViewControllerDidCancel(
    _ controller: ListDetailViewController)

  func listDetailViewController(
    _ controller: ListDetailViewController,
    didFinishAdding checklist: Checklist
  )

  func listDetailViewController(
    _ controller: ListDetailViewController,
    didFinishEditing checklist: Checklist
  )
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!

    weak var delegate: ListDetailViewControllerDelegate?

    var checklistToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
        
    //pop up the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: Actions
    //add actions methods for cancel and done buttons
    
    // MARK: - Actions
    @IBAction func cancel() {
      delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
      if let checklist = checklistToEdit {
        checklist.name = textField.text!
        delegate?.listDetailViewController(
          self,
          didFinishEditing: checklist)
      } else {
        let checklist = Checklist(name: textField.text!)
        delegate?.listDetailViewController(
          self,
          didFinishAdding: checklist)
      }
    }

    // MARK: - Table View Delegates
    
    //make sure user cannot select the table cell with the text field
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
      return nil
    }
    
    // MARK: - Text Field Delegates
    // text field delegate methods that enable/disable the done button depending on wehter the text field is empty or not
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

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }

    

    
}
