//
//  SearchUserView.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/10.
//

import SwiftUI
import Combine

struct SearchUserView: View {
    
    @StateObject var viewModel: SearchUserViewModel
    
    var body: some View {
        NavigationView {
            List {
                TextField("이름을 입력하세요.", text: $viewModel.query)
                
                ForEach(viewModel.users) { user in
                    Text(user.login)
                }
            }
        }
    }
}

class SearchUserViewModel: ObservableObject {
    
    @Published var query = ""
    @Published var users: [User] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gitFetcher: GitFetchable) {
        $query
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap { query in
                gitFetcher.searchUsers(query: query)
            }
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
}

struct SearchUserView_Previews: PreviewProvider {

    static var previews: some View {
        SearchUserView(viewModel: SearchUserViewModel(gitFetcher: GitFetcher(networking: HTTPNetwork())))
    }
}
