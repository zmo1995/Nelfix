//
//  UserClass.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/18/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import Foundation


class User
{
    var gender : String!
    var uid : String!
    var username : String!
    var age : Int!
    var imageURL : String!
    
    
    init(uid : String , dic : Dictionary<String,AnyObject>) {
        self.uid = uid
        if let gender = dic["gender"] as? String
        {
            self.gender  = gender
        }
        if let username = dic["username"] as? String
        {
            self.username   = username
        }
        if let age = dic["age"] as? Int
        {
            self.age = age
        }
        if let url = dic["url"] as? String
        {
            self.imageURL = url 
        }
    }
    init( gender:String , username:String , age : Int , url : String ,uid:String ) {
        self.uid = uid
        self.gender = gender
        self.username = username
        self.age = age
        self.imageURL = url
    }
    
    
    
}

