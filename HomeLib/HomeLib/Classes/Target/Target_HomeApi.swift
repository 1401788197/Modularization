//
//  Target_HomeApi.swift
//  HomeLib
//
//  Created by Mac027 on 2022/3/8.
//

import UIKit

class Target_HomeApi: NSObject {
    /// 获取首页控制器
    @objc func Action_getHomeController(_ parm: NSDictionary) -> UIViewController {
        HomeViewController(nibName: "HomeViewController", bundle: .init(for: HomeViewController.self))
    }
}
