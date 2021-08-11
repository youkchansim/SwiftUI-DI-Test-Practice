//
//  GitAPI.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/10.
//

import Combine
import Foundation

protocol GitFetchable {
    
    func searchUsers(query: String) -> AnyPublisher<[User], Never>
}

struct GitFetcher: GitFetchable {
    
    private let baseURL = "https://api.github.com"
    
    let networking: Networking
    
    func searchUsers(query: String) -> AnyPublisher<[User], Never> {
        var urlComponents = URLComponents(string: "\(baseURL)/search/users")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return networking.request(request)
            .decode(type: SearchUserResult.self, decoder: JSONDecoder())
            .map { $0.items }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

struct SearchUserResult: Decodable {
    
    var items: [User]
}
