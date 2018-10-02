# NetworkLayer

APLNetworkLayer is a convenient interface for Apple's network framework that provides commonly used features.
  
This network layer is a wrapper for Apple's network classes and functions that allows to use it conveniently made with Swift. 
It is intentionally not using cocoapods or other dependency managers in order to keep things simple and making extension and updating easier.


# Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Add this to your Podfile:

```ruby
pod "APLNetworkLayer"
```

# Usage

List of features of the network layer: 

- [x] Requests can be created with a base URL + relative URL or an absolute URL 
- [x] Create different types of requests: GET, POST, PUT, DELETE
- [x] Batch requests
- [x] Set a global request timeout or a specific timeout for individual requests
- [x] Built with interfaces to be mockable for testing
- [x] Accept-Language header is created of the preferred languages of the device by default
- [x] Automatic retry of the requests if they failed
- [x] Provides an interface to perform authentication, token refresh or similar tasks
- [x] Observer on network reachability and status
- [x] No usage of external libraries, no dependencies


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
            completion(Result.failure(error))
            return
        }
        
        let task = httpClient.createHTTPTask(urlRequest: request.urlRequest) { [weak self] (result: APLNetworkLayer.Result<HTTPResponse>) in
            switch result {
            case .success(let httpResponse):
                self?.handleSuccess(httpResponse: httpResponse, completion: completion)
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        
        task.resume()

```

Or create and execute the request at once: 

```swift
let task = httpClient.GET(relativeUrl: relativeUrl) { [weak self] (result: APLNetworkLayer.Result<HTTPResponse>) in
            switch result {
            case .success(let httpResponse):
                self?.handleSuccess(httpResponse: httpResponse, completion: completion)
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        
        task.resume()
```

This can also be done with absolute URLs and different types of requests. You are able to fully configure all parameters of the client configuration and the requests.


Architecture of APLNetworkLayer:

<img width="320" src="https://raw.githubusercontent.com/apploft/ExpandableLabel/master/Resources/MoreLessExpand.gif">


# License
ExpandableLabel is available under the MIT license. See the LICENSE file for more info.