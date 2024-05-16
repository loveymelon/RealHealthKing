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
    
    static func fetchPosts(productId: String = "") -> Single<Result<PostsModel, AppError>> {
        
        return Single.create { single in
            do {
                let urlRequest = try Router.postFetch.postURLRequest(productId: productId)
                print(urlRequest)
                AF.request(urlRequest, interceptor: NetworkInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostsModel.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
                        case .failure(let error):
                            print(error)
                            if let statusCode = response.response?.statusCode, let netError = NetworkError(rawValue: statusCode) {
                                single(.success(.failure(AppError.networkError(netError))))
                            } else if let statusCode = response.response?.statusCode, let netError = FetchPostError(rawValue: statusCode) {
                                single(.success(.failure(.fetchPostError(netError))))
                            }
                        }
                    }
            } catch {
                print(error)
            }
            return Disposables.create()
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
    
    static func uploadPostContents(model: Posts) -> Single<Result<Posts, AppError>> {
        
        return Single.create { single in
            
            do {
                let urlRequest = try Router.posting(model: model).postURLRequest(productId: model.productId ?? "empty")
                
                AF.request(urlRequest, interceptor: NetworkInterceptor()).responseDecodable(of: Posts.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(.success(value)))
                    case .failure(let error):
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = PostingError(rawValue: statusCode) {
                            single(.success(.failure(.postingError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            return Disposables.create()
            
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
                    print(error)
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
    
    static func fetchAccessPostDetails(postId: String) -> Single<Result<Posts, AppError>> {
        
        return Single.create { single in
            
            do {
                let urlRequest = try Router.accessPostDetails(postID: postId).asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: Posts.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = PostDetailError(rawValue: statusCode) {
                            single(.success(.failure(.postDetails(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
        
    }
    
    static func fetchUserPosts(cursor: String = "", productId: String) -> Single<Result<PostsModel, AppError>>  {
        
        return Single.create { single in
            do {
                let urlRequest = try Router.userPosts.pageURLRequest(cursorValue: cursor, productId: productId)
                
                AF.request(urlRequest, interceptor: NetworkInterceptor()).responseDecodable(of: PostsModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        return single(.success(.success(data)))
                    case .failure(let error):
                        print(error)
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            return single(.success(.failure(.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = FetchPostError(rawValue: statusCode) {
                            return single(.success(.failure(.fetchPostError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            return Disposables.create()
            
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
    
    static func otherUserPosts(userId: String, cursor: String = "", productId: String) -> Single<Result<PostsModel, AppError>>  {
        
        return Single.create { single in
            do {
                let urlRequest = try Router.otherPosts(userId: userId).pageURLRequest(cursorValue: cursor, productId: productId)
                
                AF.request(urlRequest).responseDecodable(of: PostsModel.self) { response in
                    switch response.result {
                        
                    case .success(let data):
                        return single(.success(.success(data)))
                    case .failure(let error):
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            return single(.success(.failure(.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = FetchPostError(rawValue: statusCode) {
                            return single(.success(.failure(.fetchPostError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    static func otherUserProfile(userId: String) -> Single<Result<ProfileModel, AppError>> {
        
        return Single.create { single in
            do {
                let urlRequest = try Router.otherProfile(userId: userId).asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: ProfileModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        print(error)
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = ProfileFetchError(rawValue: statusCode) {
                            single(.success(.failure(.profileFetchError(netError))))
                        }
                    }
                }
            }
            catch {
                print(error)
            }
            return Disposables.create()
        }
        
    }
    
    static func createComments(commentModel: CommentsModel, postId: String, completionHandler: @escaping ((Result<CommentsModel,AppError>) -> Void)) {
        do {
            let urlRequest = try Router.comment(model: commentModel, postId: postId).asURLRequest()
            print(urlRequest)
            AF.request(urlRequest).responseDecodable(of: CommentsModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    print(response.response?.statusCode)
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
    
    static func createFollow(userId: String, completionHandler: @escaping ((Result<Follow, AppError>) -> Void)) {
        do {
            let urlRequest = try Router.following(userId: userId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: Follow.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    print("follow", error)
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
    
    static func unFollow(userId: String, completionHandler: @escaping ((Result<Follow, AppError>) -> Void)) {
        do {
            let urlRequest = try Router.unfollow(userId: userId).asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: Follow.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    print("unFollow", error)
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = UnFollowError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.unfollowError(netError)))
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    static func pagePosts(cursor: String, productId: String, completionHandler: @escaping ((Result<PostsModel, AppError>) -> Void)) {
        do {
            let urlRequest = try Router.postFetch.pageURLRequest(cursorValue: cursor, productId: productId)
            
            AF.request(urlRequest).responseDecodable(of: PostsModel.self) { response in
                switch response.result {
                case .success(let data):
                    print("성공이냐?")
                    completionHandler(.success(data))
                case .failure(let error):
                    print(error)
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
    
    
    
    static func searchHashTag(hashTag: String, cursor: String = "", completionHandler: @escaping ((Result<PostsModel, AppError>) -> Void)) {
        do {
            let urlRequest = try Router.hashTagSearch.hashPageURLRequest(hashTag: hashTag, cursor: cursor)
            
            AF.request(urlRequest).responseDecodable(of: PostsModel.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.networkError(netError)))
                    } else if let statusCode = error.responseCode, let netError = FetchPostError(rawValue: statusCode) {
                        completionHandler(.failure(AppError.fetchPostError(netError)))
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    static func checkPayment(model: PurchaseModel) -> Single<Result<PurchaseModel, AppError>> {
        return Single.create { single in
            
            do {
                let urlRequest = try Router.purchase(model: model).asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: PurchaseModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("tjdhthdsjkahfldksahfljsad")
                        single(.success(.success(data)))
                    case .failure(let error):
                        print("eerorrrr")
                        print(error)
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = PaymentError(rawValue: statusCode) {
                            single(.success(.failure(.paymentError(netError))))
                        }
                        
                    }
                }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    static func getPaymentHistory() -> Single<Result<PaymentModel, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.paymentHistory.asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: PaymentModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = PaymentError(rawValue: statusCode) {
                            single(.success(.failure(.paymentError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    static func withdraw() -> Single<Result<Empty, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.withdraw.asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: Empty.self) { response in
                    switch response.result {
                    case .success(_):
                        single(.success(.success( Empty.value )))
                    case .failure(let error):
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = WithdrawError(rawValue: statusCode) {
                            single(.success(.failure(.withdrawError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    static func connectChat(userId: String) -> Single<Result<ChatModel, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.chat(model: ChatUserId(opponentId: userId)).asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: ChatModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        print(error)
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = ChatError(rawValue: statusCode) {
                            single(.success(.failure(.chatError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            return Disposables.create()
        }
    }
    
    static func fetchChatRoom() -> Single<Result<ChatRoomsModel, AppError>> {
        return Single.create { single in
            do {
                let urlRequest = try Router.chatRoom.asURLRequest()
                
                AF.request(urlRequest).responseDecodable(of: ChatRoomsModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        print(error)
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = ChatRoomError(rawValue: statusCode) {
                            single(.success(.failure(.chatRoomError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            return Disposables.create()
        }
    }
    
    static func fetchChatMessage(roomId: String, cursor: String) -> Single<Result<ChatHistoryModel, AppError>> {
        
        return Single.create { single in
            
            do {
                let urlRequest = try Router.chatHistory(roomId: roomId).asChatURLRequest(cusorDate: cursor)
                
                AF.request(urlRequest).responseDecodable(of: ChatHistoryModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        print(error)
                        if let statusCode = error.responseCode, let netError = NetworkError(rawValue: statusCode) {
                            single(.success(.failure(AppError.networkError(netError))))
                        } else if let statusCode = error.responseCode, let netError = ChatRoomError(rawValue: statusCode) {
                            single(.success(.failure(.chatRoomError(netError))))
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            return Disposables.create()
        }
        
    }
    
}

