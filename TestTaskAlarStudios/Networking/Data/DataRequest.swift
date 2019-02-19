//
//  DataRequest.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

struct DataRequest {
    var path: String {
        return "test/data.cgi"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension DataRequest {
    static func with(_ code: String) -> DataRequest {
        let parameters = ["code": "\(code)"]
        return DataRequest(parameters: parameters)
    }
}
