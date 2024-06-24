import SnapKit

final class Bonus: UIViewController {
    
    private let completion: ((UIImage) -> ())
    
    private lazy var balanceLabel = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .white)
    private lazy var balanceView = UIView.imageView(.balanceView)
    private lazy var popButton = UIView.button {
        self.pop()
        SoundService.shared.playSound(named: .click)
    }.setupImage(.popButton)
    private lazy var settingsButton = UIView.button {
        self.push(Settings())
        SoundService.shared.playSound(named: .click)
    }.setupImage(.settingsButton)
    private lazy var cresusImageView = UIView.imageView(.queen)
    private lazy var bonusView = UIView.imageView(.bonusView).isUserInteractionEnabled(true)
    private var views: [UIView] = []
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var pageControl = PageView(
        count: 2,
        pageViewSettings: .init(
            selectedColor: .init(hex: 0xF3D980),
            unselectedColor: .init(hex: 0x790C8C)
        )
    )
    
    init(completion: @escaping ((UIImage) -> ())) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        balanceLabel.text = UserDefaults.balance.string
    }
    
    private func bonusButton(_ image: UIImage, tap: @escaping (() -> ())) -> UIView {
        let stack = UIView.centerStackView(views: [])
        let buton = UIView.button {
            tap()
            self.pop()
        }.setupImage(image)
        stack.addArrangedSubview(buton)
        buton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(buton.snp.width).multipliedBy(109.0 / 341.0)

        }
        return stack
    }
    
    private func setupView() {
        view.image(.mainViewController)
        
        views.append(
            .verticalStackView(
                views: [
                    bonusButton(.goldx10, tap: {
                        self.completion(.goldx10)
                    }),
                    bonusButton(.redx25, tap: {
                        self.completion(.redx25)
                    }),
                    bonusButton(.bluex50, tap: {
                        self.completion(.bluex50)
                    }),
                    .empty()
                ]
            ).spacing(10)
        )
        
        views.append(
            .verticalStackView(
                views: [
                    bonusButton(.purplex10, tap: {
                        self.completion(.purplex10)
                    }),
                    bonusButton(.greenx25, tap: {
                        self.completion(.greenx25)
                    }),
                    bonusButton(.lightgreenx50, tap: {
                        self.completion(.lightgreenx50)
                    }),
                    .empty()
                ]
            ).spacing(10)
        )
        
        views.append(
            .verticalStackView(
                views: [
                    bonusButton(.ringx10, tap: {
                        self.completion(.ringx10)
                    }),
                    bonusButton(.crownx25, tap: {
                        self.completion(.crownx25)
                    }),
                    bonusButton(.cupx50, tap: {
                        self.completion(.cupx50)
                    }),
                    .empty()
                ]
            ).spacing(10)
        )
        
        view.addSubview(balanceView)
        balanceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(15)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(balanceView.snp.width).multipliedBy(104.0 / 321.0)
        }
        
        balanceView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(5)
        }
        
        view.addSubview(popButton)
        popButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(64)
            make.height.equalTo(popButton.snp.width).multipliedBy(129.15 / 129.36)
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(64)
            make.height.equalTo(settingsButton.snp.width).multipliedBy(129.15 / 129.36)
        }
        
        view.addSubview(bonusView)
        bonusView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().dividedBy(1.3)
            make.height.equalTo(bonusView.snp.width).multipliedBy(616.0 / 663.0)
        }
        
        bonusView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        bonusView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(cresusImageView)
        cresusImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalToSuperview().dividedBy(1.7)
        }
        
        views.enumerated().forEach { index, view in
            self.scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.width.height.equalToSuperview()
                make.top.equalToSuperview().offset(60)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview().inset(CGFloat(index) * bonusView.bounds.width / 5)
                
                if index == views.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
        }
    }
}

extension Bonus: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = (scrollView.contentOffset.x / view.bounds.width)
        let currentIndex = Int(currentPage.rounded(.toNearestOrEven))
        pageControl.currentIndex = currentIndex
    }
}
