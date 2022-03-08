//
//  Net.swift
//  Alamofire
//
//  Created by Mac027 on 2022/3/8.
//

import Moya
import RxSwift
import UIKit
public class Net: NSObject {
    public static let shared = Net()
    public let provider: MoyaProvider<Service>! //
    override private init() {
        // 插件列表
        var plugins: [PluginType] = []
        /// 日志插件
        let p = NetworkLoggerPlugin()
        plugins.append(p)

        let requestClosure = { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
            do {
                let request: URLRequest = try endpoint.urlRequest()
                closure(.success(request))
            } catch let MoyaError.requestMapping(url) {
                closure(.failure(MoyaError.requestMapping(url)))
            } catch let MoyaError.parameterEncoding(error) {
                closure(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
        provider = MoyaProvider<Service>(requestClosure: requestClosure, plugins: plugins)
    }
}
