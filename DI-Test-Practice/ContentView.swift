//
//  ContentView.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/10.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.container) private var container
    
    var body: some View {
        SearchUserView(viewModel: SearchUserViewModel(gitFetcher: container.resolve(GitFetchable.self)!))
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
