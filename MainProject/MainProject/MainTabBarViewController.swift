//
//  MainTabBarViewController.swift
//  MainProject
//
//  Created by Mac027 on 2022/3/8.
//

import CommonLib
import CTMediator
import UIKit
class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addAllChilds()
    }

    func addAllChilds() {
        addOneChild(CT().homeController(), "message", "首页")
        addOneChild(CT().mineController(), "mine", "我的")
    }

    func addOneChild(_ controller: UIViewController?, _ iconName: String, _ title: String) {
        guard let controller = controller else {
            return
        }
        addChild(UINavigationController(rootViewController: controller))
        controller.tabBarItem.image = UIImage(named: "tabbar_" + iconName)?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "tabbar_" + iconName + "_sel")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.title = title
    }
}
