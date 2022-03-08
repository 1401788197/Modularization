//
//  CTMediator+Home.swift
//  HomeLib
//
//  Created by Mac027 on 2022/3/8.
//

import Foundation
import CTMediator
extension CTMediator{
    @objc public func homeController() -> UIViewController? {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: "HomeLib",
        ] as [AnyHashable: Any]
        return performTarget("HomeApi", action: "getHomeController", params: params, shouldCacheTarget: false) as? UIViewController
    }
}
