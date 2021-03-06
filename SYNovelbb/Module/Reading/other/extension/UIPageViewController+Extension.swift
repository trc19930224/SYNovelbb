//
//  UIPageViewController+Extension.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/08/11.
//  Copyright © 2020年 Mandora. All rights reserved.
//

private var IsGestureRecognizerEnabled = "IsGestureRecognizerEnabled"
private var TapIsGestureRecognizerEnabled = "TapIsGestureRecognizerEnabled"

import UIKit

extension UIPageViewController {

    /// 手势启用
    var gestureRecognizerEnabled:Bool {
        
        get{ return (objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? Bool) ?? true }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue }
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// tap手势
    var tapGestureRecognizer:UITapGestureRecognizer? {

        for ges in gestureRecognizers {
            
            if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                
                return ges as? UITapGestureRecognizer
            }
        }
        
        return nil
    }
    
    /// tap手势启用
    var tapGestureRecognizerEnabled:Bool {
        
        get{ return (objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? Bool) ?? true }
        
        set{
            
            tapGestureRecognizer?.isEnabled = newValue
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
