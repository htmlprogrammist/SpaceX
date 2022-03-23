//
//  Launch.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 23.03.2022.
//

import Foundation

struct Launch: Codable {
    let links: Links?
    let name: String?
    let success: Bool?
    let upcoming: Bool?
    let flightNumber: Int?
    let details: String?
    let staticFireDate: String?
    let launchDate: String?
    let rocket: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case links, name, success, details
        case flightNumber = "flight_number"
        case launchDate = "date_utc"
        case upcoming
        case staticFireDate = "static_fire_date_utc"
        case rocket, id
    }
}

struct Links: Codable {
    var patch: Patch?
    var reddit: Reddit?
    var flickr: Flickr?
    var youtube: String?
    var wikipedia: String?
    
    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr
        case youtube = "webcast"
        case wikipedia
    }
}

struct Patch: Codable {
    var small: String?
    var large: String?
}

struct Reddit: Codable {
    var campaign: String?
    var launch: String?
    var media: String?
    var recovery: String?
}

struct Flickr: Codable {
    var small: [String]?
    var original: [String]?
}
