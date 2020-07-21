//
//  DetailTableViewController.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/19/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DetailTableViewController: UITableViewController,ReviewCellDelegate {
    
    @objc func likeBtnPressedHandler(_ cell: ReviewCell) {
        print(review_list[cell.tag].id)
        LikeOrDislike(id: review_list[cell.tag].id, like: true)
        review_list[cell.tag].likes += 1
        tableView.reloadData()
        print("Like Btn Pressed")
    }
    
    @objc func dislikeBtnPressedHandler(_ cell: ReviewCell) {
        //print("\(cell.usernameLabel.text)'s Review disliked")
        print(review_list[cell.tag].id)
        LikeOrDislike(id: review_list[cell.tag].id, like: false)
        review_list[cell.tag].dislike += 1
        tableView.reloadData()
        print("Dislike Btn Pressed")
    }
    
    
    
    @IBOutlet weak var EditBtn: UIBarButtonItem!
    var user : User?
    let addImage = UIImage(systemName: "plus")
    let editImage = UIImage(systemName: "pensil")
    let db = Database.database()
    let headerID = "headerCell"
    let cellID = "ReviewCell"
    var review_list = [review]()
    var movieID : Int?
    var movie : MovieInfo?
   {
        didSet
        {
            self.header_done = 1
            self.movieID = (movie?.id)!

        }
    }
    var review_num = 0
    var header_done = 0
    var has_review = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        print("before register")
        tableView.register(UINib(nibName: headerID, bundle: nil), forCellReuseIdentifier: headerID)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        fetchReviews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return header_done
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return review_list.count
    }

    //MARK: - Cell setup
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        cell.delegate = self
        cell.setup(with: review_list[indexPath.row])
        cell.likeBtn.tag = indexPath.row
        cell.dislikeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnPressedHandler(_:)), for: .touchUpInside)
        cell.dislikeBtn.addTarget(self, action: #selector(dislikeBtnPressedHandler(_:)), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    // MARK: - Header setup
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("creating header")
        let header = tableView.dequeueReusableCell(withIdentifier: headerID) as! headerCell
        header.thisMovie = self.movie
        header.setup(review_num: review_num)
        header_done = 1
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    
    //MARK: - API Methods
    
    func fetchReviews()
    {
        print("In fetch Reviews")
        self.review_list.removeAll()
        db.reference().child("movieReviews").child(String((movie?.id)!))
            .observe(.childAdded, with: { (snapshot) in
                if let dict = snapshot.value as? [String:Any]
                {
                    let temp = review(dict: dict)
                    if temp.id == Auth.auth().currentUser?.uid
                    {
                        self.EditBtn.image = self.editImage
                        self.EditBtn.title = "edit"
                        // current user has review on this movie
                        // change bar btn item image to edit , add alert view for user to edit
                    }
                    
                    
                    self.review_list.append(temp)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }, withCancel: nil)
        
        
        
    }
    
    func getCurrentUser()
    {
        let id = Auth.auth().currentUser?.uid
        let ref = db.reference().child("users").child(id!)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject]
            {
                self.user = User(uid: id!, dic: dict)
            }
        }
    }
    
    
    
    
    
    func uploadReview(with Review: review)
    {
        let ref = db.reference().child("movieReviews").child("\(movieID!)").child("\(Review.id)")
        let dict = ["username":Review.username , "id":Review.id , "likes":Review.likes , "dislikes":Review.dislike , "body":Review.body] as [String : Any]
        ref.setValue(dict)
        { (error, dataref) in
            if error != nil
            {
                print("Error : Failed to Publish Review")
            }
            else
            {
                print("Review Published")
                //self.review_list.append(Review)
                print("currently have \(self.review_list.count) reviews")
                self.updateReviewNum(add: true)
                DispatchQueue.main.async
                    {
                    self.tableView.reloadData()
                    }
            }
        }
        
    }
    
    
    
    
    
    //******************************************************************************************************************************
    func LikeOrDislike(id:String,like:Bool)
    {
        let review_ref = db.reference().child("movieReviews").child("\(movieID!)").child("\(id)")
        review_ref.runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            if var review = currentData.value as? [String: AnyObject]
            {
             
               var likeNum = review["likes"] as? Int ?? 0
               var dislikeNum = review["dislikes"] as? Int ?? 0

                if like == true
                {
                    likeNum += 1
                }
                else
                {
                    dislikeNum += 1
                    
                }
               review["likes"] = likeNum as AnyObject?
                review["dislikes"] = dislikeNum as AnyObject?
                
                currentData.value = review
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, committed, snapshot) in
            if error != nil
            {
                print(error!.localizedDescription)
            }
        })
    }
    //******************************************************************************************************************************

    
    
    
    func updateReviewNum(add:Bool)
    {
        let review_num_ref = db.reference().child("movieReviews").child("\(movieID!)")
        review_num_ref.runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            if var movie = currentData.value as? [String: AnyObject] , let uid = self.user?.uid
            {
             
               var reviewNum = movie["review_num"] as? Int ?? 0
                if add == false
                {
                    reviewNum -= 1
                    movie.removeValue(forKey: uid)
                }
                else
                {
                    reviewNum += 1
                    
                }
                movie["review_num"] = reviewNum as AnyObject?
                
                currentData.value = movie
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, committed, snapshot) in
            if error != nil
            {
                print(error!.localizedDescription)
            }
        })
    }
    
    
    
    
    func removeMyReview()
    {
        var index = 0
        for Myreview in review_list
        {
            if Myreview.id == Auth.auth().currentUser?.uid
            {
                review_list.remove(at: index)
            }
            index += 1
        }
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    @IBAction func EditBtnPressed(_ sender: UIBarButtonItem) {
        if EditBtn.title == "add"
        {
            var textfield = UITextField()
            let alert = UIAlertController(title: "Write your review", message: "Length limit is 100 words", preferredStyle: .alert)
            let action = UIAlertAction(title: "Publish", style: .default) { (action) in
                if textfield.hasText
                {
                    let id = Auth.auth().currentUser?.uid
                    let body = textfield.text
                    let username = self.user?.username
                    let newReview = review(id: id!, username: username!, body: body!)
                    DispatchQueue.global().async {
                        self.uploadReview(with: newReview)
                    }
                    self.EditBtn.image = self.editImage
                    self.EditBtn.title = "edit"
                    
                }
            }
            
            
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Your review goes here"
                textfield = alertTextField
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: {
                alert.view.superview?.isUserInteractionEnabled = true;
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))

            })
            
        }
            
            
        else if EditBtn.title == "edit"
        {
            var textfield = UITextField()
            let alert = UIAlertController(title: "Edit your review", message: "Length limit is 100 words", preferredStyle: .alert)
            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                if textfield.hasText
                {
                    self.updateReviewNum(add: false)
                    self.removeMyReview()
                    let id = Auth.auth().currentUser?.uid
                    let body = textfield.text
                    let username = self.user?.username
                    let newReview = review(id: id!, username: username!, body: body!)
                    self.uploadReview(with: newReview)
                }
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                self.updateReviewNum(add: false)
                self.removeMyReview()
                self.EditBtn.image = self.addImage
                self.EditBtn.title = "add"
                
            }
            
            
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Your review goes here"
                textfield = alertTextField
            }
            alert.addAction(action)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: {
                alert.view.superview?.isUserInteractionEnabled = true;
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))

            })
            
            
            
            
            
            
            
        }
        
        
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

}
