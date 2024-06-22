import UIKit

class SimpleProgressView: UIView {
    private let bgColor = UIColor.clear
    private let progressColor = UIColor.init(hex: 0xEF850C)
    
    private let progressView = UIView.empty().cornerRadius(4)
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ progress: CGFloat) {
        progressView.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(progress / 100)
        }
    }
    
    private func setupView() {
        backgroundColor(bgColor)
        progressView.backgroundColor(progressColor)
        
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
    }
}
