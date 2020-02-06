//  Created by Axel Ancona Esselmann on 7/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift
import RxRelay

public extension ObservableType {
    func subscribeOnNext(_ subscription: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: subscription, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    func toVoid() -> Observable<Void> {
        return self.map { _ in Void() }
    }
}

public extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    func toVoid() -> RxSwift.Single<Void> {
        return self.map { _ in Void() }
    }
}

public extension ObservableType  {
    var asObserver: AnyObserver<Element>? {
        return (self as? BehaviorSubject<Element>)?.asObserver()
    }

    var asBehaviorSubject: BehaviorSubject<Element>? {
        return self as? BehaviorSubject<Element>
    }

    func next(_ element: Self.Element) {
        guard let observer = asObserver else {
            Debug.log("Not an observer", group: DebugGroup.warning)
            return
        }
        observer.onNext(element)
    }

    func bind<O>(to observer: O?) -> Disposable where O : ObserverType, Self.Element == O.Element {
        guard let observer = observer else {
            Debug.log("Not an observer", group: DebugGroup.warning)
            return Disposables.create()
        }
        return self.bind(to: observer)
    }

}

public extension BehaviorSubject {
    var safeValue: Element? {
        return try? value()
    }

}

public extension ObservableType {
    func observeOnMain() -> RxSwift.Observable<Self.Element> {
        return self.observeOn(MainScheduler.asyncInstance)
    }

    func subscribeOnMain() -> RxSwift.Observable<Self.Element> {
        return self.subscribeOn(MainScheduler.asyncInstance)
    }

}

extension ObservableType {
    public static var deinitialized: RxSwift.Observable<Self.Element> {
        return Observable<Self.Element>.error(AAError.deinitialized)
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func appendUnique(_ element: Element.Element, where comparison: (Element.Element, Element.Element) -> Bool) {
        accept(value.appendedUnique(element, where: comparison))
    }
}
