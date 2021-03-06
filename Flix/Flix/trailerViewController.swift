//
//  trailerViewController.swift
//  Flix
//
//  Created by Suraj Kumar on 02/08/2022.
//  Copyright © 2022 Suraj Kumar. All rights reserved.
//

import UIKit
import WebKit

class trailerViewController: UIViewController {

    @IBOutlet weak var trailerWebView: WKWebView!
    var key: Any!
    var videos = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(key.unsafelyUnwrapped)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.videos = dataDictionary["results"] as! [[String:Any]] // casting as an array of dictionaries
                let videoKey = self.videos[0]["key"] ?? ""
                let urlForVideo = "https://www.youtube.com/watch?v=\(videoKey)"
                let youtubeUrl = URL(string: urlForVideo)
                if let videoError = youtubeUrl {
                    let request = URLRequest(url: youtubeUrl!)
                    let session = URLSession.shared
                    
                    let youtubeTask = session.dataTask(with: request) { (data,response,error) in
                        DispatchQueue.main.async {
                            self.trailerWebView.load(request)
                        }
                    }
                    youtubeTask.resume()
                }
            }
        }
        task.resume()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
