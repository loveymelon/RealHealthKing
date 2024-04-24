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
    
    let nickNameLabel = InfoLabel().then {
        $0.text = "fdsafdasfasf"
    }
    
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
//        $0.backgroundColor = .gray
    }
    
    let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message"), for: .normal)
    }
    
    let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.alignment = .fill
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.text = "dfjkashfjkldshfkldjsgklkladgsnjkladfnklnjkcxznvklberijkuahnibnqriotjeoqjntijadlfndkls;fnm,adsmfkldsnklfmdklsafnkls;flmdsnfkl;sadnfkldknsaklnfdklsnfklasnjkcxzklvmnjklranejkherwijqthiouehwnjknewklrnldsnfalknfkldsamvlnsakldfjkjasdkfjasdfhjkdshdfjkheiouwfnjkndlsncvjknsdjljdfhskajhfjkashfjkashfjkhadjksfhldashfjkhasjkldfhdjksahfjkhasjkfhadjshfjkdsahjkvbajkbvmnbcxzmnvbhjfbah"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20)
    }
    
    let moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    let postData = BehaviorRelay<Posts>(value: Posts())
    let likeData = BehaviorRelay<[String]>(value: [])
    
    var disposeBag = DisposeBag()
    
    let viewModel = HomeTableCellViewModel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scrollView.delegate = self
        
        configureUI()
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
}

extension HomeTableViewCell: UIConfigureProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    func configureHierarchy() {
        [profileImageView, nickNameLabel].forEach { view in
            topStackView.addArrangedSubview(view)
        }
        
        contentView.addSubview(topStackView)
        contentView.addSubview(scrollView)
        
        [likeButton, commentButton].forEach { button in
            bottomStackView.addArrangedSubview(button)
        }
        
        contentView.addSubview(bottomStackView)
        contentView.addSubview(pageControl)
        contentView.addSubview(contentLabel)
    }
    
    func configureLayout() {
        topStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(topStackView.snp.height)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.height.equalTo(profileImageView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(contentView.safeAreaLayoutGuide.snp.width)
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
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(bottomStackView.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    
}

extension HomeTableViewCell {
    
    // 처음 시작 -> 데이터를 뷰컨에서 받아서 셀에 뿌림 -> 셀에서 좋아요가 눌렸을때 -> 통신으로 좋아요 값 변경 -> 어떻게 원본 데이터의 좋아요 값을 바꿀까
    
    func bind() {
//        let likeButtonTap = likeButton.rx.tap.flatMap { [unowned self] in postData }
                
        let likeButtonTap = likeButton.rx.tap.withLatestFrom(postData.asObservable())
        
        let input = HomeTableCellViewModel.Input(inputLikeButtonTap: likeButtonTap, inputLikeValue: likeData.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.outputLikeValue.subscribe(with: self, onNext: { owner, isValid in
            
            owner.likeButton.isSelected = isValid
            print("Button", owner.likeButton.isSelected)
        }).disposed(by: disposeBag)
        
    }
    // 기존의 데이터가 있다면 다 받아들이고 아니라면 받지않기
    func configureCell(data: Posts, width: CGFloat) {
        
        postData.accept(data)
        print("likeData", data.likes, data.postId)
        likeData.accept(data.likes)
        
        DispatchQueue.main.async {
            self.updateImageViews(postData: data.files, width: width)
        }
        
        
        contentLabel.text = data.content
        
    }
    
    func updateImageViews(postData: [String], width: CGFloat) {
        
        for num in 0..<postData.count {
            let imageView = UIImageView()
            let postionX = width * CGFloat(num)
            
            let width = width
            let height = scrollView.bounds.height
 
            imageView.frame = CGRect(x: postionX, y: 0, width: width, height: height)
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + postData[num]
            
            imageView.downloadImage(imageUrl: url, width: width, height: height)
            
            scrollView.addSubview(imageView)
            
            scrollView.contentSize.width = width * CGFloat(1+num) // scrollView의 넓이 설정
        }
        
        pageControl.numberOfPages = postData.count
        
    }
    
}

extension HomeTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
