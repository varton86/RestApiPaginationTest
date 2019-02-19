//
//  AlarStudiosData.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

final class AlarStudiosClient {
    private lazy var baseURL: URL = {
        return URL(string: "https://alarstudios.com/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(with request: DataRequest, page: Int, completion: @escaping (Result<PagedDataResponse, ResponseError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        let encodedURLRequest = urlRequest.encode(with: request.parameters.merging(["p": "\(page)"], uniquingKeysWith: +))

        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode, let data = data else {
                completion(Result.failure(ResponseError.network))
                return
            }
            guard let decodedResponse = try? JSONDecoder().decode(PagedDataResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
}
