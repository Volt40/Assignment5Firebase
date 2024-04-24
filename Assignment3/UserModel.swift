//
//  UserModel.swift
//  Assignment3
//
//  Created by Michael Baljet on 4/24/24.
//

import Foundation
import FirebaseFirestoreSwift

struct UserModel : Codable, Identifiable {
    @DocumentID var id: String?
    var user: String
    var pass: String
    
}
