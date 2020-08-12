//
//  SYMRMBGColorView.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/08/11.
//  Copyright © 2020年 Mandora. All rights reserved.
//

import UIKit

class SYMRMBGColorView: SYRMBaseView {

    private var items:[UIButton] = []
    
    private var selectItem:UIButton!
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func setupUI() {
        
        super.setupUI()
        
        backgroundColor = UIColor.clear
        
        let count = DZM_READ_BG_COLORS.count
        
        for i in 0..<count {
            
            let color = DZM_READ_BG_COLORS[i]
            
            let item = UIButton(type: .custom)
            item.tag = i
            item.backgroundColor = color
            item.layer.cornerRadius = DZM_SPACE_SA_6
            item.layer.borderColor = DZM_READ_COLOR_MAIN.cgColor
            item.layer.borderWidth = 0
            item.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
            addSubview(item)
            items.append(item)
            
            if i == SYReadConfigure.shared().bgColorIndex.intValue { selectItem(item) }
        }
    }
    
    private func selectItem(_ item:UIButton) {
        
        selectItem?.layer.borderWidth = 0
        
        item.layer.borderWidth = 1.5
        
        selectItem = item
    }
    
    @objc private func clickItem(_ item:UIButton) {
        
        if selectItem == item { return }
        
        selectItem(item)
        
        SYReadConfigure.shared().bgColorIndex = NSNumber(value: item.tag)
        
        SYReadConfigure.shared().save()
        
        readMenu?.delegate?.readMenuClickBGColor?(readMenu: readMenu)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let count = DZM_READ_BG_COLORS.count
        
        let w = frame.size.width
        let h = frame.size.height
        
        let itemWH = DZM_SPACE_SA_30
        let itemY = (h - itemWH) / 2
        let itemSpaceW = (w - CGFloat(count) * itemWH) / (CGFloat(count - 1))
        
        for i in 0..<count {
            
            let item = items[i]
            item.frame = CGRect(x: CGFloat(i) * (itemWH + itemSpaceW), y: itemY, width: itemWH, height: itemWH)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
