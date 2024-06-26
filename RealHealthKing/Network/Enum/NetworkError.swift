//
//  NetworkError.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/14/24.
//

import Foundation

enum AppError: Error {
    case networkError(NetworkError)
    case loginError(LoginError)
    case duplicateError(DuplicateError)
    case signUpError(SignUpError)
    case imageUploadError(ImageUploadError)
    case postingError(PostingError)
    case fetchPostError(FetchPostError)
    case likeError(LikePostError)
    case profileFetchError(ProfileFetchError)
    case postDetails(PostDetailError)
    case modifyProfileError(ModifyProfileError)
    case commentError(CommentError)
    case followingError(FollowingError)
    case unfollowError(UnFollowError)
    case paymentError(PaymentError)
    case paymentHistoryError(PaymentHistoryError)
    case withdrawError(WithdrawError)
    case chatError(ChatError)
    case chatRoomError(ChatRoomError)
    case chatMessageError(ChatMessageError)
    case chatPostError(ChatPostError)
    case chatImageUploadError(ChatImageUploadError)
    case unowned
    
    var description: String {
        switch self {
        case .networkError(let networkError):
            return networkError.description
        case .loginError(let loginError):
            return loginError.description
        case .duplicateError(let duplicateError):
            return duplicateError.description
        case .signUpError(let signUpError):
            return signUpError.description
        case .imageUploadError(let imageUploadError):
            return imageUploadError.description
        case .postingError(let postingError):
            return postingError.description
        case .fetchPostError(let fetchPostError):
            return fetchPostError.description
        case .likeError(let likeError):
            return likeError.description
        case .profileFetchError(let profileError):
            return profileError.description
        case .postDetails(let postDetailError):
            return postDetailError.description
        case .modifyProfileError(let modifyProfileError):
            return modifyProfileError.description
        case .commentError(let commentError):
            return commentError.description
        case .followingError(let followingError):
            return followingError.description
        case .unfollowError(let unfollowError):
            return unfollowError.description
        case .paymentError(let paymentError):
            return paymentError.description
        case .paymentHistoryError(let paymentHistoryError):
            return paymentHistoryError.description
        case .withdrawError(let withdrawError):
            return withdrawError.description
        case .chatError(let chatError):
            return chatError.description
        case .chatRoomError(let chatRoomError):
            return chatRoomError.description
        case .chatMessageError(let chatMessageError):
            return chatMessageError.description
        case .chatPostError(let chatPostError):
            return chatPostError.description
        case .chatImageUploadError(let chatImageUploadError):
            return chatImageUploadError.description
        case .unowned:
            return "unowned"
        }
    }
}

enum NetworkError: Int, Error {
    case noSesacKey = 420
    case overCall = 429
    case invalidURL = 444
    case severError = 500
    
    var description: String {
        switch self {
        case .noSesacKey:
            return "noSesacKey"
        case .overCall:
            return "overCall"
        case .invalidURL:
            return "invalidURL"
        case .severError:
            return "severError"
        }
    }
}

enum LoginError: Int, Error {
    case omission = 400 // 누락
    case checkCount = 401 // 미가입 유저, 비번 확인
    
    var description: String {
        switch self {
        case .omission:
            return "omission"
        case .checkCount:
            return "checkCount"
        }
    }
}

enum DuplicateError: Int, Error {
    case emptyValue = 400
    case invalidEmail = 409
    
    var description: String {
        switch self {
        case .emptyValue:
            return "emptyValue"
        case .invalidEmail:
            return "invalidEmail"
        }
    }
}

enum SignUpError: Int, Error {
    case emptyValue = 400
    case existingUser = 409
    
    var description: String {
        switch self {
        case .emptyValue:
            return "emptyValue"
        case .existingUser:
            return "existingUser"
        }
    }
}

enum ImageUploadError: Int, Error {
    case success = 200
    case invalidRequire = 400
    case invalidToken = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .invalidRequire:
            return "이미지 용량이 커요!"
        case .invalidToken:
            return "올바른 토큰이 아닙니다"
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum PostingError: Int, Error {
    case success = 200
    case invalidToken = 401
    case forbidden = 403
    case noPosting = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "suceess"
        case .invalidToken:
            return "올바른 토큰이 아닙니다"
        case .forbidden:
            return "접근 권한이 없습니다."
        case .noPosting:
            return "서버 오류에요 나중에 다시 해주세요"
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum FetchPostError: Int, Error {
    case success = 200
    case unAccess = 400
    case invalidToken = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잘못된 접근 입니다."
        case .invalidToken:
            return "인증할 수 없는 토큰입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum LikePostError: Int, Error {
    case success = 200
    case unAccess = 400
    case invalidToken = 401
    case forbidden = 403
    case noPost = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잘못된 접근 입니다."
        case .invalidToken:
            return "인증할 수 없는 토큰입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .noPost:
            return "게시글을 찾을 수 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum ProfileFetchError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잘못된 접근 입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum PostDetailError: Int, Error {
    case success = 200
    case unRequest = 400
    case unAccess = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unRequest:
            return "잘못된 요청입니다."
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum ModifyProfileError: Int, Error {
    case success = 200
    case unRequest = 400
    case unAccess = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unRequest:
            return "잘못된 요청입니다."
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum CommentError: Int, Error {
    case success = 200
    case missing = 400
    case unAccess = 401
    case forbidden = 403
    case noPosts = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .missing:
            return "누락"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .noPosts:
            return "없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum FollowingError: Int, Error {
    case success = 200
    case unRequest = 400
    case unAccess = 401
    case forbidden = 403
    case already = 409
    case unKnow = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unRequest:
            return "잘못된 요청입니다."
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .already:
            return "이미 팔로잉중입니다."
        case .unKnow:
            return "알 수 없는 계정입니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum UnFollowError: Int, Error {
    case success = 200
    case unRequest = 400
    case unAccess = 401
    case forbidden = 403
    case unKnow = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unRequest:
            return "잘못된 요청입니다."
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unKnow:
            return "알 수 없는 계정입니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum PaymentError: Int, Error {
    case success = 200
    case unRequest = 400
    case unAccess = 401
    case forbidden = 403
    case validation = 409
    case noPost = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unRequest:
            return "잘못된 요청입니다."
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .validation:
            return "이미 존재하는 결제건"
        case .noPost:
            return "게시글이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum PaymentHistoryError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum WithdrawError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum ChatError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessUser = 410
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessUser:
            return "알 수 없는 계정입니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum ChatRoomError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessToken = 419
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessToken:
            return "재로그인 필요"
        }
    }
}

enum ChatMessageError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessUser = 410
    case unAccessToken = 419
    case noParty = 445
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessUser:
            return "알 수 없는 계정입니다."
        case .unAccessToken:
            return "재로그인 필요"
        case .noParty:
            return "채팅방 참여자가 아닙니다."
        }
    }
}

enum ChatPostError: Int, Error {
    case success = 200
    case unAccess = 401
    case forbidden = 403
    case unAccessUser = 410
    case unAccessToken = 419
    case noParty = 445
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessUser:
            return "알 수 없는 계정입니다."
        case .unAccessToken:
            return "재로그인 필요"
        case .noParty:
            return "채팅방 참여자가 아닙니다."
        }
    }
}

enum ChatImageUploadError: Int, Error {
    case success = 200
    case unRequest = 400
    case unAccess = 401
    case forbidden = 403
    case unAccessUser = 410
    case unAccessToken = 419
    case noParty = 445
    
    var description: String {
        switch self {
        case .success:
            return "success"
        case .unRequest:
            return "잘못된 요청입니다."
        case .unAccess:
            return "잚소된 접근입니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .unAccessUser:
            return "알 수 없는 계정입니다."
        case .unAccessToken:
            return "재로그인 필요"
        case .noParty:
            return "채팅방 참여자가 아닙니다."
        }
    }
}
