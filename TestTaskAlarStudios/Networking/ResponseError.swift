//
//  DataResponseError.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case login
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .login:
            return "Invalid pair Username/Password. Please, try again"
        case .network:
            return "An error occurred while fetching data. Please, check network connection"
        case .decoding:
            return "An error occurred while decoding data. Please, check data"
        }
    }
}
