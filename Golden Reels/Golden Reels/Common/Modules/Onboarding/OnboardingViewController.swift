import SnapKit

class OnboardingViewController: UIViewController {
    var finishHandler: (() -> Void)?
    
    private let views: [UIView]
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var buttons = UIView.horizontalStackView(
        views: [
            .button {
                self.finishHandler?()
            }.setupImage("skipButton"),
            .button {
                self.next()
            }.setupImage("nextButton")
        ]
    ).distribution(.fillEqually).spacing(13)
    
    private lazy var pageView: PageView = {
        let pageView = PageView(count: views.count - 1)
        pageView.isHidden = true
        return pageView
    }()
    
    init(views: [UIView]) {
        self.views = views
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(buttons)
        buttons.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.snp.bottomMargin).inset(30)
        }
        
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.bottom.equalTo(buttons.snp.top).inset(-20)
            make.centerX.equalToSuperview()
        }
        
        views.enumerated().forEach { index, view in
            self.scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.width.height.equalToSuperview()
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().inset(CGFloat(index) * self.view.bounds.width)
                
                if index == views.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
        }
    }
    
    private func next() {
        guard self.pageView.currentIndex < self.views.count - 1 else {
            self.finishHandler?()
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = CGFloat(self.pageView.currentIndex + 1) * self.view.bounds.width
        }
    }
    
    private func previous() {
        guard self.pageView.currentIndex != 0 else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = CGFloat(self.pageView.currentIndex - 1) * self.view.bounds.width
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = (scrollView.contentOffset.x / view.bounds.width)
        let currentIndex = Int(currentPage.rounded(.toNearestOrEven))
        pageView.currentIndex = currentIndex
    }
}
