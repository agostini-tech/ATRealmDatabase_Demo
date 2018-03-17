//
//  Actor.swift
//  ATRealmDatabase_Demo
//
//  Created by Dejan on 11/03/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import Foundation
import RealmSwift

class Actor: Object {
    @objc dynamic var name = ""
    @objc dynamic var dateOfBirth = Date()
}
