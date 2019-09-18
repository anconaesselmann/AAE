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

public protocol ViewModelStateConvertable {
    associatedtype ViewModelStateData
    var viewModelState: ViewModelState<ViewModelStateData> { get }
}

public enum RequestStatus<RequestData, ResponseData, ErrorType> where ErrorType: Error {
    case unknown
    case inProgress(RequestData)
    case success(ResponseData)
    case error(ErrorType)
}

extension RequestStatus: ViewModelStateConvertable {
    public var viewModelState: ViewModelState<ResponseData> {
        switch self {
        case .unknown:
            return .error(AAError.unknown)
        case .inProgress: return .loading
        case .success(let data): return .loaded(data)
        case .error(let error): return .error(error)
        }
    }
}

public extension ObservableType where Element: ViewModelStateConvertable  {
    var viewModelState: Observable<ViewModelState<Element.ViewModelStateData>> {
        return self.map { (element: Element) -> ViewModelState<Element.ViewModelStateData> in
            let state: ViewModelState<Element.ViewModelStateData> = element.viewModelState
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

