//
//  MovieClass.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 2/21/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit

import Foundation



var gendict: Dictionary<Int,String> = [:]
func downloadGenre(completed: @escaping () -> () ) {
    

var idd = 0
var namme = ""
let url = URL(string:
"https://api.themoviedb.org/3/genre/movie/list?api_key=ef31a533ccbb0357ca2ef75793339a6e&language=en-US")
URLSession.shared.dataTask(with: url!){ (data, response, err) in
if err == nil {
guard let jsondata = data else { return }
    do {
    let json = try JSONSerialization.jsonObject(with: jsondata,
   options: .mutableContainers)
        guard let jsonarray = json as? [String:Any] else {return}
        if let objinside = jsonarray["genres"] as? [Dictionary<String, Any>] {
            for each in objinside{

                if let iden = each["id"] as? Int{
                    idd = iden
                    if let names = each["name"] as? String{
                        namme = names
                        gendict[idd] = namme
                    }
                }
            }

        }

    } catch {
   print("JSON Parsing Error!")
   }
    print(gendict)

}
}.resume()
}



struct CastInfo: Decodable {
let cast_id: Int?
let character: String?
let name: String?
let profile_path: String?

}



struct CastResults: Decodable {
let movieid: Int?
var casts: [CastInfo]

private enum CodingKeys: String, CodingKey {
case movieid = "id",
     casts = "cast"
 
}
}










struct MovieInfo: Decodable {
let id: Int?
let poster_path: String?
let backdrop_path: String?
let title: String?
let genre_ids : Set<Int>?
let vote_average : Double?
let vote_count : Int?
let adult : Bool?
let release_date : String?
let overview: String?
var review_num : Int? = 0 
}


struct MovieResults: Decodable {
let page: Int?
let numResults: Int?
let numPages: Int?
var movies: [MovieInfo]
private enum CodingKeys: String, CodingKey {
case page, numResults = "total_results",
numPages = "total_pages", movies = "results"
}
}

var results : MovieResults?
func downloadJSON(completed: @escaping () -> () ) {
let url = URL(string:
"https://api.themoviedb.org/3/movie/popular?api_key=ef31a533ccbb0357ca2ef75793339a6e")
URLSession.shared.dataTask(with: url!){ (data, response, err) in
if err == nil {
// check downloaded JSON data
guard let jsondata = data else { return }
do {
    results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
    
DispatchQueue.main.async {
completed()
}

}catch {
print("JSON Downloading Error!")
}
}
}.resume()
}



