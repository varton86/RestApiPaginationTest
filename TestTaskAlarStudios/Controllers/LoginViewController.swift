//
//  ViewController.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertDisplayer {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBAction func tapLoginButton(_ sender: UIButton) {
        loginCheck(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    private var viewModel: LoginViewModel!
    private var behavior: ButtonEnablingBehavior!
    private var code = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        behavior = ButtonEnablingBehavior(textFields: [usernameTextField, passwordTextField]) { [unowned self] enable in
            if enable {
                self.loginButton.isEnabled = true
                self.loginButton.alpha = 1
            } else {
                self.loginButton.isEnabled = false
                self.loginButton.alpha = 0.5
            }
        }
        loginButton.setStyle()
        prepareGestureRecognizer()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowList" {
            let navController = segue.destination as! UINavigationController
            let listViewController = navController.viewControllers.first as! ListViewController
            listViewController.code = code
        }
    }
    
    private func loginCheck(username: String, password: String) {
        view.isUserInteractionEnabled = false
        indicatorView.startAnimating()

        let request = LoginRequest.with(username, password)
        viewModel = LoginViewModel(request: request, delegate: self)
        viewModel.requestLogin()
    }
    
    private func prepareGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func hideKeyboard() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }

}

extension LoginViewController: LoginViewModelDelegate {
    func onLoginCompleted(with code: String) {
        view.isUserInteractionEnabled = true
        indicatorView.stopAnimating()
        
        self.code = code
        performSegue(withIdentifier: "ShowList", sender: self)
    }
    
    func onLoginFailed(with reason: String) {
        view.isUserInteractionEnabled = true
        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}
