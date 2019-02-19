//
//  AlarStudiosClient.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

final class AlarStudiosLogin {
    private lazy var baseURL: URL = {
        return URL(string: "https://alarstudios.com/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestLogin(with request: LoginRequest, completion: @escaping (Result<LoginResponse, ResponseError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        let encodedURLRequest = urlRequest.encode(with: request.parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode, let data = data else {
                    completion(Result.failure(ResponseError.network))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            guard decodedResponse.status == "ok" else {
                completion(Result.failure(ResponseError.login))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
}
