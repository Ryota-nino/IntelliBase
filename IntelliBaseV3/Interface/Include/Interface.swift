//
//  Interface.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation

public class Interface {
    let apiPath: String
    var postParamStr: String = ""
    var isDownloading: Bool = true
    var error: Bool = false
    var content: Array<Dictionary<String,Any>> = []
    let sync: Bool = false
    
    init(
        apiFileName: String,
        parameter: Dictionary<String,String> = [:],
        sync: Bool = false
    ) {
        self.apiPath = HomePageUrl(lastDirectoryUrl: "api",fileName: "\(apiFileName).php").getFullPath()
        request(parameters: parameter)
        
        if(self.sync){
            // 値、またはエラーが帰るまでループ
            while self.isDownloading { if (self.error){ break } }
        }
        
        return
    }
    
    func request(parameters: Dictionary<String,String>) {
        //init return value
        var content : Array<Dictionary<String, Any>>! = [[:]]
        //created NSURL
        let requestURL = NSURL(string: self.apiPath)
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        //setting the method to post
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        if !parameters.isEmpty {
            //debug
//            print("param is not empty.")
            //set parameters
            var postParameters = ""
            for (param, key) in parameters {
                postParameters += "\(param)=\(key)&"
            }
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
            postParamStr = postParameters
        }
        //create task for request
        let task =  URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            print("Debug : Try request to \(self.apiPath)\(self.postParamStr)")
            
            if let error = error {
                print("error is \(String(describing: error))")
                // dubug
                print("Error : Failed request to \"\(self.apiPath)\(self.postParamStr)\".")
                self.error = true
                self.isDownloading = false
                return
            }
            // decoding JSON
            do {
                // convert to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                //jsonデータの解析
                if let parseJSON = myJSON {
                    // Error ?
                    if parseJSON["error"] as! Bool == true {
//                        print("Debug : \(parseJSON["message"] as! String) at API \"\(self.apiPath)\(self.postParamStr)\"")
                        self.error = true
                        self.isDownloading = false
                        return
                    }
                    // get content as Array
                    content = parseJSON["content"] as! Array?
                    // debug
//                    print(content!)
                    self.content = content
                    // debug
//                    print("Debug : Request to \"\(self.apiPath)\(self.postParamStr)\" completed.")
                    self.isDownloading = false
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}
