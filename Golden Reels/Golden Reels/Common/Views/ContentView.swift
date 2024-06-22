import SnapKit

class ContentView: UIView {
    var handleScrollViewDidScroll: (() -> Void)?
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            scrollView.contentInset = contentInset
        }
    }
    
    var canStickToTop: Bool = false {
        didSet {
            if canStickToTop {
                scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                scrollView.contentInsetAdjustmentBehavior = .automatic
            }
        }
    }
    
    private let views: [UIView]
    private let sideInset: Int
    private var pageView: PageView
    private let pageViewSettings: PageViewSettings?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    init(
        views: [UIView],
        spacing: CGFloat = 10,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        sideInset: Int = 15,
        axis: NSLayoutConstraint.Axis = .vertical,
        scrollViewClipsToBounds: Bool = true,
        pageViewSettings: PageViewSettings? = nil
    ) {
        self.views = views
        self.sideInset = sideInset
        pageView = PageView(count: views.count - 1, pageViewSettings: pageViewSettings)
        self.pageViewSettings = pageViewSettings
        super.init(frame: .zero)
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.axis = axis
        scrollView.clipsToBounds = scrollViewClipsToBounds
        setupView()
    }
    
    func update(views: [UIView]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach { view in
            DispatchQueue.main.async {
                self.stackView.addArrangedSubview(view)
            }
        }
    }
    
    func scrollToTop() {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    func scrollToBottom(plus value: CGFloat = 0) {
        if scrollView.bounds.height < scrollView.contentSize.height {
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + value)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        views.forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            switch stackView.axis {
                
            case .horizontal:
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
                make.height.equalTo(self).inset(sideInset)
            case .vertical:
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().inset(15)
                make.centerX.equalToSuperview()
                make.width.equalTo(self).inset(sideInset)
            @unknown default:
                break
            }
        }
        
        if pageViewSettings != nil {
            addSubview(pageView)
            pageView.snp.makeConstraints { make in
                make.top.equalTo(stackView.snp.bottom).inset(-9)
                make.centerX.equalToSuperview()
            }
        }
    }
}

extension ContentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollViewDidScroll?()
        
        if let viewWidth = stackView.arrangedSubviews.first?.bounds.width, viewWidth > 0 {
            let currentPage = (scrollView.contentOffset.x / viewWidth)
            let currentIndex = Int(currentPage.rounded(.toNearestOrEven))
            pageView.currentIndex = currentIndex
        }
    }
}
