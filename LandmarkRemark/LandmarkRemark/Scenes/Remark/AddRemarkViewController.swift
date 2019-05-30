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
    
    var remark: Remark?
    var viewModel = AddRemarkViewModel()
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
        
        guard let annotation = selectedAnnotation else { return }
        
        titleTextField.text = annotation.title
        descriptionTextField.text = annotation.remark?.detail
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remark = selectedAnnotation.remark
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let remark = remark {
            title = remark.title
            fillTextFields()
            navigationItem.rightBarButtonItem?.title = "Delete"
        } else {
            title = "Add Remark"
            navigationItem.rightBarButtonItem?.title = "Add"
        }
    }
    
    // MARK: - Action
    
    @IBAction func addNewRemark() {
        
        if let remarkToDelete = remark {
            viewModel.updateRemarkDatabase(with: remarkToDelete, mode: .delete)
        } else {
            let newRemark = Remark()
            newRemark.title = self.titleTextField.text! // 4
            newRemark.detail = self.descriptionTextField.text
            newRemark.locationLatitude = self.selectedAnnotation.coordinate.latitude
            newRemark.locationLongitude = self.selectedAnnotation.coordinate.longitude
            newRemark.username = UserDefaults.standard.value(forKey: Constants.Keys.username) as! String
            newRemark.addedDate = Date()
            self.remark = newRemark
            
            viewModel.updateRemarkDatabase(with: newRemark, mode: .add)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

