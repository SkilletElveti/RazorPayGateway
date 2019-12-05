//
//  ViewController.swift
//  RazorDemo
//
//  Created by Shubham Vinod Kamdi on 05/12/19.
//  Copyright © 2019 Shubham Vinod Kamdi. All rights reserved.
//

import UIKit
import Razorpay

class ViewController: UIViewController ,RazorpayPaymentCompletionProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var razorpay: Razorpay!
    
    override func viewWillAppear(_ animated: Bool) {
        razorpay = Razorpay.initWithKey("YOUR_API_KEY", andDelegate: self)
        orderID()
        
    }
    
    var order_id: String!
    
    func orderID(){
        //HEADERS WERE GENERATED USING POSTMAN
     let headers = [
         "Content-Type": "application/json",
         "Authorization": "THIS_WILL_BE_GENERATED_USING_POSTMAN",
         "User-Agent": "PostmanRuntime/7.20.1",
         "Accept": "/",
         "Cache-Control": "no-cache",
         "Postman-Token": "THIS_WILL_BE_GENERATED_USING_POSTMAN",
         "Host": "api.razorpay.com",
         "Accept-Encoding": "gzip, deflate",
         "Content-Length": "104",
         "Connection": "keep-alive",
         "cache-control": "no-cache"
       ]
        
       let parameters = [
         "amount": "250000",
         "currency": "INR",
         "receipt": "45688",
         "payment_capture": "0"
       ] as [String : Any]
        
        AFWrapper.requestPOSTURLWithJSONRequest(view: self, requestMethod: .post, "https://api.razorpay.com/v1/orders", params: parameters as [String : AnyObject], headers: headers, success: {
            (JSONResponse) -> Void in
            if JSONResponse["status"].stringValue == "created"{
                
                self.order_id = JSONResponse["id"].stringValue
                self.showPaymentForm()
                
            }
            print(JSONResponse)
        }, failure: {
            (Error) -> Void in
            print(Error)
        })
        
    }

    func showPaymentForm(){
        let options: [String:Any] = [
         "amount" : "1000", //mandatory in paise like:- 1000 paise ==  10 rs
         "description": "purchase description",
         "image": "ss",
         "name": "Swift Series",
         "order_id" : self.order_id as Any,
         "prefill": [
         "contact": "9797979797",
         "email": "foo@bar.com"
         ],
         "theme": [
             "color": "#F37254"
         ]
     ]
        razorpay?.open(options, display: self)
        
    }

    
    func onPaymentError(_ code: Int32, description str: String) {
        print("Error: \(description)")
    }
       
    func onPaymentSuccess(_ payment_id: String) {
        print("Payment Id => \(payment_id)")
    }
    
}

