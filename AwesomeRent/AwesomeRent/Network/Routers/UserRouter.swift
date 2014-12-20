//
//  UserRouter.swift
//  AwesomeRent
//
//  Created by Ethan Fang on 12/14/14.
//  Copyright (c) 2014 awesomerent. All rights reserved.


import UIKit
import Alamofire

enum UserRouter: URLRequestConvertible {
    static let baseURLString = "http://ec2-54-173-114-114.compute-1.amazonaws.com:8080"
    static let clientId = "e7568b2c-2c0f-480e-9e34-08f9a4b807dc"
    static var OAuthToken: String?
    
    case CreateUser([String: AnyObject])
    case ReadUser(String)
    case UpdateUser(String, [String: AnyObject])
    case DestroyUser(String)
    
    
    case SignupUser([String: AnyObject])
    case LoginUser(String, String)
    
    var method: Alamofire.Method {
        switch self {
        case .SignupUser:
            return .POST
        case .LoginUser:
            return .POST
            
        case .CreateUser:
            return .POST
        case .ReadUser:
            return .GET
        case .UpdateUser:
            return .PUT
        case .DestroyUser:
            return .DELETE
        default:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .SignupUser:
            return "/user/signup"
        case .LoginUser:
            return "/user/signin"
            
        case .CreateUser:
            return "/users"
        case .ReadUser(let username):
            return "/users/\(username)"
        case .UpdateUser(let username, _):
            return "/users/\(username)"
        case .DestroyUser(let username):
            return "/users/\(username)"
        default:
            return ""
        }
    }
    
    //     MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: UserRouter.baseURLString)!
        var fullPath = URL.URLByAppendingPathComponent(path)
        
        if let URLComponents = NSURLComponents(URL: fullPath, resolvingAgainstBaseURL: false) {
            URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery != nil ? URLComponents.percentEncodedQuery! + "&" : "") + "clientId=\(UserRouter.clientId)"
            fullPath = URLComponents.URL!
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: fullPath)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .SignupUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .LoginUser(let username, let password):
            let parameters = ["username": username, "password": password]
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            
        case .CreateUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UpdateUser(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}