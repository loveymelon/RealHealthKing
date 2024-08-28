
# 나의짐 ReadMe

| 홈 | 검색 | 프로필 |
|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/83d04d40-364a-4aa8-837c-8bff44d6b2bf"> | <img src = "https://github.com/user-attachments/assets/03e05808-c51a-4055-9af3-e33c8b60ca2e"> | <img src = "https://github.com/user-attachments/assets/b77b0e22-8e24-4ed9-bee7-dff400869de1"> |

| 중고물품 | 중고물품 등록 | 채팅목록 | 채팅 |
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/57e943ab-da1f-4b67-b254-6cbde3e9c6a9"> | <img src="https://github.com/user-attachments/assets/db3cf996-e7ed-4aac-b703-7091ba5e574d"> | <img src="https://github.com/user-attachments/assets/3856a2a4-0a55-49be-a0be-e4027c5aaab8"> | <img src="https://github.com/user-attachments/assets/d2d6d50b-58f0-4b37-9e17-94e29a817bfa"> |

운동스타그램과 자신의 운동장비 혹은 물건들을 사고팔 수 있는 앱 입니다.

### 핵심기능

- 게시글 포스팅 기능 
- 팔로우, 팔로잉 기능 
- 해시태그 기반 조회 ( 검색시 유저 게시글의 해시태그 기반으로 검색할 수 있습니다.)

유저 물건 구매 기능

### 기술 스택

- UIKit, RxSwift

- Alamofire , NetworkRouter,  iamport-ios, Socket

- MVVM (Input, Output)

- KeyChain

- KingFisher, Toast, compositional Layout

### MVVM (Input, Output)

> 원할한 토큰 갱신을 위해서 Alamofire의 Interceptor를 사용하였습니다.
MVVM: UI 로직과 비즈니스 로직을 좀 더 분리하여 데이터의 흐름 명확하게 할 수 있는 Input / Output을 사용하였습니다.

```swift
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
```
### RxSwift 

> 값들을 관찰함으로써 사용자의 이벤트처리를 비동기적으로 수행하기위해서 <br>RxSwift를 사용하였습니다.
```swift

final class ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        ...
    }
    
    struct Output {
        let chatDatas: Driver<[ChatRealmModel]>
        ...
    }
    
    private let realmRepository = RealmRepository()
    
    private let isValidData = PublishRelay<Bool>()
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        ...
    }

}
```

### KingFisher

> 이미지를 보다 효율적으로 다운받기 위해서 캐싱기능이 있는 KingFisher를 사용하였습니다.

### Alamofire

> MultipartFormData, HTTP Method등에 대한 기능들을 제공하여 빠른 네트워킹 작업을 할 수 있어 사용하였습니다.

## 새롭게 도입한 기술

### TargetType 프로토콜

Moya를 참고하여 네트워크 요청을 구성하는 데 필요한 모든 정보를 제공하는 역할을 가집니다.

```swift
protocol TargetType: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var version: String { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    
}
```

### ViewController 생명주기

 RxSwift를 사용하여 UIViewController의 생명 주기 메서드를 extension함으로써 생명 주기 이벤트에 대해 보다 쉽게 접근할 수 있습니다.

```swift
extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
```


### 고려 사항

이미지 압축시 퀄리티를 1보다 아래로 낮추면 이미지를 쓸때마다 퀄리티가 낮아지는 것을 인지하여서 이미지 자체의 사이즈를 줄이는 방식으로 접근을 하였습니다.

```swift
image.resizeWithWidth(width: 700)?.jpegData(compressionQuality: 1)
```

이미지를 다시 불러올때는 이미 다운을 받았던 이미지를 다시 통신을 통해 받으면 비용발생 및 속도가 느려지는 것을 방지하기 위해서 retrieveImage를 사용하여서 캐싱처리를 하였습니다.

```swift
KingfisherManager.shared.retrieveImage(with: url, options: [
            .requestModifier(imageDownloadRequest),
            .scaleFactor(scale),
        ]) 
```


