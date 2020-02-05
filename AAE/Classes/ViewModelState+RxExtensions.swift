//  Created by Axel Ancona Esselmann on 1/23/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift
import RxOptional
import RxCocoa
import RxOptional

public typealias ObservableState<T> = Observable<ViewModelState<T>>
public typealias DrivableState<T> = Driver<ViewModelState<T>>
public typealias BehaviourState<T> = BehaviorSubject<ViewModelState<T>>
public typealias PublishState<T> = PublishSubject<ViewModelState<T>>

public typealias ButtonDriver = Driver<Void>
public typealias ButtonDrivable = ControlEvent<Void>

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

extension ObservableConvertibleType {
    public func asDrivableState<T>(startWith startingState: ViewModelState<T>) -> DrivableState<T> where Element == ViewModelState<T> {
        let driver = asDriver(onErrorRecover: {
            .just(.error($0))
        })
        return driver.startWith(startingState)
    }

    public func asDrivableState(startWith startingState: ViewModelState<Element>) -> DrivableState<Element> {
        return asObservable()
            .map { .loaded($0) }
            .asDriver(onErrorJustReturn: .error(AAError.unknown))
    }

    public func asDrivableState<T>(startWith maybeStartingState: ViewModelState<T>? = nil) -> DrivableState<T> where Element == ViewModelState<T> {
        let driver = asDriver(onErrorRecover: {
            .just(.error($0))
        })
        if let statingState = maybeStartingState {
            return driver.startWith(statingState)
        } else {
            return driver
        }
    }
}

extension Observable {
    public func with<T>(_ instance: T?) -> Observable<(Element, T)> {
        guard let instance = instance else {
            return .empty()
        }
        return map { element -> (Element, T) in
            return (element, instance)
        }
    }

    public func with<T, O1, O2>(_ instance: T?) -> Observable<(O1, O2, T)> where Element == (O1, O2) {
        guard let instance = instance else {
            return .empty()
        }
        return map { ($0.0, $0.1, instance) }
    }

    public func with<T, O1, O2, O3>(_ instance: T?) -> Observable<(O1, O2, O3, T)> where Element == (O1, O2, O3) {
        guard let instance = instance else {
            return .empty()
        }
        return map { ($0.0, $0.1, $0.2, instance) }
    }

    public func with<T, O1, O2, O3, O4>(_ instance: T?) -> Observable<(O1, O2, O3, O4, T)> where Element == (O1, O2, O3, O4) {
        guard let instance = instance else {
            return .empty()
        }
        return map { ($0.0, $0.1, $0.2, $0.3, instance) }
    }

    public func with<T, O1, O2, O3, O4, O5>(_ instance: T?) -> Observable<(O1, O2, O3, O4, O5, T)> where Element == (O1, O2, O3, O4, O5) {
        guard let instance = instance else {
            return .empty()
        }
        return map { ($0.0, $0.1, $0.2, $0.3, $0.4, instance) }
    }

    public func with<T, O1, O2, O3, O4, O5, O6>(_ instance: T?) -> Observable<(O1, O2, O3, O4, O5, O6, T)> where Element == (O1, O2, O3, O4, O5, O6) {
        guard let instance = instance else {
            return .empty()
        }
        return map { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, instance) }
    }

    public func filterNils<O1, O2, O3>() -> Observable<(O1, O2, O3)> where Element == (O1?, O2?, O3?) {
        return map { (tuple: (O1?, O2?, O3?)) -> (O1, O2, O3)? in
            guard let t0 = tuple.0, let t1 = tuple.1, let t2 = tuple.2 else {
                return nil
            }
            return (t0, t1, t2)
        }.filterNil()
    }
}

extension ObservableType {

    /// Exposes the loaded state of a ViewModelState and provides ability to give defaults for non-loaded states
    public func unpack<T>(
        whenInactive: T? = nil,
        whenLoading: T? = nil,
        whenError: T? = nil
    ) -> Observable<T?> where Element == ViewModelState<T> {
        return map { state -> T? in
            switch state {
            case .inactive:
                return whenInactive
            case .loading:
                return whenLoading
            case .loaded(let unpacked):
                return unpacked
            case .error:
                return whenError
            }
        }
    }

    public func unpack<T>(whenNotLoaded: T) -> Observable<T> where Element == ViewModelState<T> {
        return unpack(
            whenInactive: whenNotLoaded,
            whenLoading: whenNotLoaded,
            whenError: whenNotLoaded
        ).filterNil()
    }
}

extension Driver {
    /// Exposes the loaded state of a ViewModelState and provides ability to give defaults for non-loaded states
    public func unpack<T>(
        whenInactive: T? = nil,
        whenLoading: T? = nil,
        whenError: T? = nil
    ) -> Driver<T?> where Element == ViewModelState<T> {
        return map { state -> T? in
            switch state {
            case .inactive:
                return whenInactive
            case .loading:
                return whenLoading
            case .loaded(let unpacked):
                return unpacked
            case .error:
                return whenError
            }
        }.asDriver(onErrorJustReturn: whenError)
    }

    public func unpack<T>(whenNotLoaded: T) -> Driver<T> where Element == ViewModelState<T> {
        return unpack(
            whenInactive: whenNotLoaded,
            whenLoading: whenNotLoaded,
            whenError: whenNotLoaded
        ).filterNil()
    }

}

extension Driver {
    public func mapDriver<Result>(_ selector: @escaping (Self.Element) -> Result) -> Driver<Result>
    {
        return map(selector)
            .map { $0 as Result? }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
    }
}
