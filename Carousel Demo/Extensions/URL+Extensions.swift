//
//  URL+Extensions.swift
//  CoupangPlayDemo
//
//  Created by Jeet Gandhi on 15/3/21.
//

import Foundation

infix operator ⠅╱╱

@dynamicMemberLookup public struct Hostname {
    let rawValue: String
    subscript(dynamicMember string: String) -> Hostname {
        Hostname(rawValue: rawValue + "." + string)
    }
}

public struct Scheme {
    let rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public let www = Hostname(rawValue: "www")
public let youtube = Hostname(rawValue: "youtube")
public let https = Scheme(rawValue: "https")

public func ⠅╱╱(scheme: Scheme, hostname: Hostname) -> URL {
    var components = URLComponents()
    components.scheme = scheme.rawValue
    components.host = hostname.rawValue
    return components.url!
}

//let url = https⠅╱╱www.apple.com
//print(url)
