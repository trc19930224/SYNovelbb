//
//  SYNavigationController.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/7/23.
//  Copyright © 2020 Mandora. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class SYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 开启右滑返回手势
        self.fd_fullscreenPopGestureRecognizer.isEnabled = true
        if userDefault.isBookcase {
            self.navigationBar.barTintColor = UIColor(24, 144, 255)
            self.navigationBar.isTranslucent = false
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        } else {
            self.navigationBar.barTintColor = .white
            self.navigationBar.isTranslucent = false
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor(51, 51, 51)]
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            // 非根控制器
            viewController.hidesBottomBarWhenPushed = true
            
            let backButton : UIButton = UIButton(type : .system)
            if userDefault.isBookcase {
                backButton.setImage(UIImage(named :"navigation_back_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                backButton.setImage(UIImage(named :"navigation_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            backButton.addTarget(self, action :#selector(goBack), for: .touchUpInside)
            backButton.sizeToFit()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButton)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK: action
    @objc func goBack() {
        popViewController(animated: true)
    }
    
    deinit {
        logInfo("\(self) 已释放")
    }

}
