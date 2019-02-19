//
//  LoginResponse.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let status: String
    let code: String
}
