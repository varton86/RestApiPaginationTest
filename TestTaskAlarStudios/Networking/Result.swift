//
//  Result.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
