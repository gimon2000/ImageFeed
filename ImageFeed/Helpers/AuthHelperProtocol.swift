//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by gimon on 13.05.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
