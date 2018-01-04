//
//  Marvell_API_Manager.swift
//  MarvellApp
//
//  Created by Salama on 1/4/18.
//  Copyright © 2018 Salama. All rights reserved.
//

import UIKit

//typealias ServiceResponse = (JSON, NSError?) -> Void

class Marvell_API_Manager: NSObject {
    static let sharedInstance = Marvell_API_Manager()
    
    //let baseURL = "http://api.randomuser.me/"
    
//
//    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
//        let request = NSMutableURLRequest(URL: NSURL(string: path)! as URL)
//
//        let session = NSURLSession.sharedSession()
//
//        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            let json:JSON = JSON(data: data)
//            onCompletion(json, error)
//        })
//        task.resume()
//    }
}
