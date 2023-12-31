import Foundation

class APIService {
    let baseURL = "https://us-central1-greyhoundhub-852eb.cloudfunctions.net"

    func getAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let endpoint = "/api/users" // Assuming this is the endpoint to fetch all users
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    // Assuming the server returns an array of user data
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        completion(.success(jsonArray))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data formatted incorrectly"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    
    func getUser(by username: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let endpoint = "/api/users/\(username)"
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(.success(json))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data formatted incorrectly"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func createUser(dropoff: String, ghName: String, isWorker: Bool, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/api/users"
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["dropoff": dropoff, "ghName": ghName, "currOrder": nil, "isWorker": isWorker, "username": username, "password": password] as [String : Any?]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let statusError = NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with status code \(httpResponse.statusCode)"])
                    completion(.failure(statusError))
                    return
                }
                
                completion(.success(()))
            }
        }.resume()
    }
    
    func updateOrder(username: String, newOrder: String?, completion: @escaping (Result<Void, Error>) -> Void) {
            let endpoint = "/api/users/\(username)"
            guard let url = URL(string: baseURL + endpoint) else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = ["currOrder": newOrder] as [String: Any?]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            URLSession.shared.dataTask(with: request) { (_, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        let statusError = NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with status code \(httpResponse.statusCode)"])
                        completion(.failure(statusError))
                        return
                    }
                    
                    completion(.success(()))
                }
            }.resume()
        }
    
    func deleteUser(username: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let endpoint = "/users/\(username)"
            guard let url = URL(string: baseURL + endpoint) else {
                completion(.failure(URLError(.badURL)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { (_, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        let statusError = NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with status code \(httpResponse.statusCode)"])
                        completion(.failure(statusError))
                        return
                    }
                    
                    completion(.success(()))
                }
            }.resume()
        }
}
