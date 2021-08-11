//
//  SearchUserSpec.swift
//  DI-Test-PracticeTests
//
//  Created by 육찬심 on 2021/08/11.
//

import Quick
import Nimble
import Combine
import Swinject

class SearchUserSpec: QuickSpec {
    
    struct StubNetwork: Networking {
        fileprivate static let json =
        """
        {
            "items": [
                {
                    "id": 1,
                    "login": "test1"
                },
                {
                    "id": 2,
                    "login": "test2"
                },
                {
                    "id": 3,
                    "login": "test3"
                }
            ]
        }
        """
        
        func request(_ request: URLRequest) -> AnyPublisher<Data, Error> {
            let data = StubNetwork.json.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            return Just(data).tryMap { $0 }.eraseToAnyPublisher()
        }
    }
    
    override func spec() {
        var cancellables: Set<AnyCancellable> = []
        var container: Container!
        beforeEach {
            container = Container()
            
            container.register(Networking.self) { _ in HTTPNetwork() }
            container.register(GitFetchable.self) { r in
                GitFetcher(networking: r.resolve(Networking.self)!)
            }
            
            container.register(Networking.self, name: "stub") { _ in StubNetwork() }
            container.register(GitFetchable.self, name: "stub") { r in
                GitFetcher(networking: r.resolve(Networking.self, name: "stub")!)
            }
        }
        
        it("returns users.") {
            var users: [User] = []
            let fetcher = container.resolve(GitFetchable.self)!
            fetcher.searchUsers(query: "ioscs").sink { users = $0 }.store(in: &cancellables)
            
            expect(users).toEventuallyNot(beEmpty())
            expect(users.count).toEventually(beGreaterThan(0))
        }
        
        it("fills user data.") {
            var users: [User] = []
            let fetcher = container.resolve(GitFetchable.self, name: "stub")!
            fetcher.searchUsers(query: "").sink { users = $0 }.store(in: &cancellables)
            
            expect(users).toEventuallyNot(beEmpty())
            expect(users.first?.id).toEventually(equal(1))
            expect(users.first?.login).toEventually(equal("test1"))
        }
    }
}
