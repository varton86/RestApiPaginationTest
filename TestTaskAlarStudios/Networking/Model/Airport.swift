//
//  ResultData.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 29.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

struct Airport: Decodable {
    let name: String
    let country: String
    let id: String
    let lat: Double
    let lon: Double
    let imageURL = String(format: "https://www.gstatic.com/webp/gallery/%@", String(Int(arc4random_uniform(4)) + 1) + ".jpg")
}
