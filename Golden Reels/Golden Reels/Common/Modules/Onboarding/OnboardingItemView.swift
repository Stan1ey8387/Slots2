import UIKit

struct OnboardingItemViewModel {
    let image: UIImage?
}

class OnboardingItemView: UIView {
    private lazy var imageView = UIView.imageView("")
    
    init(viewModel: OnboardingItemViewModel) {
        super.init(frame: .zero)
        imageView.image = viewModel.image
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
