//
//  AddRemarkViewController.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift


class AddRemarkViewController: UIViewController {
    
    // MARK: - Vars & IBOutlets
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextView!

    private var realm: Realm!
    
    var remark: Remark!
    var selectedAnnotation: RemarkAnnotation!
    
    //MARK: - Validation
    func validateFields() -> Bool {
        
        if titleTextField.text!.isEmpty || descriptionTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return false
            
        } else {
            return true
        }
    }
    
    func fillTextFields() {
        titleTextField.text = remark.title
        descriptionTextField.text = remark.detail
    }
    
    func updateRemark() {
        try! realm.write {
            self.remark.title = self.titleTextField.text!
            self.remark.detail = self.descriptionTextField.text
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let remark = remark {
            title = "Edit \(remark.title)"
            fillTextFields()
        } else {
            title = "Add Remark"
        }
    }
    
    func addNewRemark() {
        
        try! realm.write {
            let remark = Remark()
            
            remark.title = self.titleTextField.text! // 4
            remark.detail = self.descriptionTextField.text
            remark.locationLatitude = self.selectedAnnotation.coordinate.latitude
            remark.locationLongitude = self.selectedAnnotation.coordinate.longitude
            remark.username = UserDefaults.standard.value(forKey: Constants.Keys.username) as! String
            remark.addedDate = Date()
            realm.add(remark)
            self.remark = remark
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if validateFields() {
            if remark != nil {
                updateRemark()
            } else {
                addNewRemark()
            }
            return true
        } else {
            return false
        }
    }}

//MARK: - UITextFieldDelegate
extension AddRemarkViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

