//
//  HomeViewController.swift
//  Pods
//
//  Created by Mac027 on 2022/3/8.
//

import CommonLib
import Moya
import RxSwift
import UIKit
import Alamofire
class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "首页"
        /// 这里没有 使用rxSwift 的封装  参考 Observable+Extension.swift
        // Do any additional setup after loading the view.
        /// http://itunes.apple.com/lookup?id=1329918420
        Net.shared.provider.request(.get(url: "/lookup?id=1329918420", parms: [:])) { result in
            // result类型是Result<Response, MoyaError>
            switch result {
            case let .success(response):
                // 请求成功
                let data = response.data
                let code = response.statusCode
                // 将data转为String
                // data的类型为Data
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print("RegisterController request sheet detail succes:\(code),\(dataString)")
                 case let .failure(error):
                // 请求失败
                print("RegisterController request sheet detail failed:\(error)")
            }
        }
    }
}
