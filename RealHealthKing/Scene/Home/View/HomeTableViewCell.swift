//
//  HomeTableViewCell.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

@objc protocol CellDelegate: AnyObject {
    func profileViewTap(vc: UIViewController)
    @objc optional func commentButtonTap(vc: UIViewController)
    @objc optional func moreButtonTap()
}

class HomeTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "person")
        $0.tintColor = .blue
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let nickNameLabel = InfoLabel()
    
    let topStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = .white
        $0.hidesForSinglePage = true
        $0.currentPage = 0
    }
    
    let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    let likeCountLabel = UILabel().then {
        $0.textColor = .white
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message"), for: .normal)
    }
    
    let commentCountLabel = UILabel().then {
        $0.textColor = .white
    }
    
    let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20)
    }
    
    let hashLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 14)
    }
    
    let moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.isHidden = true
    }
    
    let postData = BehaviorRelay<Posts>(value: Posts())
    let likeData = BehaviorRelay<[String]>(value: [])
    
    weak var delegate: CellDelegate?
    
    var disposeBag = DisposeBag()
    
    let viewModel = HomeTableCellViewModel()
    var homeModel: HomeModel?
    var cellIndex: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scrollView.delegate = self
        
        configureUI()
        backgroundColor = .black
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        viewModel.disposeBag = DisposeBag() // 셀이 deinit이 안되니 DisposeBag인스턴스를 생성해서 정리해줘야된다 생각하면 이렇게 접근하였습니다.
    }
    
}

extension HomeTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        [topStackView,scrollView, bottomStackView, pageControl, contentLabel, moreButton, hashLabel].forEach { view in
            contentView.addSubview(view)
        }
        
        [profileImageView, nickNameLabel].forEach { view in
            topStackView.addArrangedSubview(view)
        }
        
        [likeButton, likeCountLabel, commentButton, commentCountLabel].forEach { button in
            bottomStackView.addArrangedSubview(button)
        }
        
    }
    
    func configureLayout() {
        topStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.height.equalTo(profileImageView)
            make.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width)
            make.top.equalTo(topStackView.snp.bottom).offset(10)
            make.height.equalTo(contentView.safeAreaLayoutGuide.snp.height).multipliedBy(0.7)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).inset(5)
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(bottomStackView.snp.centerY)
            make.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).inset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(50)
            make.top.equalTo(bottomStackView.snp.bottom).offset(10)
        }
        
        moreButton.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel.snp.trailing)
            make.centerY.equalTo(contentLabel.snp.centerY)
        }
        
        hashLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

extension HomeTableViewCell {
    
    func bind() {
        
        // 현재 버튼 상태의 반대값을 보내면 되지않을까?
        let likeButtonTap = likeButton.rx.tap.withUnretained(self).map { owner, _ in
            return (!owner.likeButton.isSelected, owner.postData.value)
        }
        
        let input = HomeTableCellViewModel.Input(inputLikeButtonTap: likeButtonTap, inputLikeValue: likeData.asObservable())
        
        let output = viewModel.transform(input: input)
        
        moreButton.rx.tap.bind(with: self) { owner, _ in
            
            owner.contentLabel.numberOfLines = 0
            owner.moreButton.isHidden = true
            owner.delegate?.moreButtonTap?()
            
        }.disposed(by: disposeBag)
        
        output.outputFirstLikeValue.drive(with: self, onNext: { owner, isValid in
            
            owner.likeButton.isSelected = isValid
             // 여기서 좋아요에 대한 포스트 아이디를 키, 좋아요 상태를 value
            
        }).disposed(by: disposeBag)
        
        output.outputTapLikeValue.drive(with: self) { owner, isValid in
            owner.homeModel?.likeDic[owner.cellIndex] = isValid
            owner.likeButton.isSelected = isValid
        }.disposed(by: disposeBag)
        
    }
    
    // 좋아요 버튼을 눌렀을때 통신을 하여서 좋아요의 값을 바꿔주고 거기에 대한 bool값을 즉각적으로 바꿔줬는데
    // 셀이 시작할때마다 likeData라는 옵저버에 값을 보낸뒤 viewModel에서 원본 데이터에서 contain인지 검사후 버튼의 상태를 바꿔준다.
    // 만약 dic에 값이 있다면 아예 검사를 못하게 못하나
    func configureCell(data: Posts, width: CGFloat, homeModel: HomeModel, index: Int) {
        bind()
        postData.accept(data)
        
        nickNameLabel.text = data.creator.nick
        contentLabel.text = data.content1
        hashLabel.text = data.content
        likeCountLabel.text = "\(data.likes.count)"
        commentCountLabel.text = "\(data.comments.count)"
        
        self.homeModel = homeModel
        cellIndex = index
        
        if let imageUrl = data.creator.profileImage {
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + imageUrl
            profileImageView.downloadImage(imageUrl: url)
            
            
        } else {
            profileImageView.image = UIImage(systemName: "person")
        }
        
        if contentLabel.lineCount > 2 {
            moreButton.isHidden = false
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            updateImageViews(scrollView: scrollView, pageControl: pageControl, postData: data.files, width: width)
            
        }
        
        saveAndCheckModel(data: data, cellIndex: cellIndex)
        
        cellBindDelegate(data: data)
        
    }
    
    func saveAndCheckModel(data: Posts, cellIndex: Int) {
        if let like = homeModel?.likeDic[cellIndex] {
            likeButton.isSelected = like
            like ? likeData.accept(["true"]) : likeData.accept(["false"])
        } else {
            likeData.accept(data.likes)
        }
        
        if let page = homeModel?.pageValue[cellIndex] {
            
            pageControl.currentPage = page
            
        }
    }
    
    func cellBindDelegate(data: Posts) {
        profileImageView.rx.tapGesture().when(.recognized).withUnretained(self).map { _ in
            return data.creator.userId
        }.subscribe(with: self) { owner, id in
            let vc = ProfileViewController()
            
            if KeyChainManager.shared.userId == id {
                vc.mainView.tabVC.viewState = .me
                vc.viewModel.viewState = .me
            } else {
                vc.viewModel.otherUserId = id
                vc.viewModel.viewState = .other
                vc.mainView.tabVC.viewState = .other
                vc.mainView.tabVC.userId = id
            }
            
            owner.delegate?.profileViewTap(vc: vc)
        }.disposed(by: disposeBag)
        
        commentButton.rx.tap.map { data.postId ?? "empty" }.subscribe(with: self) { owner, id in
            let vc = CommentViewController()
            
            vc.postId.accept(id)
            
            owner.delegate?.commentButtonTap?(vc: vc)
            
        }.disposed(by: disposeBag)
    }
    
}

extension HomeTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        homeModel?.pageValue[cellIndex] = pageControl.currentPage
    }
}
