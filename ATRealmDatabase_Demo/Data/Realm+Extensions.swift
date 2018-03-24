//
//  Constants.swift
//  ATRealmDatabase_Demo
//
//  Created by Dejan on 24/03/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import Foundation
import RealmSwift

fileprivate struct Constants {
    fileprivate static let authServer = URL(string: "https://agostinitech-realm-demo.us1a.cloud.realm.io")!
    fileprivate static let realmServer = URL(string: "realms://agostinitech-realm-demo.us1a.cloud.realm.io/sharedData")!
    fileprivate static let syncCredentials = SyncCredentials.usernamePassword(username: "atechdemo", password: "demo1234")
}

extension Realm {
    static func AT_remoteRealm(callback: @escaping (Realm?, Swift.Error?) -> Void) {
        SyncUser.logIn(with: Constants.syncCredentials, server: Constants.authServer) { (remoteUser, error) in
            if let user = remoteUser {
                Realm.Configuration.defaultConfiguration.syncConfiguration =  SyncConfiguration(user: user, realmURL: Constants.realmServer)
                Realm.asyncOpen(callback: callback)
            } else {
                callback(nil, error)
            }
        }
    }
}
