# NetworkLayer

APLNetworkLayer is a convenient interface for Apple's network framework that provides commonly used features.
  
This network layer is a wrapper for Apple's network classes and functions that allows to use it conveniently made with Swift. It provides all common features needed for network calls in iOS development. 


List of features of the APLNetworkLayer: 

- [x] Requests can be created with a base URL + relative URL or an absolute URL 
- [x] Create different types of requests: GET, POST, PUT, DELETE
- [x] Set a global request timeout or a specific timeout for individual requests
- [x] Built with interfaces to be mockable for testing
- [x] Accept-Language header is created of the preferred languages of the device by default
- [x] Automatic retry of the requests if they failed
- [x] Provides an interface to perform authentication, token refresh or similar tasks
- [x] Observer on network reachability and status
- [x] No usage of external libraries, no dependencies
- [x] Convenience request warpper allowing PromiseKit-style completion handler chaining 


## Table of Contents

* [Installation](#installation)
    * [CocoaPods](#cocoapods)
* [Usage](#usage)
* [Architecture](#architecture)
* [License](#license)

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Add this to your Podfile:

```ruby
pod "APLNetworkLayer"
```

## Usage

Create a client configuration and an HTTP client with the HTTP factory: 

```swift
guard let baseUrl = URL(string: "https://example.com/example") else { return }

// example for default header, optional parameter
let defaultHeader = ["Application-Id": "123456Abc"]

guard let clientConfiguration = HTTPFactory.createConfiguration(baseURL: baseUrl, defaultHeader: defaultHeader) else { return }

let httpClient = HTTPFactory.createClient(configuration: clientConfiguration)
```

Once the client has been created it can be used to create and execute HTTP requests: 

```swift
guard let request = httpClient.GETRequest(relativeUrl: relativeUrl) else {
    let error = NSError(domain: "GetRequest", code: 0, userInfo: ["description": "Could not create get request with relative url \(relativeUrl)."])
    completion(HTTPResult.failure(error))
    return
}
 
let task = httpClient.createHTTPTask(urlRequest: request.urlRequest) { [weak self] (result: APLNetworkLayer.HTTPResult<HTTPResponse>) in
    switch result {
    case .success(let httpResponse):
        self?.handleSuccess(httpResponse: httpResponse, completion: completion)
    case .failure(let error):
        completion(Result.failure(error))
    }
}
```

Or create and execute the request at once: 

```swift
let task = httpClient.GET(relativeUrl: relativeUrl) { [weak self] (result: APLNetworkLayer.HTTPResult<HTTPResponse>) in
    switch result {
    case .success(let httpResponse):
        self?.handleSuccess(httpResponse: httpResponse, completion: completion)
    case .failure(let error):
        completion(Result.failure(error))
    }
}
```

Using of the request convenience methods

The user has to make sure the used range make sense and do not overlap etc.

```swift

httpClient.GET(relativeUrl: "...")
          .statusCodeSuccess { (data, _) in
    // handle data on success 
}.catch { (data, _, _) in
    // on any client or server error execute this block
}.start()

httpClient.GET(relativeUrl: "...)
          .statusCode(200) { // on status code 200 execute this block }
          .statusCode(401) { // on status code 401 execute this block }
          .statusCode(..<410) { // on all status codes uo to 410 execute this block }
          .statusCode(500...599) { // on status codes between 500 and 599 execute this block }
          .anyStatusCode() { // on any status code not captured by other handlers execute this block }
          .catch { // called on any error network or http status code within 400-599  }           
          .start()
```

This can also be done with absolute URLs and different types of requests. You are able to fully configure all parameters of the client configuration and the requests.


## Architecture

<img src="/Resources/NetworkLayer.png">

## License

**APLNetworkLayer** is available under the MIT license. See the [LICENSE](hhttps://github.com/apploft/APLNetworkLayer/blob/master/LICENSE) file for more info.
