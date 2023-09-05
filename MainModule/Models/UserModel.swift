//
//  UserModel.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 24.04.2023.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @Persisted var userFirstName: String = "Unknown"
    @Persisted var userSecondName: String = "Unknown"
    @Persisted var userHeight: Int = 0
    @Persisted var userWeight: Int = 0
    @Persisted var userTarget: Int = 0
    @Persisted var userImage: Data?
}
