//
//  ViewController.swift
//  testMovie
//
//  Created by José Guilherme Alves da Cunha on 05/03/2018.
//  Copyright © 2018 José Guilherme Alves da Cunha. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dataErrorView: UITableView!
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint =  "now_playing"
   
    
    func loadRequest(endpoint: String) -> URLSessionTask {
        let apiKey = "1f54bd990f1cdfb230adb312546d765d"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.dataErrorView.isHidden = true
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                }
            }
            else {
                self.dataErrorView.isHidden = false
                MBProgressHUD.showAdded(to: self.dataErrorView, animated: true)
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)
        return task
    }
    
    func getPosterURL(id: Int) -> NSURL? {
        let movie = self.filteredMovies![id] as NSDictionary
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseURL = "https://image.tmdb.org/t/p/w500/"
            let posterURL = NSURL(string: posterBaseURL + posterPath)
            return posterURL
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.dataErrorView.isHidden = true
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Movie Titles..."
        //[NSColor colorWithCalibratedRed:0.000 green:0.000 blue:0.000 alpha:1.00]
        //change the background color of tableView
        self.tableView.backgroundColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.50)
        //change color of separator tableView
        self.tableView.separatorColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.30)
        
        let task = loadRequest(endpoint: (endpoint))
        task.resume()
        
        
    }
    
    
    @objc func refreshControlAction (refreshControl: UIRefreshControl) {
        let task = loadRequest(endpoint: endpoint)
        refreshControl.endRefreshing()
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as? String ?? "Error fetching title"
        let overview = movie["overview"] as? String ?? "Error fetching overview"
        if let posterURL = getPosterURL(id: (indexPath.row)) {
            cell.posterImageView.setImageWith(posterURL as URL)
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.selectionStyle = .none
        return cell
    }
    
    func extractKeywords(title: String) -> [String] {
        var keywords = [String]()
        keywords = title.lowercased().components(separatedBy: " ")
        let doNotMatch = ["a":1, "an":1, "and":1, "at":1, "by":1, "for":1, "if":1, "in":1, "it":1, "of":1, "on":1, "or":1, "the":1, "with":1]
       //The keyWords use to search Movies
        if keywords.count > 3 {
            for _ in keywords[1..<keywords.count] {
                for (index, word) in keywords[1..<keywords.count].enumerated() {
                    if (doNotMatch[word] != nil) && (index + 1 < keywords.count) {
                        keywords.remove(at: index + 1)
                        //print(keywords)
                        break
                    }
                }
            }
        }
        return keywords
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = searchText.isEmpty ? movies : movies!.filter({ (movie) -> Bool in
                let titleKeywords = extractKeywords(title: movie["title"] as! String)
                for word in titleKeywords {
                    if word.hasPrefix(searchText.lowercased()) {
                        return true
                    }
                }
                return false
            })
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //get segue to DetailViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = filteredMovies![(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        detailViewController.hidesBottomBarWhenPushed = true
    }


}

