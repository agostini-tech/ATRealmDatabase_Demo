//
//  ViewController.swift
//  ATRealmDatabase_Demo
//
//  Created by Dejan on 11/03/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let moviesController = MoviesController()
    
    var realm: Realm?
    var token: NotificationToken?
    var movies: Results<Movie>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Realm.AT_remoteRealm { (remoteRealm, error) in
            
            self.realm = remoteRealm
            
            self.movies = self.realm?.objects(Movie.self).sorted(byKeyPath: "year", ascending: false)
            
            self.token = self.movies?.observe({ (changes) in
                switch changes {
                case .initial(_):
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView?.beginUpdates()
                    self.tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                    self.tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                    self.tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                    self.tableView?.endUpdates()
                case .error(let error):
                    print("There has been an error: \(error)")
                }
            })
        }
        
        // Simulate dynamic updates
        DispatchQueue.global().async {
            self.moviesController.startGenerating()
        }
    }
    
    deinit {
        token?.invalidate()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")
        
        let movie = movies?[indexPath.row]
        
        cell?.textLabel?.text = movie?.title
        cell?.detailTextLabel?.text = "Year: \(movie?.year)"
        
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = movies?[indexPath.row] {
            moviesController.processInBackground(movie)
        }
    }
}
