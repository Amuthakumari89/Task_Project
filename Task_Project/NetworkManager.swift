//
//  NetworkManager.swift
//  Task_Project
//
//  Created  on 01/09/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {

    static let sharedInstance = NetworkManager()
    
    var dictionaryRequests:Dictionary<String,AnyObject> = [:]
    var userDefults = UserDefaults.standard
    var strTokenType:String?
    var strAccessToken:String?
    var strCommon:String?
    
    //MARK:- internet connection check
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK:- get api call method
    func requestGETData(urlString:String,str:String,parameterToBePassed:inout Dictionary<String,AnyObject>, completion:@escaping (_ resultDictionary:Dictionary<String,AnyObject>?, _ error:Error?) -> ()) {
        
        
     /*   let headers: HTTPHeaders = [
          //  "Authorization": strCommon!,
            "Content-Type": "application/x-www-form-urlencoded",
          //  "X-Requested-With": "XMLHttpRequest",
            ]*/
        print(parameterToBePassed)
        print(urlString)
//        MKProgress.show()
        
         if str == "verify" {
                    
                }else {
        //            GIFHUD.shared.setGif(named: "giphy.gif")
        //            GIFHUD.shared.show()
                }
//        GIFHUD.shared.setGif(named: "giphy.gif")
//        GIFHUD.shared.show(withOverlay: true, duration: 1)
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            print("response -- \(String.init(data: response.data!, encoding: .utf8)!)")
            switch response.result {
            case .success:
//              GIFHUD.shared.show(withOverlay: true, duration: 1)
                
//                print("JSON: \(String(describing: response.result))")
                
                if let JSON = response.result.value as? Dictionary<String,AnyObject>{
//                    print("JSON: \(JSON)")
                    completion(JSON, nil)
                }
                else {
                    completion(nil, response.result.error! as Error)
                }
            case .failure(let error):
//                print(error,"Error")
//             GIFHUD.shared.show(withOverlay: true, duration: 1)
                
                completion(nil, response.result.error! as Error)
            }
        }

    }
     //MARK:- post api call method
    func requestPOST(urlString:String,str:String,parameterToBePassed:inout Dictionary<String,AnyObject>, completion:@escaping (_ resultDictionary:Dictionary<String,AnyObject>?, _ error:Error?) -> ()) {
     
//        print("param -- \(parameterToBePassed)")
//        print("url -- \(kAccessToken)")

        if str == "verify" {
            
        }else {
//            GIFHUD.shared.setGif(named: "giphy.gif")
//            GIFHUD.shared.show()
        }
       // print(headers)   URLEncoding.httpBody
            let headers = [ "Content-Type": "application/json" ,
                            "lang": "da315627-3ece-2016-c628-b61dc5ee9be0" ,
                            "APPID": "Gem3s12345" ,
                            "Authorization": "Bearer \(String(describing: UserDefaults.standard.value(forKey: kAccessToken)!))"
                            ]
//        print(headers)
        let urlComponent = URLComponents(string: urlString)!

            var request = URLRequest(url: urlComponent.url!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameterToBePassed)
            request.allHTTPHeaderFields = headers
        
                Alamofire.request(request).responseJSON { response in
//                    print("response -- \(String.init(data: response.data!, encoding: .utf8)!)")
                    switch response.result {
                    case .success:
        //                MKProgress.hide()
        //             GIFHUD.shared.show(withOverlay: true, duration: 1)
                        
        //                print("JSON: \(String(describing: response.result))")
                        
                        if let JSON = response.result.value as? Dictionary<String,AnyObject>{
        //                    print("JSON: \(JSON)")
                            completion(JSON, nil)
                        }
                        else {
                            completion(nil, response.result.error! as Error)
                        }
                    case .failure(let error):
                        print(error,"Error")
        //              GIFHUD.shared.show(withOverlay: true, duration: 1)
                        
                        completion(nil, response.result.error! as Error)
                    }
                }

        }
    //MARK:- post api call method
    func requestPOSTData(urlString:String,str:String,parameterToBePassed:inout Dictionary<String,Any>, completion:@escaping (_ resultDictionary:Dictionary<String,AnyObject>?, _ error:Error?) -> ()) {
        
        let urlComponent = URLComponents(string: urlString)!
        let headers = [ "Content-Type": "application/json" ,
                        "lang": "da315627-3ece-2016-c628-b61dc5ee9be0" ,
                        "APPID": "Gem3s12345" ]
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameterToBePassed)
        request.allHTTPHeaderFields = headers
        
        Alamofire.request(request).responseJSON { response in
//            print("json: \(response)")
//            print("response -- \(String.init(data: response.data!, encoding: .utf8)!)")
            switch response.result {
            case .success:
//                MKProgress.hide()
//             GIFHUD.shared.show(withOverlay: true, duration: 1)
                
//                print("JSON: \(String(describing: response.result))")
                
                if let JSON = response.result.value as? Dictionary<String,AnyObject>{
//                    print("JSON: \(JSON)")
                    completion(JSON, nil)
                }
                else {
                    completion(nil, response.result.error! as Error)
                }
            case .failure(let error):
                print(error,"Error")
//              GIFHUD.shared.show(withOverlay: true, duration: 1)
                
                completion(nil, response.result.error! as Error)
            }
        }
    }

  
}
