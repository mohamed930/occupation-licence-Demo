//
//  BaseAPI.swift
//  occupation
//
//  Created by Mohamed Ali on 09/10/2021.
//

import UIKit
import Alamofire

class BaseAPI<T:TargetType> {
    
    func fetchData<M:Decodable> (Target:T, ClassName:M.Type, completion:@escaping (Result<M?,NSError>) -> ()) {
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        let params = buildParams(task: Target.task)
        
        AF.request((Target.baseURL + Target.path), method: method, parameters: params.0, encoding: params.1, headers: headers).responseJSON { (response) in
            
            print(response.value ?? "No response")
            
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                completion(.failure(NSError()))
                return
            }
            
            if statusCode == 200 || statusCode == 201 {
                
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                guard let theJSONData =  try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message])
                    completion(.failure(error))
                    return
                }
                
                completion(.success(responseObj))
                
            }
            else {
                // ADD Custom Error
                
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }

                guard let theJSONData =  try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }

                guard let responseObj = try? JSONDecoder().decode(ErrorResponse.self , from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message])
                    completion(.failure(error))
                    return
                }

                if responseObj.status == -1 {
                    
                    guard let distance = responseObj.error.distanceMeter else {
                        
                        ErrorMessage.ResponseMessgae = responseObj.error.messageAra
                        
                        let error = NSError(domain: Target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.ResponseMessgae!])
                        
                        completion(.failure(error))
                        
                        return
                    }
                    
                    ErrorMessage.distanceMeterMessage = distance
                    
                    let error = NSError(domain: Target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.distanceMeterMessage!])
                    
                    completion(.failure(error))
                    
                }
                print("Error in Fetching Data")
            }
            
        }
    }
    
    func fetchDataWithImage<M:Decodable>(Target:T, ClassName:M.Type,imgKey: String ,img: UIImage, params: [String: Any] ,completion:@escaping (Result<M?,NSError>) -> ()) {
        
        let date = Date()
        
        //Set Your URL
        let api_url = Target.baseURL + Target.path
        guard let url = URL(string: api_url) else {
            return
        }
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        
        urlRequest.headers = headers
        urlRequest.method = method
    
//        urlRequest.httpMethod = Target.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        //Set Your Parameter
        let params = params

        //Set Image Data
        let imgData = img.jpegData(compressionQuality: 0.5)!

       // Now Execute
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key )
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                }
                if let temp = value as? Double {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? [[String:String]] {
                    
                    var arr = Array<String>()
                    
                    for i in temp {
                        let dat = try? JSONSerialization.data(withJSONObject: i, options: .prettyPrinted)
                        
                        let str = String(data: dat!, encoding: String.Encoding.utf8)
                        
                        arr.append(str!)
                    }
                    
                    arr.forEach({element in
                        let keyObj = key + "[]"
                        
                        multiPart.append(element.data(using: .utf8)!, withName: keyObj)
                    })
                    
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
                
//                if value is [[String: String]] {
//                    print("F: \(value)")
//
//                    if let arr = value as? [[String:String]],
//                       let dat = try? JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted),
//                       let str = String(data: dat, encoding: String.Encoding.utf8) {
//                        print("F: Entered here \(str)")
//                        multiPart.append((str).data(using: String.Encoding.utf8)!, withName: key)
//                    }
//
//                }
            }
            multiPart.append(imgData, withName: imgKey, fileName:  date.StringDate() + ".jpeg", mimeType: "image/jpeg")
        }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Precentage: \(progress.completedUnitCount / progress.totalUnitCount * 100)%")
//                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { response in
                
                guard let statusCode = response.response?.statusCode else {
                    // ADD Custom Error
                    completion(.failure(NSError()))
                    return
                }
                
                if statusCode == 200 || statusCode == 201 {
                    
                    guard let jsonResponse = try? response.result.get() else {
                        // ADD Custom Error
                        let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                        completion(.failure(error))
                        return
                    }
                    
                    guard let theJSONData =  try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                        // ADD Custom Error
                        let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                        completion(.failure(error))
                        return
                    }
                    
                    guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                        // ADD Custom Error
                        let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message])
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(responseObj))
                    
                }
                else {
                    // ADD Custom Error
                    
                    guard let jsonResponse = try? response.result.get() else {
                        // ADD Custom Error
                        let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                        completion(.failure(error))
                        return
                    }

                    guard let theJSONData =  try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                        // ADD Custom Error
                        let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                        completion(.failure(error))
                        return
                    }

                    guard let responseObj = try? JSONDecoder().decode(ErrorResponse.self , from: theJSONData) else {
                        // ADD Custom Error
                        let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message])
                        completion(.failure(error))
                        return
                    }

                    if responseObj.status == -1 {
//                        print("F: \(responseObj.error.messageEng)")
                        ErrorMessage.ResponseMessgae = responseObj.error.messageAra
                        let error = NSError(domain: Target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.ResponseMessgae!])
                        completion(.failure(error))
                    }
                }
            })
        
    }
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
    
}
