//
//  LoginViewController.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 27/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets & Vars
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    
    private var viewModel: LoginViewModel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        viewModel = LoginViewModel()
        
        setLoginButtonUserInteraction(enabled: false)
        usernameTextField.addTarget(self, action: Selector(("textFieldDidChange:")), for: UIControl.Event.editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = SyncUser.current {
            // already logged in
            performUnlockAnimation()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        viewModel.login(username: usernameTextField.text) { [weak self] (loginState) in
            
            guard let strongSelf = self else { return }
            
            switch loginState {
            case .alreadyloggedIn:
                strongSelf.performUnlockAnimation()
            case .error: break
                //show error
            case .newUser:
                Router().perform(.map, from: strongSelf)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setLoginButtonUserInteraction(enabled: !textField.text!.isEmpty)
    }
}

private extension LoginViewController {
    
    func setLoginButtonUserInteraction(enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.setImage(UIImage(named: enabled ? "loginButton_unlocked" : "loginButton_locked"), for: .normal)
    }
    
    func performUnlockAnimation(shouldRoute: Bool = true) {
        
        UIView.animate(withDuration: 3.0,
                       animations: { [weak self] in
                        
                        guard let strongSelf = self else { return }
                        
                        strongSelf.setLoginButtonUserInteraction(enabled: true)
            },
                       completion: shouldRoute ? { [weak self] _ in
                        guard let strongSelf = self else { return }
                        Router().perform(.map, from: strongSelf)
                        } : nil)
    }
}
