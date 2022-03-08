//
//  CTMediator+Mine.swift
//  CommonLib
//
//  Created by Mac027 on 2022/3/8.
//
import CTMediator
import Foundation
extension CTMediator{
    @objc public func mineController() -> UIViewController? {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: "MineLib",
        ] as [AnyHashable: Any]
        return performTarget("MineApi", action: "getMineController", params: params, shouldCacheTarget: false) as? UIViewController
    }
}
