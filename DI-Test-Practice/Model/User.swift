//
//  User.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/10.
//

import SwiftUI

struct User: Identifiable, Decodable {

    var id: Int
    var login: String
    var avatar_url: URL?
}
