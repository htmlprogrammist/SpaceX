//
//  NetworkManagerProtocol.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 07.03.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    var session: URLSession { get set }
    func perform<Model: Codable>(request: NetworkRequest, completion: @escaping (Result<Model, NetworkManagerError>) -> Void)
}
