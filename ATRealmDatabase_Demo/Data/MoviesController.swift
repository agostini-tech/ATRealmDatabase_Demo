//
//  MoviesController.swift
//  ATRealmDatabase_Demo
//
//  Created by Dejan on 11/03/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import Foundation
import RealmSwift

class MoviesController
{
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    public func startGenerating() {
        timer = Timer(timeInterval: 2, repeats: true) { (timer) in
            Realm.AT_remoteRealm(callback: { (remoteRealm, error) in
                if let realm = remoteRealm {
                    try! realm.write {
                        let movie = self.getRandomMovie()
                        realm.add(movie)
                    }
                } else {
                    print("Error opening remote realm: \(error?.localizedDescription)")
                }
            })
        }
        
        if let aTimer = timer {
            RunLoop.main.add(aTimer, forMode: .commonModes)
        }
    }
    
    public func processInBackground(_ movie: Movie) {
        let movieRef = ThreadSafeReference(to: movie)
        DispatchQueue.global().async {
            Realm.AT_remoteRealm(callback: { (remoteRealm, error) in
                if let realm = remoteRealm {
                    if let movie = realm.resolve(movieRef) {
                        print("Processing movie with title: \(movie.title) in the background")
                    } else {
                        print("Movie cannot be resolved")
                    }
                } else {
                    print("Error opening remote realm: \(error?.localizedDescription)")
                }
            })
        }
    }
    
    public func crashInBackground(_ movie: Movie) {
        DispatchQueue.global().async {
            print("Crashing with a movie: \(movie.title)")
        }
    }
    
    private func getRandomActor() -> Actor {
        let actor = Actor()
        actor.name = "Actor \(arc4random_uniform(10000))"
        actor.dateOfBirth = Date(timeIntervalSince1970: Double(arc4random_uniform(1000000)))
        return actor
    }
    
    private func getRandomMovie() -> Movie {
        let movie = Movie()
        movie.title = "Movie \(arc4random_uniform(10000))"
        movie.year = Int(arc4random_uniform(2018))
        movie.cast.append(getRandomActor())
        movie.cast.append(getRandomActor())
        movie.cast.append(getRandomActor())
        return movie
    }
}
