//
//  Network.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/11.
//

import Foundation
import Combine

protocol Networking {
    
    func request(_ request: URLRequest) -> AnyPublisher<Data, Error>
}

struct HTTPNetwork: Networking {
    
    func request(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .eraseToAnyPublisher()
    }
}
