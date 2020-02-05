//  Created by Axel Ancona Esselmann on 9/11/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation
import RxSwift

public enum AAError: Error {
    case unknown
    case deinitialized
}

public enum TypelessRequestStatus {
    case inProgress
    case success
    case error(Error)
}

public protocol LoadableResultConvertable {
    associatedtype LoadableResultData
    var loadableResult: LoadableResult<LoadableResultData> { get }
}

public enum RequestStatus<RequestData, ResponseData, ErrorType> where ErrorType: Error {
    case unknown
    case inProgress(RequestData)
    case success(ResponseData)
    case error(ErrorType)
}

extension RequestStatus: LoadableResultConvertable {
    public var loadableResult: LoadableResult<ResponseData> {
        switch self {
        case .unknown:
            return .error(AAError.unknown)
        case .inProgress: return .loading
        case .success(let data): return .loaded(data)
        case .error(let error): return .error(error)
        }
    }
}

public extension ObservableType where Element: LoadableResultConvertable  {
    var loadableResult: ObservableState<Element.LoadableResultData> {
        return self.map { (element: Element) -> LoadableResult<Element.LoadableResultData> in
            let state: LoadableResult<Element.LoadableResultData> = element.loadableResult
            return state
        }
    }
}

extension RequestStatus: LoadableType {
    public var loaded: ResponseData? {
        switch self {
        case .unknown, .inProgress, .error: return nil
        case .success(let loaded): return loaded
        }
    }
}

extension RequestStatus: TypelessRequestStatusConvertable {
    public var typeless: TypelessRequestStatus {
        switch self {
        case .unknown, .inProgress: return .inProgress
        case .success: return .success
        case .error(let error): return .error(error)
        }
    }
}

