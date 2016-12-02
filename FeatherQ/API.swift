//
//  API.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/17/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

enum Router: URLRequestConvertible {
    static let baseURL = "http://four.featherq.com"
//    static let baseURL = "http://new-featherq.local"
    //static let clientId = "fqiosapp" //use in OAuth
    //static let clientSecret = "fqiosapp" //use in OAuth
    
    case postSearchBusiness(latitude: String, longitude: String, key: String, category: String)
    case postDisplayBusinesses
    case getCategories
    case postRegister(email: String, password: String, name: String, address: String, logo: String, category: String, time_close: String, number_start: String, number_limit: String, deviceToken: String)
    case postLogin(email: String, password: String, deviceToken: String)
    case postEmailVerification(email: String)
    case getBusiness(business_id: Int)
    case putBusiness(business_id: Int, name: String, address: String, category: String, time_close: String, number_start: String, number_limit: String)
    
    var method: HTTPMethod {
        switch self {
        case .postSearchBusiness:
            return .post
        case .postDisplayBusinesses:
            return .post
        case .postRegister:
            return .post
        case .postLogin:
            return .post
        case .postEmailVerification:
            return .post
        case .putBusiness:
            return .put
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "/api/categories"
        case .postRegister:
            return "/api/register"
        case .postLogin:
            return "/api/login"
        case .postEmailVerification:
            return "/api/email-verification"
        case .getBusiness(let business_id):
            let businessId = "\(business_id)"
            return "/api/business/" + businessId
        case .putBusiness:
            return "/api/business"
        default:
            return "/api/search-business"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self{
        case .postLogin:
            break
        case .postRegister:
            break
        default:
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "fqiosappfree")
            if dictionary != nil {
                let token = dictionary!["access_token"] as! String
                debugPrint(token)
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            break
        }
        
        switch self {
        case .postSearchBusiness(let latitude, let longitude, let key, let category):
            let parameters = [
                "latitude": latitude,
                "longitude": longitude,
                "key": key,
                "category": category
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postRegister(let email, let password, let name, let address, let logo, let category, let time_close, let number_start, let number_limit, let deviceToken):
            let parameters = [
                "email": email,
                "password": password,
                "password_confirm": password,
                "name": name,
                "address": address,
                "logo": logo,
                "category": category,
                "time_close": time_close,
                "number_start": number_start,
                "number_limit": number_limit,
                "device_token": deviceToken,
                "platform": "iOS"
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postLogin(let email, let password, let deviceToken):
            let parameters = [
                "email": email,
                "password": password,
                "device_token": deviceToken,
                "platform": "iOS"
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postEmailVerification(let email):
            let parameters = [
                "email": email
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .putBusiness(let business_id, let name, let address, let category, let time_close, let number_start, let number_limit):
            let parameters = [
                "business_id": "\(business_id)",
                "name": name,
                "address": address,
                "category": category,
                "time_close": time_close,
                "number_start": number_start,
                "number_limit": number_limit
//                "logo": ""
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        debugPrint(urlRequest.debugDescription)
        
        return urlRequest
    }
    
//    var URLRequest: NSMutableURLRequest {
//        let URL = NSURL(string: Router.baseURL)!
//        let mutableURLRequest = NSMutableURLRequest(url: URL.appendingPathComponent(path)!)
//        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        mutableURLRequest.HTTPMethod = method.rawValue
//        
//        debugPrint(mutableURLRequest.URLString)
//        
//        switch self{
//        case .postRegisterUser:
//            break
//        case .postFacebookLogin:
//            break
//        default:
//            let dictionary = Locksmith.loadDataForUserAccount("fqiosapp")
//            if dictionary != nil {
//                let token = dictionary!["access_token"] as! String
//                debugPrint(token)
//                mutableURLRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
//            }
//            break
//        }
//        
//        switch self {
//        case .postSendtoBusiness(let facebookId, let businessId, let message, let phone):
//            let params = [
//                "facebook_id": facebookId,
//                "business_id": businessId,
//                "message": message,
//                "phone": phone
//            ]
//            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
//        case .postRegisterUser(let fb_id, let first_name, let last_name, let email, let gender, let deviceToken):
//            let params = [
//                "fb_id": fb_id,
//                "first_name": first_name,
//                "last_name": last_name,
//                "email": email,
//                "gender": gender,
//                "phone": "",
//                "country": "",
//                "device_token": deviceToken,
//                "device_type": "iOS"
//            ]
//            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
//        case .postFacebookLogin(let fb_id, let fb_token):
//            let params = [
//                "facebook_id": fb_id,
//                "fb_token": fb_token
//            ]
//            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
//        case .postSendMessage(let user_id, let business_id, let message):
//            let params = [
//                "user_id": user_id,
//                "business_id": business_id,
//                "message": message
//            ]
//            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
//        case .postSubmitForm(let userId, let transactionNumber, let formSubmissions, let serviceId, let serviceName):
//            let params = [
//                "user_id": userId,
//                "transaction_number": transactionNumber,
//                "form_submissions": formSubmissions,
//                "service_id": serviceId,
//                "service_name": serviceName
//            ]
//            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params as? [String : AnyObject]).0
//        default:
//            return mutableURLRequest
//        }
//    }
}
