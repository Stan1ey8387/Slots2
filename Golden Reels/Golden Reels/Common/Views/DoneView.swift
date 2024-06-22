import UIKit

class DoneView: UIView {
    lazy var finishView = UIView.imageView(image)
   
    private let image: UIImage?
    private lazy var doneView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(finishView)
        finishView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setupView()
        self.isHidden = true
    }
    
    init(image: String) {
        self.image = .init(named: image)
        super.init(frame: .zero)
        setupView()
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(doneView)
        doneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
