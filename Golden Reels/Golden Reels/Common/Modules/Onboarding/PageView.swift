import SnapKit

struct PageViewSettings {
    let selectedColor: UIColor
    let unselectedColor: UIColor
}

class PageView: UIView {
    var currentIndex: Int = 0 {
        didSet {
            updteItemsColor()
        }
    }
    
    private let count: Int
    private let views: [UIView]
    private let pageViewSettings: PageViewSettings?
    
    
    // Setup
    static let selectedColor: UIColor = .init(hex: 0xD9D9D9)
    static let selectedSize: CGSize = .init(width: 8, height: 8)
    static let unselectedColor: UIColor = .init(hex: 0xFF6086)
    static let unselectedSize: CGSize = .init(width: 8, height: 8)
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }().alignment(.center)
    
    init(count: Int, pageViewSettings: PageViewSettings? = nil) {
        self.count = count
        self.pageViewSettings = pageViewSettings
        self.views = (0...count).map { _ in
            let view = UIView()
            view.backgroundColor = pageViewSettings?.unselectedColor ?? Self.unselectedColor
            view.layer.cornerRadius = Self.selectedSize.height / 2
            
            return view
        }
        super.init(frame: .zero)
        setupView()
        updteItemsColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        views.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        views.enumerated().forEach { index, view in
            view.snp.makeConstraints { make in
                make.size.equalTo(Self.unselectedSize)
            }
        }
        
    }
  
    private func updteItemsColor() {
        views.enumerated().forEach { index, view in
            if index == currentIndex {
                view.backgroundColor = pageViewSettings?.selectedColor ?? Self.selectedColor
                if Self.selectedSize != Self.unselectedSize {
                    view.snp.remakeConstraints { make in
                        make.size.equalTo(Self.selectedSize)
                    }
                }
            } else {
                view.backgroundColor = pageViewSettings?.unselectedColor ?? Self.unselectedColor
                if Self.selectedSize != Self.unselectedSize {
                    view.snp.remakeConstraints { make in
                        make.size.equalTo(Self.unselectedSize)
                    }
                }
            }
        }
        
        if Self.selectedSize != Self.unselectedSize {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}
