//
//  Movie.swift
//  ATRealmDatabase_Demo
//
//  Created by Dejan on 11/03/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: Object {
    @objc dynamic var title = ""
    @objc dynamic var year = 1900
    let cast = List<Actor>()
}
