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
   
    var selectedAnnotation: RemarkAnnotation!
    private var remark: Remark?
    private var viewModel = AddRemarkViewModel()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remark = selectedAnnotation.remark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: - Action
    
    @IBAction func addNewRemark() {
        
        guard isValidToProceed() else { return }
        
        if let remarkToDelete = remark {
            viewModel.updateRemarkDatabase(with: remarkToDelete, mode: .delete)
        } else {
            let newRemark = Remark()
            newRemark.title = self.titleTextField.text! // 4
            newRemark.detail = self.descriptionTextField.text
            newRemark.locationLatitude = self.selectedAnnotation.coordinate.latitude
            newRemark.locationLongitude = self.selectedAnnotation.coordinate.longitude
            newRemark.username = DataManager.sharedInstance.userName
            newRemark.addedDate = Date()
            self.remark = newRemark
            
            viewModel.updateRemarkDatabase(with: newRemark, mode: .add)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Helper Functions

private extension AddRemarkViewController {
    func updateUI() {
        navigationController?.navigationBar.tintColor = .white
        
        if let remark = remark {
            title = remark.username
            fillTextFields()
            descriptionTextField.isEditable = false
            titleTextField.isUserInteractionEnabled = false
            
            // User can only delete the notes / remarks added by him/her
            if DataManager.sharedInstance.canDelete(remark) {
                navigationItem.rightBarButtonItem?.title = "Delete"
            }else {
                navigationItem.rightBarButtonItem?.title = ""
                navigationItem.rightBarButtonItem = nil
            }
        } else {
            title = "Add Remark"
            navigationItem.rightBarButtonItem?.title = "Add"
        }
    }
    
    func isValidToProceed() -> Bool {
        
        guard let title = titleTextField.text,
              let description = descriptionTextField.text,
              !title.isEmpty,
              !description.isEmpty else {
            
                let alertController = UIAlertController(title: "Oops !!", message: "All fields must be filled", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }
                
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        return true
    }
    
    func fillTextFields() {
        
        guard let annotation = selectedAnnotation else { return }
        
        titleTextField.text = annotation.title
        descriptionTextField.text = annotation.remark?.detail
    }
}

