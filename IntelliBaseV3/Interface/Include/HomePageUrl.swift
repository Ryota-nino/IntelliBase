//
//  HomePageUrl.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation

public class HomePageUrl {
    let apiProtocol: String
    let apiIpAddress: String
    let apiMiddleDirectoryUrl: String
    let apiLastDirectoryUrl: String
    let apiFileName: String
    let getParams: Dictionary<String,String>
    
    init(
        protocolStr: String = "http",
        ip: String = "localhost",
//        ip: String = "tingttmacbookpro.local",
//        ip: String = "169.254.108.1",
        middleDirectoryUrl: String = "IntelliBase",
        lastDirectoryUrl: String,
        fileName: String,
        getParams: Dictionary<String,String> = [:]
    ) {
        self.apiProtocol = protocolStr
        self.apiIpAddress = ip
        self.apiMiddleDirectoryUrl = middleDirectoryUrl
        self.apiLastDirectoryUrl = lastDirectoryUrl
        self.apiFileName = fileName
        self.getParams = getParams
    }
    
    func getFullPath() -> String {
        var url = self.apiProtocol + "://" + self.apiIpAddress +  "/" + self.apiMiddleDirectoryUrl + "/" + self.apiLastDirectoryUrl + "/" + self.apiFileName + "?"
        for (key, param) in self.getParams {
            url += key + "=" + param + "&"
        }
        return url
    }
}
