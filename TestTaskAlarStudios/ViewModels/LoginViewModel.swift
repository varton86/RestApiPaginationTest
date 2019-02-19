//
//  LoginViewModel.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: class {
    func onLoginCompleted(with code: String)
    func onLoginFailed(with reason: String)
}

final class LoginViewModel {
    private weak var delegate: LoginViewModelDelegate?
    
    private var isLoginInProgress = false
    
    let login = AlarStudiosLogin()
    let request: LoginRequest
    
    init(request: LoginRequest, delegate: LoginViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    func requestLogin() {
        guard !isLoginInProgress else {
            return
        }

        isLoginInProgress = true
        
        login.requestLogin(with: request) { [unowned self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoginInProgress = false
                    self.delegate?.onLoginFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoginInProgress = false
                    self.delegate?.onLoginCompleted(with: response.code)
                }
            }
        }
    }
    
}
