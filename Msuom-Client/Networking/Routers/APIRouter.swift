//
//  APIRouter.swift
//
//  Created by MGAbouarab®
//

import Alamofire
import Foundation

protocol APIRouter: URLRequestConvertible {
    var method: HTTPMethod {get}
    var path: String {get}
    var parameters: APIParameters? {get}
    func send<T:Codable> (data: [UploadData]?, completion: @escaping (_ respons: T) -> Void)
}

extension APIRouter {
    
    private var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    //MARK: - Create Request -
    func asURLRequest() throws -> URLRequest {
        
        //MARK: - URL -
        var urlRequest = URLRequest(url: try Server.baseURL.asURL().appendingPathComponent(path))
        
        //MARK: - HTTTP Method -
        urlRequest.httpMethod = method.rawValue
        
        //MARK: - Common Headers -
        urlRequest.setValue(HTTPHeaderValues.applicationJson, forHTTPHeaderField: HTTPHeaderKeys.acceptType)
        urlRequest.setValue(HTTPHeaderValues.applicationJson, forHTTPHeaderField: HTTPHeaderKeys.contentType)
        urlRequest.setValue(Language.apiLanguage(), forHTTPHeaderField: HTTPHeaderKeys.lang)
        
        //MARK: - Token -
        if  let token = UserDefaults.accessToken, !token.trimWhiteSpace().isEmpty {
            urlRequest.setValue( HTTPHeaderValues.tokenBearer + token, forHTTPHeaderField: HTTPHeaderKeys.authentication)
        }
        
        //MARK: - Parameters -
        if let parameters = parameters?.compactMapValues({$0}) {
            urlRequest = try encoding.encode(urlRequest, with: parameters)
        }
        
        //MARK: - All Request data
        print("\n\n====================================\n🚀🚀FULL REQUEST COMPONENETS::: \n\n URL:: \(urlRequest.url?.absoluteString ?? "No URL Found") \n---------------------------------\n Method:: \(urlRequest.httpMethod ?? "No httpMethod") \n---------------------------------\n Header:: \n\((urlRequest.allHTTPHeaderFields ?? [:]).json()) \n---------------------------------\n Parameters:: \n\((parameters?.compactMapValues({$0}) ?? [:]).json()) \n\n====================================\n\n")
        
        return urlRequest
    }
    
    //MARK: - Send Request -
    func send<T:Codable> (data: [UploadData]? = nil, completion: @escaping (_ response: T) -> Void) {
        
        if let data = data {
            self.uploadToServerWith(data: data) { (respons: T?,errorType) in
                AppIndicator.shared.dismiss()
                if let respons = respons {
                    completion(respons)
                } else if let errorType = errorType {
                    switch errorType {
                    case .connectionError:
                        AppAlert.showInternetConnectionErrorAlert {
                            AppIndicator.shared.show(isGif: false)
                            self.send(data: data, completion: completion)
                        }
                    case .canNotDecodeData:
                        AppAlert.showSomethingError()
                    }
                }
            }
            return
        }
        AF.request(self).responseData { data in
            printApiResponse(data.data)
            self.handleResponse(data) { (respons: T?,errorType) in
                AppIndicator.shared.dismiss()
                if let respons = respons {
                    completion(respons)
                } else if let errorType = errorType {
                    switch errorType {
                    case .connectionError:
                        AppAlert.showInternetConnectionErrorAlert {
                            AppIndicator.shared.show(isGif: false)
                            self.send(data: nil, completion: completion)
                        }
                    case .canNotDecodeData:
                        AppAlert.showSomethingError()
                    }
                }
            }
        }
        
    }
    
    private func uploadToServerWith<T: Codable> (data: [UploadData], completion: @escaping (_ response: T?, _ errorType: APIErrors?) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            if let parameters = self.parameters?.compactMapValues({$0}) {
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            for item in data {
                multipartFormData.append(item.data, withName: item.name, fileName: item.fileName, mimeType: item.mimeType.rawValue)
            }
            
        }, with: self).uploadProgress(closure: { (progress) in
            print("the Progress is \(Int(progress.fractionCompleted*100)) %")
        }).responseData { data in
            printApiResponse(data.data)
            self.handleResponse(data, completion: completion)
        }
    }
    private func handleResponse<T: Codable>(_ response: AFDataResponse<Data>, completion: @escaping (_ respons: T?, _ errorType: APIErrors?) -> Void) {
        switch response.result {
        case .failure(_):
            completion(nil, .connectionError)
        case .success(let value):
            do {
                let decoder = JSONDecoder()
                
                let valueObject  = try decoder.decode(T.self, from: value)
                
                if let value = valueObject as? APIGlobalResponse {
                    switch value.key {
                    case .success:
                        completion(valueObject ,nil)
                    case .fail, .exception:
                        AppAlert.showErrorAlert(error: value.message)
                        completion(nil ,nil)
                    case .unauthenticated, .blocked:
                        UserDefaults.user = nil
                        UserDefaults.accessToken = nil
                        UserDefaults.isLogin = false
                        
                        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                        guard let window = window else {return}
                        
                        
                        if let topVC = window.topViewController() {
                            
                            if let _ = topVC.navigationController as? AuthNav {
                                AppAlert.showErrorAlert(error: value.message)
                            } else {
                                AppAlert.showErrorAlert(error: value.message)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    let vc = SplashVC.create()
                                    AppHelper.changeWindowRoot(vc: vc)
                                }
                            }
                            
                        } else {
                            AppAlert.showErrorAlert(error: value.message)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let vc = SplashVC.create()
                                AppHelper.changeWindowRoot(vc: vc)
                            }
                            let vc = SplashVC.create()
                            AppHelper.changeWindowRoot(vc: vc)
                        }
                        completion(nil ,nil)
                    case .needActive:
                        
                        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                        guard let window = window else {return}
                        
                        if let topVC = window.topViewController() {
                            if let phone = self.parameters?[AuthParameterKeys.loginKey.rawValue] as? String {
                                
                                
                                var isAuth: Bool = false
                                
                                if let _ = topVC.navigationController as? AuthNav {
                                    isAuth = true
                                }
                                
                                
                                
                                let vc = VerificationCodeVC.create(credential: phone, type: .activationInsideApp(isAuth: isAuth), countryKey: "")
                                topVC.show(vc, sender: nil)
                            }
                            completion(nil, nil)
                        } else {
                            completion(valueObject ,nil)
                        }
//                    case .exception:
//                        completion(nil, nil)
                    }
                } else {
                    completion(valueObject ,nil)
                }
                
            } catch DecodingError.keyNotFound(let key, let context) {
                Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                print(context.codingPath)
                completion(nil, .canNotDecodeData)
            } catch DecodingError.valueNotFound(let type, let context) {
                Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                print(context.codingPath)
                completion(nil, .canNotDecodeData)
            } catch DecodingError.typeMismatch(let type, let context) {
                Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                print(context.codingPath)
                completion(nil, .canNotDecodeData)
            } catch DecodingError.dataCorrupted(let context) {
                Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                print(context.codingPath)
                completion(nil, .canNotDecodeData)
            } catch let error as NSError {
                NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                completion(nil, .canNotDecodeData)
            }
        }
    }
    
    //MARK: - Helper Methods -
    
    private func printApiResponse(_ responseData: Data?) {
    #if DEBUG
        guard let responseData = responseData else {
            print("\n\n====================================\n⚡️⚡️RESPONSE IS::\n" ,responseData as Any, "\n====================================\n\n")
            return
        }
        
        if let object = try? JSONSerialization.jsonObject(with: responseData, options: []),
           let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]), let JSONString = String(data: data, encoding: String.Encoding.utf8) {
            print("\n\n====================================\n⚡️⚡️RESPONSE IS::\n" ,JSONString, "\n====================================\n\n")
            return
        }
        print("\n\n====================================\n⚡️⚡️RESPONSE IS::\n" ,responseData, "\n====================================\n\n")
    #endif
    }
    
    
}
