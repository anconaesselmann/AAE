//  Created by Axel Ancona Esselmann on 1/23/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift
import RxOptional
import RxCocoa

public typealias ObservableState<T> = Observable<ViewModelState<T>>
public typealias DrivableState<T> = Driver<ViewModelState<T>>
public typealias BehaviourState<T> = BehaviorSubject<ViewModelState<T>>
public typealias PublishState<T> = PublishSubject<ViewModelState<T>>

public protocol LoadableType {
    associatedtype LoadedType
    var loaded: LoadedType? { get }
}

extension ViewModelState: LoadableType {
    public var loaded: T? {
        switch self {
        case .inactive, .loading, .error: return nil
        case .loaded(let loaded): return loaded
        }
    }
}

extension ViewModelState: ViewModelStateConvertable {
    public var viewModelState: ViewModelState<LoadedType> {
        return self
    }
}

extension ObservableType where Element: ViewModelStateConvertable {
    public func subscribe(
        onLoading: (() -> Void)? = nil,
        onLoaded: ((Element.ViewModelStateData) -> Void)? = nil,
        onError: ((Swift.Error) -> Void)? = nil,
        onCompleted: (() -> Void)? = nil,
        onDisposed: (() -> Void)? = nil
    ) -> Disposable {
        return subscribe(
            onNext: { stateConvertable in
                switch stateConvertable.viewModelState {
                case .inactive: break
                case .loading: onLoading?()
                case .loaded(let loadedValue): onLoaded?(loadedValue)
                case .error(let error): onError?(error)
                }
            },
            onError: { error in
                onError?(error)
            },
            onCompleted: {
                onCompleted?()
            },
            onDisposed: {
                onDisposed?()
            }
        )
    }

    public func bindViewModelState<O>(to observer: O?, behavior: ViewModelBindingBehaviour = .default, onLoaded: ((Element.ViewModelStateData) -> Void)? = nil) -> Disposable where Self.Element: ViewModelStateConvertable, O: ObserverType, Self.Element == O.Element {
        return self.subscribe(
            onNext: { stateConvertable in
                guard let onLoaded = onLoaded else {
                    observer?.onNext(stateConvertable)
                    return
                }
                switch (behavior, stateConvertable.viewModelState) {
                case (.`default`, .loaded(let loadedValue)):
                    observer?.onNext(stateConvertable)
                    onLoaded(loadedValue)
                case (.interceptLoaded, .loaded(let loadedValue)):
                    onLoaded(loadedValue)
                case (.interceptLoadedAndCompleteObserver, .loaded(let loadedValue)):
                    observer?.onCompleted()
                    onLoaded(loadedValue)
                default: observer?.onNext(stateConvertable)
                }
            },
            onError: { error in
                observer?.onError(error)
            },
            onCompleted: {
                observer?.onCompleted()
            }
        )
    }

}

public enum ViewModelBindingBehaviour {
    case `default`
    case interceptLoaded
    case interceptLoadedAndCompleteObserver
}

extension ObservableType  {
    public func filterMap<T>(with transformation: @escaping (Element) -> T?)  -> Observable<T> {
        return map { element -> T? in
            guard let transformed = transformation(element) else {
                return nil
            }
            return transformed
        }.filterNil()
    }
}

extension ObservableType where Element: LoadableType  {

    public func mapLoaded() -> Observable<Element.LoadedType> {
        return self.map { element -> Element.LoadedType? in
            return element.loaded
        }.filterNil()
    }

    // Swallows errors and loaded state
    public func filterNotLoaded() -> Observable<Element> {
        return self.map { element -> Element? in
            guard element.loaded != nil else {
                return nil
            }
            return element
        }.filterNil()
    }

    // NOTE: Will complete. Careful with using bind.
    public func takeUntilFirstLoaded() -> Observable<Element> {
        return self.takeUntil(.inclusive) { element -> Bool in
            return element.loaded != nil
        }
    }
}

extension BehaviorSubject where Element: LoadableType {
    public var loadedValue: Element.LoadedType? {
        return safeValue?.loaded
    }

}
