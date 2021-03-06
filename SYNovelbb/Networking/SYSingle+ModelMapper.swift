//
//  SYSingle+ModelMapper.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/7/23.
//  Copyright © 2020 Mandora. All rights reserved.
//

import Moya
import RxSwift
import HandyJSON

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func map<T: HandyJSON>(result type: T.Type) -> Single<SYResponseModel<T>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<SYResponseModel<T>> in
                return Single.just(try response.map(result: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func map<T: HandyJSON>(resultList type: T.Type) -> Single<SYResponseModel<[T]>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<SYResponseModel<[T]>> in
                return Single.just(try response.map(result: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func qm_map<T: HandyJSON>(result type: T.Type) -> Single<QMResponseModel<T>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<QMResponseModel<T>> in
                return Single.just(try response.qm_map(result: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func qm_map<T: HandyJSON>(resultList type: T.Type) -> Single<QMResponseModel<[T]>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<QMResponseModel<[T]>> in
                return Single.just(try response.qm_map(result: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
}
