//
//  Target_HomeApi.swift
//  HomeLib
//
//  Created by Mac027 on 2022/3/8.
//

import UIKit

class Target_MineApi: NSObject {
    /// 获取首页控制器
    @objc func Action_getMineController(_ parm: NSDictionary) -> UIViewController {
        MineViewController(nibName: "MineViewController", bundle: .init(for: MineViewController.self))
    }
}
