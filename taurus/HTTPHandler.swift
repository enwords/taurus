import Foundation

class HTTPHandler {
    static func get(url: URL, completionHandler: @escaping (Data?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                print("request completed with code: \(statusCode)")
                if (statusCode == 200) {
                    print("return to completion handler with the data")
                    completionHandler(data as Data)
                }
            } else if let error = error {
                print("***There was an error making the HTTP request***")
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
        task.resume()
    }

    static func post(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let session = URLSession.shared
        let task = session.dataTask(
                with: request as URLRequest,
                completionHandler: { data, response, error in
                    guard error == nil else {
                        return
                    }

                    guard let data = data else {
                        return
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(
                                with: data,
                                options: .mutableContainers
                        ) as? [String: Any] {
                            print(json)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
        )
        task.resume()
    }
}
