//
//  SYApis.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/7/22.
//  Copyright © 2020 Mandora. All rights reserved.
//

import UIKit
import Moya
import RealmSwift

// MARK: 缓存规则
public enum CacheKeyType {
    /// 匹配url+path+params
    case `default`
    
    /// 匹配url+path
    case base
    
    /// 匹配url+path+custom
    case custom(String)
}

enum SYApis {
    
    // MARK: 注册绑定模块
    case touristLogin
    
    case userInfo
    
    // MARK: Featured模块
    
    /// 获取首页数据
    case homePage
    
    /// 首页换一换
    case homePageChange(index: Int)
    
    /// 获取male页数据
    case malePage
    
    /// 获取female页数据
    case femalePage
    
    case hotBooks
    
    case rankList(rankId: Int, pageIndex: Int)
    
    case searchBook(keyword: String, pageIndex: Int)
    
    case hotSearch
    
    case bookFilter
    
    case allBook(params: [String: String], pageIndex: Int)
    
    // MARK: Library模块
    
    /// 获取书架推荐书籍
    case recommendBooks
    
    /// 获取我的书架数据
    case myBookshelf(pageIndex: Int)
    
    // MARK: Mine模块
    case systemMessage(pageIndex: Int)
    
    case productIds
    
    // MARK: Reading模块
    
    /// 获取指定书籍第一章信息
    case firstChapter(bid: String)
    
    /// 获取指定章节内容(next表示预加载当前章节后n个章节)
    case chapterContent(bid: String, cid: String, next: Int = 0)
    
    /// 获取书籍的所有目录信息
    case chapters(bid: String)
    
    // MARK: 书籍详情模块
    
    /// 获取书籍相关信息
    case bookInfo(bid: String)
    
    /// 获取书籍评论
    case bookComments(bid: String, pageIndex: Int)
    
    /// 加入书架
    case addBookshelf(bid: String, cid: String)
    
    /// 移出书架
    case removeBookshelf(bid: String)
    
    // MARK: 内购模块
    
    // 获取订单号
    case orderNum(price: String)
    
    // 验证订单
    case verifyReceipt(receiptString: String, transactionId: String, orderNum: String)
    
    // 获取首页书籍列表
    
    
    case getBookList(page: Int, limit: Int)
    
    
    case getBookPageList(bookId: Int, page: Int, limit: Int)
    
    
    case getBookPageContent(bookId: Int, bookPageNum: Int)
    
    case reportLoginInfo(phoneCode: String, userAgent: String)
    
    case reportJPushInfo(phoneCode: String, jPushId: String)
    
}

extension SYApis: TargetType {
    
    // 配置请求url
    var baseURL: URL {
        
        switch self {
        case .getBookList(_, _),
             .getBookPageList(_, _, _),
             .getBookPageContent(_, _),
             .reportLoginInfo(_, _),
             .reportJPushInfo(_, _):
            return URL(string: "https://qw.chuchu.com")!
        default:
            #if DEBUG
            return URL(string: Configs.Network.dev_url)!
            #else
            return URL(string: Configs.Network.pro_url)!
            #endif
        }
    }
    
    // 配置请求path
    var path: String {
        switch self {
        case .touristLogin:
            return "/1/member/tourist"
        case .userInfo:
            return "/1/member/Info"
        case .homePage:
            return "/1/book/index_1"
        case .homePageChange(_):
            return "/1/book/index_1_change"
        case .malePage:
            return "/1/book/male_index"
        case .femalePage:
            return "/1/book/female_index"
        case .recommendBooks:
            return "/1/book/bookcase"
        case .myBookshelf(_):
            return "/1/member/bookcase"
        case .hotSearch:
            return "/1/book/search_hot"
        case .bookFilter:
            return "/1/book/listset"
        case .allBook(_, _):
            return "/1/book/all"
        case .hotBooks:
            return "/1/book/all"
        case .rankList(_, _):
            return "/1/book/top"
        case .searchBook(_, _):
            return "/1/book/search"
        case .systemMessage(_):
            return "/1/member/message"
        case .productIds:
            return "/1/member/cardType"
        case .firstChapter(_):
            return "/1/book/firstChapter"
        case .chapterContent(_, _, _):
            return "/1/book/content"
        case .chapters(_):
            return "/1/book/chapter"
        case .bookInfo(_):
            return "/1/book/info"
        case .bookComments(_, _):
            return "/1/book/topic"
        case .addBookshelf(_, _):
            return "/1/member/addBookCase"
        case .removeBookshelf(_):
            return "/1/member/delBookCase"
        case .orderNum(_):
            return "/1/member/PayConfirm"
        case .verifyReceipt(_, _, _):
            return "/1/member/IosPayNotify"
        case .getBookList(_, _):
            return "/api/getBookList.html"
        case .getBookPageList(_, _, _):
            return "/api/getBookPageList"
        case .getBookPageContent(_, _):
            return "/api/getBookPageContent.html"
        case .reportLoginInfo(_, _):
            return "/api/reportUserLoginInfo.html"
        case .reportJPushInfo(_, _):
            return "/api/reportUserJpushId.html"
        }
    }
    
    // 配置请求方法
    var method: Moya.Method {
        switch self {
        case .touristLogin,
             .addBookshelf(_, _),
             .removeBookshelf(_),
             .verifyReceipt(_, _, _),
             .reportLoginInfo(_, _):
            return .post
        default:
            return .get
        }
    }
    
    // 单元测试返回的数据
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        guard let params = parameters else {
            return .requestPlain
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

extension SYApis {
    
    private var parameters: [String: Any]? {
        var paramters = [String: Any]()
        paramters["system"] = 2
        
        switch self {
        case .touristLogin:
            return paramters
            
        case .userInfo:
            return addUserParams(paramters)
            
        case .homePage:
            return paramters
            
        case .homePageChange(let index):
            paramters["model"] = index
            return paramters
        
        case .malePage:
            return paramters
            
        case .femalePage:
            return paramters
            
        case .recommendBooks:
            return paramters
            
        case .myBookshelf(let pageIndex):
            paramters["PageIndex"] = pageIndex
            paramters["PageSize"] = 20
            return addUserParams(paramters)
            
        case .hotBooks:
            paramters["d"] = 2
            paramters["PageIndex"] = 1
            paramters["PageSize"] = 20
            return paramters
            
        case .allBook(let params, let pageIndex):
            for key in params.keys {
                paramters[key] = params[key]
            }
            paramters["PageIndex"] = pageIndex
            paramters["PageSize"] = 20
            return paramters
            
        case .rankList(let rankId, let pageIndex):
            paramters["id"] = rankId
            paramters["PageSize"] = 20
            paramters["PageIndex"] = pageIndex
            return paramters
            
        case .searchBook(let keyword, let pageIndex):
            paramters["t"] = keyword
            paramters["PageSize"] = 20
            paramters["PageIndex"] = pageIndex
            return paramters
            
        case .firstChapter(let bid):
            paramters["bid"] = bid
            return paramters
            
        case .chapterContent(let bid, let cid, let next):
            paramters["bid"] = bid
            paramters["cid"] = cid
            paramters["next"] = next
            return addUserParams(paramters)
            
        case .chapters(let bid):
            paramters["bid"] = bid
            return paramters
            
        case .bookInfo(let bid):
            paramters["bid"] = bid
            return addUserParams(paramters)
            
        case .bookComments(let bid, let pageIndex):
            paramters["bid"] = bid
            paramters["PageSize"] = 20
            paramters["PageIndex"] = pageIndex
            return paramters
            
        case .addBookshelf(let bid, let cid):
            paramters["bid"] = bid
            if !cid.isEmpty {
                paramters["cid"] = cid
            }
            return addUserParams(paramters)
            
        case .removeBookshelf(let bid):
            paramters["bid"] = bid
            return addUserParams(paramters)
            
        case .orderNum(let price):
            paramters["pType"] = 209
            paramters["total_amount"] = price
            return addUserParams(paramters)
            
        case .verifyReceipt(let receiptString, let transactionId, let orderNum):
            paramters["orderNumber"] = orderNum
            paramters["receiptdata"] = receiptString
            paramters["trade_no"] = transactionId
            return addUserParams(paramters)
            
        case .getBookList(let page, let limit):
            paramters["page"] = page
            paramters["limit"] = limit
            return paramters
            
        case.getBookPageList(let bookId, let page, let limit):
            paramters["book_id"] = bookId
            paramters["page"] = page
            paramters["limit"] = limit
            return paramters
            
        case .getBookPageContent(let bookId, let bookPageNum):
            paramters["book_id"] = bookId
            paramters["book_page_num"] = bookPageNum
            return paramters
            
        case .reportLoginInfo(let phoneCode, let userAgent):
            paramters["phone_code"] = phoneCode
            paramters["ua"] = userAgent
            return paramters
            
        case .reportJPushInfo(let phoneCode, let jPushId):
            paramters["phone_code"] = phoneCode
            paramters["jpush_id"] = jPushId
            return paramters
            
        default:
            return paramters
        }
    }
    
    // 将用户相关参数添加的请求参数中
    func addUserParams(_ params: [String: Any]) -> [String: Any] {
        let realm = try! Realm()
        let model = realm.objects(SYUserModel.self).first!
        var parameters = params
        parameters["uid"] = model.uid
        parameters["token"] = model.token
        return parameters
    }
    
}

// MARK: 缓存相关
extension TargetType {
    
    func fetchCacheKey(_ type: CacheKeyType) -> String {
        switch type {
        case .base:
            return baseCacheKey
        case .default:
            return cacheKey
        case let .custom(key):
            return cacheKey(with: key)
        }
    }
    
    private var baseCacheKey : String {
        return "\(self.baseURL.absoluteString)\(self.path)"
    }
    
    private var cacheKey: String {
        let baseKey = baseCacheKey
        if params.isEmpty { return baseKey }
        return baseKey + params
    }
    
    private func cacheKey(with customKey: String) -> String {
        return baseCacheKey + "?" + customKey
    }
    
    
    private var params: String {
        switch self.task {
        case let .requestParameters(parameters, _):
            return (parameters as NSDictionary?)?.keyValues() ?? ""
        default: return  ""
        }
    }
    
}

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<SYApis>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let SYProvider = MoyaProvider<SYApis>(requestClosure: timeoutClosure, plugins: [SYRequestLoadingPlugin(), SYMoyaPlugins.SYNetworkActivityPlugin])
