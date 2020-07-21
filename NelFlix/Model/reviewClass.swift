//
//  File.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/19/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import Foundation


class review
{
    var id : String = "unknown"
    var username : String = "unknown"
    var likes : Int = 0
    var dislike : Int = 0
    var body : String = "N/A"
    init(id : String , username : String , body: String) {
        self.id = id
        self.username = username
        self.body = body
        self.likes = 0
        self.dislike = 0
    }
    
    init(dict:Dictionary<String , Any>)
    {
        if let id = dict["id"] as? String
        {
            self.id = id
        }
        if let username = dict["username"] as? String
        {
            self.username = username
        }
        if let body = dict["body"] as? String
        {
            self.body = body
        }
        if let likes = dict["likes"] as? Int
        {
            self.likes = likes
        }
        if let dislikes = dict["dislikes"] as? Int
        {
            self.dislike = dislikes
        }
        
        
        
        
        
        
    }
    
    
}
