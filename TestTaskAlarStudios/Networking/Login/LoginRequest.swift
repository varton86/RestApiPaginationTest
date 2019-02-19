//
//  LoginRequest.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

struct LoginRequest {
    var path: String {
        return "test/auth.cgi"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension LoginRequest {
    static func with(_ username: String, _ password: String) -> LoginRequest {
        let parameters = ["username": "\(username)", "password": "\(password)"]
        return LoginRequest(parameters: parameters)
    }
}
