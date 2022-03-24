//
//  Launchpad.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 24.03.2022.
//

import Foundation

struct Launchpad: Codable {
    let name: String?
    let fullName: String?
    let locality: String?
    let region: String?
    let timezone: String?
    let latitude: Double?
    let longitude: Double?
    let launchAttempts: Int?
    let launchSuccesses: Int?
    let rockets: [String]?
    let launches: [String]?
    let status: String
    let details: String?
    let id: String?
    let images: LaunchpadImages?
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case locality, region, timezone, latitude, longitude
        case launchAttempts = "launch_attempts"
        case launchSuccesses = "launch_successes"
        case rockets, launches, status, details, id, images
    }
}

struct LaunchpadImages: Codable {
    let large: [String]?
}
