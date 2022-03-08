//
//  Observable+Extension.swift
//  CommonLib
//
//  Created by Mac027 on 2022/3/8.
//

import Alamofire
import CoreAudio
import Foundation
import HandyJSON
import RxSwift
import Moya
extension Observable {
    /// 将 data 解析为pb对象
    /// - Parameter type: 要转为的类
    /// - Returns: 转换后的观察者对象
    public func mapObject<T: HandyJSON>(_ type: T.Type) -> Observable<T?> {
        return map { data in
            // 将参数尝试转为字符串
            guard let dataString = data as? String else {
                // data不能转为字符串
                return nil
            }

            if dataString.isEmpty {
                // 空字符
                // 也返回nil
                return nil
            }

            guard let result = type.deserialize(from: dataString) else {
                // 转为对象失败
                print("转为对象失败")
                return nil
            }

            // 解析成功
            // 返回解析后的对象
            return result
        }
    }
}

let printserialQueue = DispatchQueue(label: "printserialQueue")
///根据不同服务数据返回进行处理
public class HttpObserver<Element>: ObserverType {
    public func on(_ event: Event<Element>) {
//        switch event {
//        case let .next(value):
//            let pbValue = value as! Message
//            let pb64String = pbValue.data().base64EncodedString()
//            guard onResult == nil else {
//                var code = 0
//                var msg = ""
//                if let error = errPbs[pb64String], let errParm = error as? [String: String], errParm.count > 0 {
//                    code = Int(errParm["code"] ?? "0") ?? 0
//                    msg = errParm["msg"] ?? ""
//                }
//                onResult?(value, code, msg)
//                return
//            }
//
//            if let error = errPbs[pb64String] {
//                if onError != nil {
//                    requestErrorHandler(serverError: error as! [String: String])
//                }
//
//            } else {
//                onSuccess?(value)
//            }
//
//            printserialQueue.async {
//                print(value)
//            }
//
//        case let .error(error):
//            // 请求失败
//
//            print("HttpObserver error:\(error)")
//
//            requestErrorHandler(error: error)
//        default: break
//        }
    }

    public typealias E = Element

    /// 请求成功回调
    var onSuccess: ((E) -> Void)?

    /// 请求错误回调  返回值 true 代表框架自动处理错误
    var onError: ((_ code: Int, _ msg: String) -> Void)?
    /// 返回结果
    var onResult: ((_ data: E, _ code: Int, _ msg: String) -> Void)?

    /// 请求失败
    func requestErrorHandler(serverError: [String: String] = [:], error: Error? = nil) {
        var errorCode: Int = 0
        var errorMsg = ""
        if serverError.count > 0 {
            errorCode = Int(serverError["code"] ?? "0") ?? 0
            errorMsg = serverError["msg"] ?? ""
        } else {
            errorMsg = getErrorMsg(error)
        }

        if onError != nil {
            onError!(errorCode, errorMsg)
        }
    }

    func getErrorMsg(_ error: Error?) -> String {
        if let error = error as? MoyaError {
            // 有错误
            // error类似就是Moya.MoayError
            switch error {
            case let .imageMapping(response):
                return "网络异常，请稍后再试"

            case let .stringMapping(response):
                return "响应转为字符串错误，请稍后再试"
            case let .statusCode(response):
                // 响应码
                let code = response.statusCode
                return "网络异常，请稍后再试"
            case let .underlying(nsError as NSError, _):
                // 这里直接判断nsError.code有问题
                // 方法解决：https://github.com/Moya/Moya/issues/2059
                // NSError错误code对照表：https://www.jianshu.com/p/9c9f14d25572
                if let alamofireError = error.errorUserInfo["NSUnderlyingError"] as? Alamofire.AFError,
                   let underlyingError = alamofireError.underlyingError as NSError? {
                    switch underlyingError.code {
                    case NSURLErrorNotConnectedToInternet:
                        // 没有网络连接，例如：关闭了网络
                        return "网络异常，请稍后再试"

                    case NSURLErrorTimedOut:
                        // 连接超时，例如：网络特别慢
                        return "连接超时"

                    case NSURLErrorCannotFindHost:
                        // 域名无法解析，例如：域名写错了
                        return "找不到对应的主机"

                    case NSURLErrorCannotConnectToHost:
                        // 无法连接到主机，例如：解析的ip地址，或者直接写的ip地址无法连接
                        return "服务器连接失败"

                    default:
                        return error.localizedDescription
                    }
                } else {
                    return "网络异常，请稍后再试"
                }
            default:
                return "网络异常，请稍后再试"
            }
        }
        return "网络异常，请稍后再试"
    }
}

// MARK: - 扩展ObservableType

// 目的是添加两个自定义监听方法
// 一个是只观察请求成功的方法
// 一个既可以观察请求成功也可以观察请求失败
extension ObservableType {
    /// 特殊处理
    public func httpOnResult(_ onResult: @escaping ((_ data: Element, _ code: Int, _ msg: String) -> Void)) -> Disposable {
        let disposable = Disposables.create()
        let observer = HttpObserver<Element>()
        observer.onResult = onResult
        return Disposables.create(asObservable().subscribe(observer), disposable)
    }

    /// 观察成功和失败事件
    public func httpSubscribe(onSuccess: @escaping ((_ data: Element) -> Void), onError: @escaping ((_ code: Int, _ msg: String) -> Void)) -> Disposable {
        let disposable = Disposables.create()
        let observer = HttpObserver<Element>()
        observer.onSuccess = onSuccess
        observer.onError = onError
        return Disposables.create(asObservable().subscribe(observer), disposable)
    }

    /// 观察成功的事件

    public func httpOnSuccess(_ onSuccess: @escaping ((Element) -> Void)) -> Disposable {
        let disposable = Disposables.create()
        let observer = HttpObserver<Element>()
        observer.onSuccess = onSuccess
        return Disposables.create(asObservable().subscribe(observer), disposable)
    }
}
