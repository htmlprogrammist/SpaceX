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
    let patch: Patch?
    let reddit: Reddit?
    let flickr: Flickr?
    let youtube: String?
    let wikipedia: String?
    
    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr
        case youtube = "webcast"
        case wikipedia
    }
}

struct Patch: Codable {
    let small: String?
    let large: String?
}

struct Reddit: Codable {
    let campaign: String?
    let launch: String?
    let media: String?
    let recovery: String?
}

struct Flickr: Codable {
    let small: [String]?
    let original: [String]?
}
