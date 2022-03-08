//
//  Service.swift
//  Alamofire
//
//  Created by Mac027 on 2022/3/8.
//

import Moya
import UIKit

public enum Service {
    case post(url: String, parms: [String: Any])
    case get(url: String, parms: [String: Any])
}

extension Service: TargetType {
    public var baseURL: URL {
        .init(string: "http://itunes.apple.com")!
    }

    public var path: String {
        var path: String
        switch self {
        case let .post(url, _):
            path = url
        case let .get(url, _):
            path = url
        }
        return path
    }

    public var method: Moya.Method {
        switch self {
        case .post:
            return .post
        case .get:
            return .get
        }
    }

    public var task: Task {
        var parameters: [String: Any]
        switch self {
        case let .post(_, parms):
            parameters = parms
        case let .get(_, parms):
            parameters = parms
        }
        guard parameters.count > 0 else {
            return .requestPlain
        }
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }

    public var headers: [String: String]? {
        nil
    }
}
