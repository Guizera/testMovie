//
//  DetailViewController.swift
//  testMovie
//
//  Created by José Guilherme Alves da Cunha on 05/03/2018.
//  Copyright © 2018 José Guilherme Alves da Cunha. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class DetailViewController: UIViewController {
    
    //https://api.themoviedb.org/3/movie/284054?api_key=1f54bd990f1cdfb230adb312546d765d
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel:UILabel!
    @IBOutlet weak var releaseData:UILabel!
    @IBOutlet weak var overviewScroll:UIScrollView!
    @IBOutlet weak var overviewLabel:UILabel!
    
     var movie: NSDictionary!
    //var genreN: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(movie)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        overviewScroll.contentSize = CGSize(width: overviewScroll.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
//        if (movie["genre_ids"] as? NSDictionary) != nil {
//            let genres = movie["name"] as? String
//            genreLabel.text = genres
//        }
        
        let genres = movie["genre_ids"] as? NSArray
        genreLabel.text = genres?.description
        
        //print(genres)
        
        let date = movie["release_date"] as? String
        releaseData.text = date
        
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            posterImageView.setImageWith(imageUrl!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
