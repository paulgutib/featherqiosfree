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
    static let baseURL = "http://featherq.com"
//    static let baseURL = "http://new-featherq.local"
    //static let clientId = "fqiosapp" //use in OAuth
    //static let clientSecret = "fqiosapp" //use in OAuth
    
    case postSearchBusiness(latitude: String, longitude: String)
    case postDisplayBusinesses
    case getCategories
    case postRegister(email: String, password: String, name: String, address: String, logo: String, category: String, time_open: String, time_close: String, number_start: String, number_limit: String, deviceToken: String, longitudeVal: String, latitudeVal: String)
    case postLogin(email: String, password: String, deviceToken: String)
    case postEmailVerification(email: String)
    case getBusiness(business_id: String)
    case postUpdateBusiness(business_id: String, name: String, address: String, logo: String, category: String, time_open: String, time_close: String, number_start: String, number_limit: String, longitudeVal: String, latitudeVal: String)
    case postIssueNumber(service_id: String, priority_number: String, note: String)
    case getAllNumbers(business_id: String)
    case getCallNumber(transaction_number: String)
    case getCustomerBroadcast(business_id: String)
    case getBusinessBroadcast(business_id: String)
    case getServeNumber(transaction_number: String)
    case getDropNumber(transaction_number: String)
    case getEstimatedTime(business_id: String)
    case postResetPassword(email: String)
    case putChangePassword(email: String, password: String, password_confirm: String, verification_code: String)
    case putUpdatePassword(email: String, password: String, password_confirm: String)
    case getMeanWeights(service_id: String)
    case postUpdateMeanweights(meanToday: String, weightToday: String, meanYesterday: String, weightYesterday: String, meanThreeDays: String, weightThreeDays: String, meanThisWeek: String, weightThisWeek: String, meanLastWeek: String, weightLastWeek: String, meanThisMonth: String, weightThisMonth: String, meanLastMonth: String, weightLastMonth: String, meanMostLikely: String, weightMostLikely: String, meanMostOptimistic: String, weightMostOptimistic: String, meanMostPessimistic: String, weightMostPessimistic: String, serviceId: String)
    case postPunchQueuestatus(service_id: String, punch_type: String)
    
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
        case .postUpdateBusiness:
            return .post
        case .postIssueNumber:
            return .post
        case .postResetPassword:
            return .post
        case .putChangePassword:
            return .put
        case .putUpdatePassword:
            return .put
        case .postUpdateMeanweights:
            return .post
        case .postPunchQueuestatus:
            return .post
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
            return "/api/business/" + business_id
        case .postUpdateBusiness:
            return "/api/update-business"
        case .postIssueNumber:
            return "/api/issue-number"
        case .getAllNumbers(let business_id):
            return "/api/all-numbers/" + business_id
        case .getCallNumber(let transaction_number):
            return "/api/call-number/" + transaction_number
        case .getCustomerBroadcast(let business_id):
            return "/api/customer-broadcast/" + business_id
        case .getBusinessBroadcast(let business_id):
            return "/api/business-broadcast/" + business_id
        case .getServeNumber(let transaction_number):
            return "/api/serve-number/" + transaction_number
        case .getDropNumber(let transaction_number):
            return "/api/drop-number/" + transaction_number
        case .getEstimatedTime(let business_id):
            return "/api/estimated-time/" + business_id
        case .postResetPassword:
            return "/api/reset-password"
        case .putChangePassword:
            return "/api/change-password"
        case .putUpdatePassword:
            return "/api/update-password"
        case .getMeanWeights(let service_id):
            return "/api/mean-weights/" + service_id
        case .postUpdateMeanweights:
            return "/api/update-meanweights"
        case .postPunchQueuestatus:
            return "/api/punch-queuestatus"
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
        case .postResetPassword:
            break
        case .putChangePassword:
            break
        case .getCustomerBroadcast:
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
        case .postSearchBusiness(let latitude, let longitude):
            let parameters = [
                "latitude": latitude,
                "longitude": longitude,
                "key": "",
                "category": ""
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postRegister(let email, let password, let name, let address, let logo, let category, let time_open, let time_close, let number_start, let number_limit, let deviceToken, let longitudeVal, let latitudeVal):
            let parameters = [
                "email": email,
                "password": password,
                "password_confirm": password,
                "name": name,
                "address": address,
                "logo": logo,
                "category": category,
                "time_open": time_open,
                "time_close": time_close,
                "number_start": number_start,
                "number_limit": number_limit,
                "device_token": deviceToken,
                "longitude": longitudeVal,
                "latitude": latitudeVal,
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
        case .postUpdateBusiness(let business_id, let name, let address, let logo, let category, let time_open, let time_close, let number_start, let number_limit, let longitudeVal, let latitudeVal):
            let parameters = [
                "business_id": business_id,
                "name": name,
                "address": address,
                "category": category,
                "time_close": time_close,
                "time_open": time_open,
                "number_start": number_start,
                "number_limit": number_limit,
                "logo": logo,
                "longitude": longitudeVal,
                "latitude": latitudeVal
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postIssueNumber(let service_id, let priority_number, let note):
            let parameters = [
                "service_id": service_id,
                "priority_number": priority_number,
                "note": note
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postResetPassword(let email):
            let parameters = [
                "email": email
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .putChangePassword(let email, let password, let password_confirm, let verification_code):
            let parameters = [
                "email": email,
                "password": password,
                "password_confirm": password_confirm,
                "verification_code": verification_code
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .putUpdatePassword(let email, let password, let password_confirm):
            let parameters = [
                "email": email,
                "password": password,
                "password_confirm": password_confirm
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postUpdateMeanweights(let meanToday, let weightToday, let meanYesterday, let weightYesterday, let meanThreeDays, let weightThreeDays, let meanThisWeek, let weightThisWeek, let meanLastWeek, let weightLastWeek, let meanThisMonth, let weightThisMonth, let meanLastMonth, let weightLastMonth, let meanMostLikely, let weightMostLikely, let meanMostOptimistic, let weightMostOptimistic, let meanMostPessimistic, let weightMostPessimistic, let serviceId):
            let parameters = [
                "mean_today": meanToday,
                "weight_today": weightToday,
                "mean_yesterday": meanYesterday,
                "weight_yesterday": weightYesterday,
                "mean_three_days": meanThreeDays,
                "weight_three_days": weightThreeDays,
                "mean_this_week": meanThisWeek,
                "weight_this_week": weightThisWeek,
                "mean_last_week": meanLastWeek,
                "weight_last_week": weightLastWeek,
                "mean_this_month": meanThisMonth,
                "weight_this_month": weightThisMonth,
                "mean_last_month": meanLastMonth,
                "weight_last_month": weightLastMonth,
                "mean_most_likely": meanMostLikely,
                "weight_most_likely": weightMostLikely,
                "mean_most_optimistic": meanMostOptimistic,
                "weight_most_optimistic": weightMostOptimistic,
                "mean_most_pessimistic": meanMostPessimistic,
                "weight_most_pessimistic": weightMostPessimistic,
                "last_changed": "\(lround(Date().timeIntervalSince1970))",
                "service_id": serviceId
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .postPunchQueuestatus(let service_id, let punch_type):
            let parameters = [
                "service_id": service_id,
                "punch_type": punch_type,
                "punch_time": "\(lround(Date().timeIntervalSince1970))"
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
