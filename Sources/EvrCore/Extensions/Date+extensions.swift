//
//  File.swift
//  
//
//  Created by Evren Yaşar on 25.10.2022.
//

import Foundation

extension Data{
    
    public var prettyPrintedJSONString: NSString {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return "Json can not converted" }
        
        return NSString(utf8String: prettyPrintedString) ?? ""
    }
    
}

