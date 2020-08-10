//
//  SYKeyedArchiver.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/8/4.
//  Copyright © 2020 Mandora. All rights reserved.
//

import UIKit

class SYKeyedArchiver: NSObject {
    
    /// 归档文件
    class func archiver(folderName:String!, fileName:String!, object:AnyObject!) {
        
        var path = SY_SANDBOX_DOCUMENTS_DIRECTORY_PATH + "/\(SY_READ_FOLDER_NAME)/\(folderName!)"
        
        if creat_file(path: path) { // 创建文件夹成功或者文件夹存在
            
            path += "/\(fileName!)"
            
            NSKeyedArchiver.archiveRootObject(object, toFile: path)
        }
    }
    
    /// 解档文件
    class func unarchiver(folderName:String!, fileName:String!) ->AnyObject? {
        
        let path = SY_SANDBOX_DOCUMENTS_DIRECTORY_PATH + "/\(SY_READ_FOLDER_NAME)/\(folderName!)/\(fileName!)"
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject?
    }
    
    /// 删除归档文件
    class func remove(folderName:String!, fileName:String? = nil) ->Bool {
        
        var path = SY_SANDBOX_DOCUMENTS_DIRECTORY_PATH + "/\(SY_READ_FOLDER_NAME)/\(folderName!)"
        
        if fileName != nil && !fileName!.isEmpty { path += "/\(fileName!)" }
        
        do{
            try FileManager.default.removeItem(atPath: path)
            
            return true
            
        }catch{ }
        
        return false
    }
    
    /// 清空归档文件
    class func clear() ->Bool {
        
        let path = SY_SANDBOX_DOCUMENTS_DIRECTORY_PATH + "/\(SY_READ_FOLDER_NAME)"
        
        do{
            
            try FileManager.default.removeItem(atPath: path)
            
            return true
            
        }catch{ }
        
        return false
    }
    
    /// 是否存在归档文件
    class func isExist(folderName:String!, fileName:String? = nil) ->Bool {
        
        var path = SY_SANDBOX_DOCUMENTS_DIRECTORY_PATH + "/\(SY_READ_FOLDER_NAME)/\(folderName!)"
        
        if fileName != nil && !fileName!.isEmpty { path += "/\(fileName!)" }
        
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 创建文件夹,如果存在则不创建
    private class func creat_file(path:String) ->Bool {
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) { return true }
        
        do{
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            
            return true
            
        }catch{ }
        
        return false
    }
}
