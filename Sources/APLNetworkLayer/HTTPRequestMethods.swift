//
//  HTTPRequestMethods.swift
//  APLNetworkLayer
//
//  Created by apploft on 15.01.2020.
//  Copyright © 2020 apploft GmbH. All rights reserved.

public protocol HTTPRequestMethods {
    func GET(relativeUrl: String,
             queryParameters: HttpQueryParameters?,
             headers: HTTPHeaders?,
             cachePolicy: URLRequest.CachePolicy?,
             timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func GET(absoluteURL: URL,
             queryParameters: HttpQueryParameters?,
             headers: HTTPHeaders?,
             cachePolicy: URLRequest.CachePolicy?,
             timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func POST(relativeUrl: String,
              queryParameters: HttpQueryParameters?,
              headers: HTTPHeaders?,
              body: Data,
              cachePolicy: URLRequest.CachePolicy?,
              timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func POST(absoluteURL: URL,
              queryParameters: HttpQueryParameters?,
              headers: HTTPHeaders?,
              body: Data,
              cachePolicy: URLRequest.CachePolicy?,
              timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func PUT(relativeUrl: String,
             queryParameters: HttpQueryParameters?,
             headers: HTTPHeaders?,
             body: Data,
             cachePolicy: URLRequest.CachePolicy?,
             timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func PUT(absoluteURL: URL,
             queryParameters: HttpQueryParameters?,
             headers: HTTPHeaders?,
             body: Data,
             cachePolicy: URLRequest.CachePolicy?,
             timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func DELETE(relativeUrl: String,
                queryParameters: HttpQueryParameters?,
                headers: HTTPHeaders?,
                body: Data?,
                cachePolicy: URLRequest.CachePolicy?,
                timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func DELETE(absoluteURL: URL,
                queryParameters: HttpQueryParameters?,
                headers: HTTPHeaders?,
                body: Data?,
                cachePolicy: URLRequest.CachePolicy?,
                timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func PATCH(relativeUrl: String,
               queryParameters: HttpQueryParameters?,
               headers: HTTPHeaders?,
               body: Data,
               cachePolicy: URLRequest.CachePolicy?,
               timeoutInterval: TimeInterval?) -> HTTPRequestMethod

    func PATCH(absoluteURL: URL,
               queryParameters: HttpQueryParameters?,
               headers: HTTPHeaders?,
               body: Data,
               cachePolicy: URLRequest.CachePolicy?,
               timeoutInterval: TimeInterval?) -> HTTPRequestMethod
}

extension HTTPRequestMethods where Self: HTTPClient {

    public func GET(relativeUrl: String,
             queryParameters: HttpQueryParameters? = nil,
             headers: HTTPHeaders? = nil,
             cachePolicy: URLRequest.CachePolicy? = nil,
             timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = GET(relativeUrl: relativeUrl,
                           queryParameters: queryParameters,
                           headers: headers,
                           cachePolicy: cachePolicy,
                           timeoutInterval: timeoutInterval,
                           startTaskManually: true,
                           completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func GET(absoluteURL: URL,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = GET(absoluteUrl: absoluteURL,
                           queryParameters: queryParameters,
                           headers: headers,
                           cachePolicy: cachePolicy,
                           timeoutInterval: timeoutInterval,
                           startTaskManually: true,
                           completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func POST(relativeUrl: String,
                     queryParameters: HttpQueryParameters? = nil,
                     headers: HTTPHeaders? = nil,
                     body: Data,
                     cachePolicy: URLRequest.CachePolicy? = nil,
                     timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = POST(relativeUrl: relativeUrl,
                            queryParameters: queryParameters,
                            headers: headers,
                            body: body,
                            cachePolicy: cachePolicy,
                            timeoutInterval: timeoutInterval,
                            startTaskManually: true,
                            completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func POST(absoluteURL: URL,
                     queryParameters: HttpQueryParameters? = nil,
                     headers: HTTPHeaders? = nil,
                     body: Data,
                     cachePolicy: URLRequest.CachePolicy? = nil,
                     timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = POST(absoluteUrl: absoluteURL,
                            queryParameters: queryParameters,
                            headers: headers,
                            body: body,
                            cachePolicy: cachePolicy,
                            timeoutInterval: timeoutInterval,
                            startTaskManually: true,
                            completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func PUT(relativeUrl: String,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    body: Data,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = PUT(relativeUrl: relativeUrl,
                           queryParameters: queryParameters,
                           headers: headers,
                           body: body,
                           cachePolicy: cachePolicy,
                           timeoutInterval: timeoutInterval,
                           startTaskManually: true,
                           completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func PUT(absoluteURL: URL,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    body: Data,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = PUT(absoluteUrl: absoluteURL,
                           queryParameters: queryParameters,
                           headers: headers,
                           body: body,
                           cachePolicy: cachePolicy,
                           timeoutInterval: timeoutInterval,
                           startTaskManually: true,
                           completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func PATCH(relativeUrl: String,
                      queryParameters: HttpQueryParameters? = nil,
                      headers: HTTPHeaders? = nil,
                      body: Data,
                      cachePolicy: URLRequest.CachePolicy? = nil,
                      timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = PATCH(relativeUrl: relativeUrl,
                             queryParameters: queryParameters,
                             headers: headers,
                             body: body,
                             cachePolicy: cachePolicy,
                             timeoutInterval: timeoutInterval,
                             startTaskManually: true,
                             completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func PATCH(absoluteURL: URL,
                      queryParameters: HttpQueryParameters? = nil,
                      headers: HTTPHeaders? = nil,
                      body: Data,
                      cachePolicy: URLRequest.CachePolicy? = nil,
                      timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = PATCH(absoluteUrl: absoluteURL,
                             queryParameters: queryParameters,
                             headers: headers,
                             body: body,
                             cachePolicy: cachePolicy,
                             timeoutInterval: timeoutInterval,
                             startTaskManually: true,
                             completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func DELETE(relativeUrl: String,
                       queryParameters: HttpQueryParameters? = nil,
                       headers: HTTPHeaders? = nil,
                       body: Data? = nil,
                       cachePolicy: URLRequest.CachePolicy? = nil,
                       timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = DELETE(relativeUrl: relativeUrl,
                              queryParameters: queryParameters,
                              headers: headers,
                              body: body,
                              cachePolicy: cachePolicy,
                              timeoutInterval: timeoutInterval,
                              startTaskManually: true,
                              completionHandler: networkCompletionHandler(httpRequestMethod))

        httpRequestMethod.httpTask = httpTask

        return httpRequestMethod
    }

    public func DELETE(absoluteURL: URL,
                       queryParameters: HttpQueryParameters? = nil,
                       headers: HTTPHeaders? = nil,
                       body: Data? = nil,
                       cachePolicy: URLRequest.CachePolicy? = nil,
                       timeoutInterval: TimeInterval? = nil) -> HTTPRequestMethod {
        let httpRequestMethod = HTTPRequestMethodConcrete()
        let httpTask = DELETE(absoluteUrl: absoluteURL,
                              queryParameters: queryParameters,
                              headers: headers,
                              body: body,
                              cachePolicy: cachePolicy,
                              timeoutInterval: timeoutInterval,
                              startTaskManually: true,
                              completionHandler: networkCompletionHandler(httpRequestMethod))

           httpRequestMethod.httpTask = httpTask

           return httpRequestMethod
    }

    // MARK: - Private

    private func networkCompletionHandler(_ httpRequestMethod: HTTPRequestMethodConcrete) -> NetworkCompletionHandler {
        return { result in
            switch result {
            case .success(let httpResponse):
                httpRequestMethod.callStatusCodeHandler(httpResponse)
            case .failure(let error):
                httpRequestMethod.catchErrorHandler?(nil, error, nil)
            }
        }
    }
}
