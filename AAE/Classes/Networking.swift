//  Created by Axel Ancona Esselmann on 9/9/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Alamofire
import RxSwift

public class Networking {

    public enum DebugGroup: String, PrefixedDebugPrintable {
        case networking

        public var prefix: String {
            switch self {
            case .networking:
                return "📶"
            }
        }
    }

    public enum NetworkingError: Error {
        case notAuthorized
        case typeMismatch
    }

    public enum HeaderKeys: String, StringRepresentable {
        case contentType = "Content-Type"
        case urn = "urn"
        case user = "User"
        case jwt = "JWT"
        case password = "Password"
    }

    public enum HeaderValues: String, StringRepresentable {
        case json = "application/json"
    }

    public var noSSLWhitelist: [String] = []

    private lazy var session: Session = {
        var evaluators = noSSLWhitelist.reduce(into: [String: ServerTrustEvaluating](), { $0[$1] = DisabledEvaluator() })
        let manager = ServerTrustManager(evaluators: evaluators)
        return Session(serverTrustManager: manager)
    }()

    private static let coder = JsonCoder()

    public init() { }

    public func request(url: URL, auth: AuthData?) -> Single<Data?> {
        guard let auth = auth else {
            return Single.error(NetworkingError.notAuthorized)
        }
        let headers = self.headers(auth: auth)
        return request(url, headers: headers)
    }

    public func request<T>(url: URL, auth: AuthData?) -> Single<T> where T: Decodable {
        return self.request(url: url, auth: auth).flatMap { (data: Data?) -> Single<T> in
            return Networking.coder.decode(data)
        }
    }

    public func request<T>(type: T.Type, url: URL, auth: AuthData?) -> Single<T> where T: Decodable {
        return self.request(url: url, auth: auth).flatMap { (data: Data?) -> Single<T> in
            return Networking.coder.decode(data, to: type)
        }
    }

    public func request(_ url: URL, method: HTTPMethod? = .post, headers: HTTPHeaders, parameters: [String : Any]? = nil) -> Single<Data?> {
        Debug.log("Network Request: \(url.absoluteString)", group: DebugGroup.networking)
        return Single<Data?>.create(subscribe: { [weak self] subscriber -> Disposable in
            let disposeble = Disposables.create()
            guard let session = self?.session else {
                subscriber(.error(AAError.deinitialized))
                return disposeble
            }
            session.request(url.absoluteString, method: .get, parameters: parameters, headers: headers).response(completionHandler: { response in
                if let statusCode = response.response?.statusCode, statusCode == 403 {
                    subscriber(.error(NetworkingError.notAuthorized))
                    return
                }
                switch response.result {
                case .success(let data):
                    subscriber(.success(data))
                case .failure(let error):
                    subscriber(.error(error))
                }
            })
            return disposeble
        })
    }

    public func request<T>(type: T.Type, url: URL, method: HTTPMethod? = .post, headers headersDict: [String: String], parameters: [String : Any]? = nil) -> Single<T> where T: Decodable {
        let headers = HTTPHeaders(headersDict)
        return request(url, method: method, headers: headers, parameters: parameters).flatMap { (data: Data?) -> Single<T> in
            return Networking.coder.decode(data)
        }
    }

    private func headers(auth: AuthData?) -> HTTPHeaders {
        var headersDict: [HeaderKeys: String] = [
            HeaderKeys.contentType: HeaderValues.json.rawValue
        ]
        if let auth = auth {
            headersDict[HeaderKeys.user] = auth.urn.uuidString
            headersDict[HeaderKeys.jwt] = auth.jwt.stringValue
        }
        return HTTPHeaders(headersDict.withStringKeys)
    }

}

