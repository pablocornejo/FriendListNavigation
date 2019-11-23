//
//  NetworkManager.swift
//  FriendListNavigation
//
//  Created by Pablo Cornejo on 11/23/19.
//  Copyright © 2019 Pablo Cornejo. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    static func fetchUsers(url: String, completion: @escaping (Result<[User], Swift.Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(Error.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(Error.unexpectedResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(Error.missingData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let users = try decoder.decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    enum Error: Swift.Error {
        case invalidUrl
        case unexpectedResponse
        case missingData
    }
}
