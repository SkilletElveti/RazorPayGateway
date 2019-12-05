//
//  AFWrapper.swift
//  E-Prashasan
//
//  Created by Appristine Mahesh on 25/07/19.
//  Copyright © 2019 Pavan Kherde. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
    
//    class func sendOTP(view : UIViewController, showloader: Bool, requestMethod : HTTPMethod, _ strURL : String, params : [String : AnyObject]?) -> JSON {
//
//        var response: JSON?
//
//        AFWrapper.requestPOSTURL(view: view, showloader: showloader, requestMethod : requestMethod, strURL,params: params , success: {
//            (JSONResponse) -> Void in
//
//            response = JSONResponse
//
//        }) {
//            (error) -> Void in
//
//        }
//
//        return response!
//    }
//
//    static func sendOTP(completion:@escaping (Result<User>)->Void) {
//        performRequest(route: APIRouter.sendOtp, completion: completion)
//    }
    
//    static func loginAPI(view : UIView, mobileNumberStr : String, completion:@escaping (apiResult)->()){
//
//        let strURL = Constants.SERVER_URL + Constants.SEND_OTP_URL + mobileNumberStr
//
//        let params:[String:AnyObject]? = [:]
//
//        let headers = ["Content-Type": "application/json", "accept-language" : "en", "x-origin" : "admin-portal"]
//
//        AFWrapper.requestPOSTURL(view: view, requestMethod : .post, strURL,params: params ,headers: headers, success: { (JSON) -> Void in
//
//            DispatchQueue.main.async{
//                completion(.sucess)
//            }
//        }, failure: { (Error)->Void  in
//            print(Error)
//            completion(.sucess)
//        })
//    }
    
    class func getHeaders() -> [String : String] {
        return ["Content-Type": "application/json", "accept-language" : "en", "x-origin" : "admin-portal"]
    }
    
//    class func requestPOSTURL(view : UIViewController, showloader: Bool, requestMethod : HTTPMethod, _ strURL : String, params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void){
//
//        print(JSON(params))
//
//        if showloader {
//       //     view.showLoader()
//        }
//
//        let requestUrl = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//        print("URL ->\(requestUrl ?? "")")
//
//        let Alamofire = SessionManager.default
//        Alamofire.session.configuration.timeoutIntervalForRequest = 300
//
//        Alamofire.request(requestUrl!, method: requestMethod, parameters: params, encoding: URLEncoding.httpBody, headers: getHeaders())
//            .downloadProgress(queue: DispatchQueue.global(qos: .utility)){
//                progress in
//            }
//            .responseJSON {
//
//                response in
//                if response.result.isSuccess {
//
//                    //view.stopLoader()
//
//                    let resJson = JSON(response.result.value!)
//
//                    print(resJson)
//
//                    if resJson["statusCode"].intValue == Constants.RESPONSE_CODE_SUCESS {
//
//                        success(resJson)
//
//                    }else {
//
//                        if resJson["statusCode"].intValue == Constants.RESPONSE_CODE_DATA_NOT_FOUND {
//
//                            if showloader {
//
//                                //view.showToast(message: "Data not found")
//
//                            }
//                        }else if resJson["statusCode"].intValue == Constants.RESPONSE_CODE_INTERNAL_SERVER_ERROR {
//
//                            if showloader {
//
//                                //view.showToast(message: "Internal server error")
//
//                            }
//                        }
//                    }
//                }
//                if response.result.isFailure {
//
//                   // view.stopLoader()
//
//                    if let httpStatusCode = response.response?.statusCode {
//                        switch(httpStatusCode) {
//                        case 404:
//                            break
//                        case -1005:
//                            let error : NSError = response.result.error! as NSError
//                            failure(error)
//                            break
//                        default:
//                            break;
//                        }
//                    } else {
//
//                        let error : NSError = response.result.error! as NSError
//                        failure(error)
//
//                    }
//                }
//        }
//    }
    
    class func requestWith(url: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Token": "Bearer"
        ]
        
        print("Headers => \(headers)")
        
        print("Server Url => \(url)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "club_image", fileName: "image.png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    print(JSON(response.result.value as Any))
                    onCompletion?(JSON(response.result.value as Any))
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    class func requestPOSTURLWithJSONRequest(view : UIViewController, requestMethod : HTTPMethod, _ strURL : String, params : [String : AnyObject]?, headers: [String: String]?, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void){
        
        print(JSON(params))
        
        //view.showLoader()
        
        let requestUrl = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("URL ->\(requestUrl ?? "")")
        
        let Alamofire = SessionManager.default
        Alamofire.session.configuration.timeoutIntervalForRequest = 300
        
        Alamofire.request(requestUrl!, method: requestMethod, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)){
                progress in
            }
            .responseJSON {
                
                response in
                if response.result.isSuccess {
                    
                   // view.stopLoader()
                    
                    let resJson = JSON(response.result.value!)
                    
                    print(resJson)
                    
//                    if resJson["status"].boolValue  {

                        success(resJson)

//                    }else {

                        //view.showToast(message: "Please try again")

  //                  }

//                    print(resJson)
//                    success(resJson)
                    
                }
                if response.result.isFailure {
                    
                   // view.stopLoader()
                    
                    print(response.result.error)
                    
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 404:
                            
                            break
                        case -1005:
                            
                            let error : NSError = response.result.error! as NSError
                            failure(error)
                            
                            break
                        default:
                            break;
                        }
                    } else {
                        
                        let error : NSError = response.result.error! as NSError
                        failure(error)
                        
                    }
                }
        }
    }
}

