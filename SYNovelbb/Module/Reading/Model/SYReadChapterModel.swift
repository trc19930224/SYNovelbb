//
//  SYReadChapterModel.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/08/11.
//  Copyright © 2020年 Mandora. All rights reserved.
//

import UIKit

class SYReadChapterModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID: String!
    
    /// 章节ID
    var chapterId: NSNumber!
    
    /// 上一章ID
    var previousChapterID: NSNumber!
    
    /// 下一章ID
    var nextChapterID: NSNumber!
    
    /// 章节名称
    var name: String!
    
    /// 内容
    /// 此处 content 是经过排版好且双空格开头的内容。
    /// 如果是网络数据需要确认是否处理好了,也就是在网络章节数据拿到之后, 使用排版接口进行排版并在开头加上双空格。(例如: SY_READ_PH_SPACE + 排版好的content )
    /// 排版内容搜索 contentTypesetting 方法
    var content: String!
    
    /// 优先级 (一般章节段落都带有排序的优先级 从0开始)
    var priority: NSNumber!
    
    /// 本章有多少页
    var pageCount: NSNumber! = NSNumber(value: 0)
    
    /// 分页数据
    var pageModels: [SYReadPageModel]! = []
    
    /// 章节价格(＞0则需要付费订阅才能观看)
    var chapterMoney: Int!
    
    // MARK: 快捷获取
    
    /// 当前章节是否为第一个章节
    var isFirstChapter: Bool! { return (previousChapterID == SY_READ_NO_MORE_CHAPTER) }
    
    /// 当前章节是否为最后一个章节
    var isLastChapter: Bool! { return (nextChapterID == SY_READ_NO_MORE_CHAPTER) }
    
    /// 完整章节名称
    var fullName: String! { return DZM_READ_CHAPTER_NAME(name) }
    
    /// 完整富文本内容
    var fullContent: NSAttributedString!
    
    /// 分页总高 (上下滚动模式使用)
    var pageTotalHeight: CGFloat {
        
        var pageTotalHeight: CGFloat = 0
        
        for pageModel in pageModels {
            
            pageTotalHeight += (pageModel.contentSize.height + pageModel.headTypeHeight)
        }
        
        return pageTotalHeight
    }
    
    
    // MARK: -- 更新字体
    
    /// 内容属性变化记录(我这里就只判断内容了字体属性变化了，标题也就跟着变化或者保存变化都无所谓了。如果有需求可以在加上比较标题属性变化)
    private var attributes: [NSAttributedString.Key:Any]! = [:]
    
    /// 更新字体
    func updateFont() {
        
        let tempAttributes = SYReadConfigure.shared().attributes(isTitle: false, isPageing: true)
        
        if !NSDictionary(dictionary: attributes).isEqual(to: tempAttributes) {
            
            attributes = tempAttributes
            
            fullContent = fullContentAttrString()
            
            pageModels = SYReadParser.pageing(attrString: fullContent, rect: CGRect(origin: CGPoint.zero, size: SY_READ_VIEW_RECT.size), isFirstChapter: isFirstChapter)
            
            pageCount = NSNumber(value: pageModels.count)
            
            save()
        }
    }
    
    /// 完整内容排版
    private func fullContentAttrString() ->NSMutableAttributedString {
        
        let contentString = NSMutableAttributedString(string: content, attributes: SYReadConfigure.shared().attributes(isTitle: false))
        
        return contentString
    }
    
    // MARK: 辅助功能
    
    /// 获取指定页码字符串
    func contentString(page:NSInteger) ->String {
        
        return pageModels[page].content.string
    }

    /// 获取指定页码富文本
    func contentAttributedString(page:NSInteger) ->NSAttributedString {
        
        return pageModels[page].showContent
    }
    
    /// 获取指定页开始坐标
    func locationFirst(page:NSInteger) ->NSNumber {
        
        return NSNumber(value: pageModels[page].range.location)
    }
    
    /// 获取指定页码末尾坐标
    func locationLast(page:NSInteger) ->NSNumber {
        
        let range = pageModels[page].range!
        
        return NSNumber(value: range.location + range.length)
    }
    
    /// 获取指定页中间
    func locationCenter(page:NSInteger) ->NSNumber {
        
        let range = pageModels[page].range!
        
        return NSNumber(value: (range.location + (range.location + range.length) / 2))
    }
    
    /// 获取存在指定坐标的页码
    func page(location:NSInteger) ->NSNumber {
        
        let count = pageModels.count
        
        for i in 0..<count {
            
            let range = pageModels[i].range!
            
            if location < (range.location + range.length) {
                
                return NSNumber(value: i)
            }
        }
        
        return NSNumber(value: 0)
    }
    
    /// 保存
    func save() {
        
        SYKeyedArchiver.archiver(folderName: bookID, fileName: chapterId.stringValue, object: self)
    }
    
    /// 是否存在章节内容
    class func isExist(bookID:String!, chapterID:NSNumber!) ->Bool {
        
        return SYKeyedArchiver.isExist(folderName: bookID, fileName: chapterID.stringValue)
    }
    
    // MARK: 构造
    
    /// 获取章节对象,如果则创建对象返回
    class func model(bookID:String!, chapterID:NSNumber!, isUpdateFont:Bool = true) -> SYReadChapterModel {
        
        var chapterModel: SYReadChapterModel!
        
        if SYReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = SYKeyedArchiver.unarchiver(folderName: bookID, fileName: chapterID.stringValue) as? SYReadChapterModel
            
            if isUpdateFont { chapterModel?.updateFont() }
            
        }else{
            
            chapterModel = SYReadChapterModel()
            
            chapterModel.bookID = bookID
            
            chapterModel.chapterId = chapterID
        }
        
        return chapterModel
    }
        
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        chapterId = aDecoder.decodeObject(forKey: "chapterId") as? NSNumber
        
        previousChapterID = aDecoder.decodeObject(forKey: "previousChapterID") as? NSNumber
        
        nextChapterID = aDecoder.decodeObject(forKey: "nextChapterID") as? NSNumber
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        
        priority = aDecoder.decodeObject(forKey: "priority") as? NSNumber
        
        content = aDecoder.decodeObject(forKey: "content") as? String
        
        fullContent = aDecoder.decodeObject(forKey: "fullContent") as? NSAttributedString
        
        pageCount = aDecoder.decodeObject(forKey: "pageCount") as? NSNumber
        
        pageModels = aDecoder.decodeObject(forKey: "pageModels") as? [SYReadPageModel]
        
        chapterMoney = aDecoder.decodeObject(forKey: "chapterMoney") as? Int
        
        attributes = aDecoder.decodeObject(forKey: "attributes") as? [NSAttributedString.Key:Any]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(chapterId, forKey: "chapterId")
        
        aCoder.encode(previousChapterID, forKey: "previousChapterID")
        
        aCoder.encode(nextChapterID, forKey: "nextChapterID");
        
        aCoder.encode(name, forKey: "name")
        
        aCoder.encode(priority, forKey: "priority")
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(fullContent, forKey: "fullContent")
        
        aCoder.encode(pageCount, forKey: "pageCount")
        
        aCoder.encode(pageModels, forKey: "pageModels")
        
        aCoder.encode(chapterMoney, forKey: "chapterMoney")
        
        aCoder.encode(attributes, forKey: "attributes")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
