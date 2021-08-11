//
//  Network.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/11.
//

import Foundation
import Combine

protocol Networking {
    
    func request(_ request: URLRequest) -> AnyPublisher<Data, URLSession.DataTaskPublisher.Failure>
}

struct HTTPNetworking: Networking {
    
    func request(_ request: URLRequest) -> AnyPublisher<Data, URLSession.DataTaskPublisher.Failure> {
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
