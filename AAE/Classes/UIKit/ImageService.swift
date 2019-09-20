//  Created by Axel Ancona Esselmann on 9/11/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

#if os(iOS)

import UIKit
import RxSwift
import SDWebImage

public protocol ImageServing {
    func image(for url: URL) -> Single<UIImage>
    func prefetch(_ url: URL)
    func prefetch(_ urls: [URL])
}

public enum ImageError: Error {
    case error
    case couldNotLoadUrl(URL)
}

public class ImageService: ImageServing {

    public init() {}
    
    struct ErrorStrings {
        static let malformedImageUrlError = "Malformed image URL"
        static let genericRequestError = "Could not retrieve image for URL"
        static let noImageError = "No image returned for URL"
        static let memoryReleaseError = "ImageCache instance was released from memory before it could return"
    }

    private let cache = SDWebImageManager.shared
    private let prefetcher = SDWebImagePrefetcher.shared

    public func prefetch(_ url: URL) {
        prefetcher.prefetchURLs([url])
    }

    public func prefetch(_ urls: [URL]) {
        prefetcher.prefetchURLs(urls)
    }

    public func image(for url: URL) -> Single<UIImage> {
        return Single<UIImage>.create(subscribe: { [weak self] subscriber -> Disposable in
            let disposable = Disposables.create()

            guard let cache = self?.cache else {
                let error = ImageError.error
                subscriber(.error(error))
                return disposable
            }

            cache.loadImage(
                with: url,
                options: .highPriority,
                progress: nil) { (maybeImage: UIImage?, _, _, _, _, _) in
                    guard let image = maybeImage else {
                        let error = ImageError.error
                        subscriber(.error(error))
                        return
                    }
                    subscriber(.success(image))
            }
            return disposable
        })
    }
}

public extension UIImageView {

    func load(from url: URL?, with service: ImageServing) {
        guard let url = url else {
            return
        }
        let _ = service.image(for: url).subscribe(onSuccess: { [weak self] image in
            self?.image = image
        }) { Error in
            print("Could not load image asset from \(url.absoluteString)")
        }
    }

    func loadWithStatusReport(url: URL?, with service: ImageServing) -> ObservableState<Void> {
        guard let url = url else {
            return ObservableState<Void>.just(.error(ImageError.error))
        }
        return ObservableState<Void>.create( { [weak self] observer -> Disposable in
            let disposable = Disposables.create()
            observer.onNext(.loading)
            let _ = service.image(for: url).subscribe(onSuccess: { [weak self] image in
                self?.image = image
                observer.onNext(.loaded(()))
            }) { error in
                observer.onNext(.error(ImageError.couldNotLoadUrl(url)))
            }
            return disposable
        })
    }

}

#endif
