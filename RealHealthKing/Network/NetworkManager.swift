//
//  NetworkManager.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/13/24.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

struct NetworkManager {
    
    static func createLogin(query: LoginQuery) -> Single<Result<TokenModel, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: TokenModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(.success(loginModel)))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = LoginError(rawValue: statusCode) {
                                single(.success(.failure(AppError.loginError(netError))))
                            }
                            single(.success(.failure(AppError.unowned)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func duplicateEmail(model: EmailCheckModel) -> Single<Result<Bool, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.emailCheck(model: model).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: String.self) { response in
                        switch response.result {
                        case .success(_):
                            single(.success(.success(true)))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = DuplicateError(rawValue: statusCode) {
                                single(.success(.failure(AppError.duplicateError(netError))))
                            } else if let statusCode = response.response?.statusCode, statusCode == 200 {
                                single(.success(.success(true)))
                            }
                            single(.success(.failure(AppError.unowned)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func createAccount(query: UserQuery) -> Single<Result<UserQuery, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.signUp(model: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: UserQuery.self) { response in
                        switch response.result {
                        case .success(let userData):
                            single(.success(.success(userData)))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = SignUpError(rawValue: statusCode) {
                                single(.success(.failure(AppError.signUpError(netError))))
                            }
                            single(.success(.failure(AppError.unowned)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func fetchPosts(completionHandler: @escaping (Result<[Posts], AppError>) -> Void) {
        do {
            let urlRequest = try Router.postFetch.postURLRequest()
            
            AF.request(urlRequest, interceptor: NetworkInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PostsModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        completionHandler(.success(data.data))
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                            completionHandler(.failure(AppError.networkError(netError)))
                        } else if let statusCode = response.response?.statusCode, let netError = FetchPostError(rawValue: statusCode) {
                            completionHandler(.failure(AppError.fetchPostError(netError)))
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
    
    static func uploadImage(images: [Data], completionHandler: @escaping (Result<[String], AppError>) -> Void) {
        
        AF.upload(multipartFormData: { multipartForm in
            for image in images {
                multipartForm.append(image, withName: "files", fileName: "images", mimeType: "image/png")
            }
            
        }, to: Router.imageUpload.baseURL + Router.imageUpload.version + Router.imageUpload.path, headers: HTTPHeaders(Router.imageUpload.header), interceptor: NetworkInterceptor())
        .responseDecodable(of: ImageFilesModel.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data.files))
            case .failure(_):
                if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                    completionHandler(.failure(AppError.networkError(netError)))
                } else if let statusCode = response.response?.statusCode, let netError = ImageUploadError(rawValue: statusCode) {
                    completionHandler(.failure(AppError.imageUploadError(netError)))
                }
            }
        }
        
    }
    
    static func uploadPostContents(model: PostTest, completionHandler: @escaping (Result<Posts, AppError>) -> Void) {
        
        do {
            
            let urlRequest = try Router.posting(model: model).postURLRequest()
            
            AF.request(urlRequest, interceptor: NetworkInterceptor()).responseDecodable(of: Posts.self) { response in
                switch response.result {
                case .success(let value):
                    
                    let data = value
                    completionHandler(.success(data))
                    
                case .failure(_):
                    if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = response.response?.statusCode, let netError = PostingError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.postingError(netError)))
                    }
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    static func postLike(postId: String, likeQuery:LikeQuery, completionHandler: @escaping (Result<LikeQuery, AppError>) -> Void) {
        do {
            
            let urlRequest = try Router.postLike(postId: postId, query: likeQuery).asURLRequest()
            
            AF.request(urlRequest, interceptor: NetworkInterceptor()).responseDecodable(of: LikeQuery.self) { response in
                
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(_):
                    if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = response.response?.statusCode, let netError = LikePostError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.likeError(netError)))
                    }
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    static func fetchProfile(completionHandler: @escaping ((Result<ProfileModel, AppError>) -> Void)) {
        do {
            let urlRequest = try Router.profileFetch.asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: ProfileModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = ProfileFetchError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.profileFetchError(netError)))
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    static func fetchAccessPostDetails(postId: String, completionHandler: @escaping ((Result<Posts, AppError>) -> Void)) {
        
        do {
            let urlRequest = try Router.accessPostDetails(postID: postId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: Posts.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = PostDetailError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.postDetails(netError)))
                    }
                }
            }
        }
        catch {
            print(error)
        }
        
    }
    
    static func fetchUserPosts(completionHandler: @escaping ((Result<[Posts], AppError>) -> Void )) {
        
        do {
            let urlRequest = try Router.userPosts.asURLRequest()
            
            AF.request(urlRequest, interceptor: NetworkInterceptor()).responseDecodable(of: PostsModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data.data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = FetchPostError(rawValue: statusCode) {
                        completionHandler(.failure(.fetchPostError(netError)))
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    static func modifyProfileUpdate(modifyModel: ModifyProfileModel, completionHandler: @escaping((Result<ProfileModel, AppError>) -> Void)) {
        
        let modifyRouter = Router.modifyProfile(model: modifyModel)
        print(modifyRouter.baseURL + modifyRouter.version + modifyRouter.path)

        AF.upload(multipartFormData: { multipartForm in
            print(modifyModel.nick)
            if let nickData = modifyModel.nick.data(using: .utf8) {
                
                multipartForm.append(nickData, withName: "nick")
            } else {
                print("fdsafas")
            }
            
            multipartForm.append(modifyModel.profile, withName: "profile", fileName: "profile.jpg", mimeType: "image/jpeg")
//            print(multipartForm.contentType)
            
        }, to: modifyRouter.baseURL + modifyRouter.version + modifyRouter.path, method: modifyRouter.method, headers: HTTPHeaders(modifyRouter.header), interceptor: NetworkInterceptor())
        .responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                print(error)
                if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                    completionHandler(.failure(AppError.networkError(netError)))
                } else if let statusCode = response.response?.statusCode, let netError = ModifyProfileError(rawValue: statusCode) {
                    completionHandler(.failure(AppError.modifyProfileError(netError)))
                }
            }
        }
        
    }
    
    static func otherUserPosts(userId: String, completionHandler: @escaping ((Result<[Posts], AppError>) -> Void)) {
        
        do {
            let urlRequest = try Router.otherPosts(userId: userId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: PostsModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data.data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = FetchPostError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.fetchPostError(netError)))
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    static func otherUserProfile(userId: String, completionHandler: @escaping ((Result<ProfileModel, AppError>) -> Void)) {
        
        do {
            let urlRequest = try Router.otherProfile(userId: userId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: ProfileModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    print(error)
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = ProfileFetchError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.profileFetchError(netError)))
                    }

                }
            }
        }
        catch {
            print(error)
        }
        
    }
    
    static func createComments(commentModel: CommentModel, postId: String, completionHandler: @escaping ((Result<CommentsModel,AppError>) -> Void)) {
        do {
            let urlRequest = try Router.comment(model: commentModel, postId: postId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: CommentsModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = CommentError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.commentError(netError)))
                    }
                }
            }
        }
        catch {
            
        }
    }
    
    static func createFollow(userId: String, completionHandler: @escaping ((Result<FollowingModel, AppError>) -> Void)) {
        do {
            let urlRequest = try Router.following(userId: userId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: FollowingModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = FollowingError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.followingError(netError)))
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
}

