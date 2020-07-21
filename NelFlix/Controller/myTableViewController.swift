//
//  myTableViewController.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 2/21/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit
import Firebase


class myTableViewController: UITableViewController {
    
    @IBOutlet weak var EditProfileBtn: UIBarButtonItem!
    
    var user : User?
    let db = Database.database()
    var Reviewdict = Dictionary<Int,Int>()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        DispatchQueue.global().async {
            self.getCurrentUser()
            downloadJSON {
                print("json download successful")
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
                self.tableView.reloadData()
                self.configureAllMovie()
            }
            
            downloadGenre {
            }
        }
        
        navigationItem.title = "Pop Movies"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results?.movies.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! movieCellController
        let movie = results?.movies[indexPath.row]
        let review_num = Reviewdict[(movie?.id)!]
        cell.reviewNumLabel.text = String(review_num ?? 0)
        cell.titleLabel.text = movie?.title
        cell.rImage.isHidden = !(movie?.adult ?? false)
        let original_rating = (movie?.vote_average)!
        cell.starReview.rating = original_rating/2
        // Configure the cell...
        let posterPath = (movie?.poster_path)!
        cell.posterImage.downloaded(from: "https://image.tmdb.org/t/p/w500/" + posterPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            results?.movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MainToDetail", sender: self)
    }
    

    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "MainToDetail"  {
        let Detailview = segue.destination as! DetailTableViewController
        let movieIndex = self.tableView.indexPathForSelectedRow
        guard let row_num = movieIndex?.row else { return  }
        let Selected_Movie = results?.movies[row_num]
        Detailview.movie = Selected_Movie
        Detailview.review_num = self.Reviewdict[(Selected_Movie?.id)!]!
    }
    }
    
    
    func getCurrentUser()
    {
        let id = Auth.auth().currentUser?.uid
        let ref = db.reference().child("users").child(id!)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject]
            {
                self.user = User(uid: id!, dic: dict)
                self.navigationItem.title = self.user?.username
                self.SetURLImage(with: (self.user!.imageURL)!)
            }
        }
    }
    
    
    
    
    func SetURLImage(with url: String)
      {
          let ImageRef = Storage.storage().reference(forURL: url)
            ImageRef.getData(maxSize: 1*1024*1024) { (data, error) in
              if let error = error
              {
                print(error.localizedDescription)
              }
              else
              {
                 let image = UIImage(data: data!)
                let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
                 //set image for button
                button.heightAnchor.constraint(equalToConstant: 32).isActive = true
                button.widthAnchor.constraint(equalToConstant: 32).isActive = true
                button.frame = CGRect(x: 0, y: 0, width: 31, height: 31)
                button.layer.cornerRadius = button.frame.width/2
                button.layer.masksToBounds = true
                button.setImage(image, for: .normal)
                button.contentMode = .scaleAspectFill
                button.addTarget(self, action: #selector(self.editProfileBtnPressed(_:)), for: .touchUpInside)
                 let barButton = UIBarButtonItem(customView: button)
                 self.navigationItem.leftBarButtonItem = barButton
                   print("Got the Data")
              }
          }
      }
    
    
    
    func configureAllMovie()
    {
        print("configuring all the movies")
        for  m in results!.movies
        {
            db.reference().child("movieReviews").observe(.value) { (snapshot) in
                if snapshot.hasChild("\(m.id!)")
                {
                    let dict = snapshot.childSnapshot(forPath:"\(m.id!)" ).value as? [String:Any]
                    self.Reviewdict[m.id!] = (dict!["review_num"] as! Int)
                    self.tableView.reloadData()
                }
                else
                    {
                        let value = ["review_num":0] as [String:Any]
                        //add movie
                self.db.reference().child("movieReviews").child("\(m.id!)").setValue(value) { (error, ref) in
                                if error != nil
                                {
                                    print(error!.localizedDescription)
                                }
                                else
                                {
                                    print("movie \(m.id!) Upload successful")
                                }
                    }
                    }
            }
        }
        
    }
    
    
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        do
        {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError
        {
            print("Error signing out: %@",signOutError)
        }
        
    }
    
    
    @objc func editProfileBtnPressed(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainToEdit", sender: self)
        }
    }
    
    
    
    
    
}
