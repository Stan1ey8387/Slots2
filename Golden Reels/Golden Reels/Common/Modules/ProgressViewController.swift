import SnapKit

final class ProgressViewController: UIViewController {
    
    private let index: Int
    private let images: [String]
    
    private var progressViews = [UIProgressView]()
    
    private lazy var closeButton: UIView = .button {
        self.pop()
    }.setupImage("closeButton")
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contentView: ContentView = {
        let contentView = ContentView(views: initialViews(), spacing: 0)
        return contentView
    }()
    
    private lazy var imageView = UIView.imageView(images[index])
    
    init(index: Int, images: [String]) {
        self.index = index
        self.images = images
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: 0x121212)
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalTo(view.snp.topMargin).offset(20)
            make.trailing.equalToSuperview().inset(15)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(closeButton.snp.bottom).offset(16)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        images.enumerated().forEach { index, image in
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progressTintColor = .white
            progressView.progress = self.index > index ? 1 : 0
            progressViews.append(progressView)
            stackView.addArrangedSubview(progressView)
        }
        
        animateProgressViews()
    }
    
    private func animateProgressViews() {
        var delay = 0.0
        let duration = 2.0
        
        progressViews.enumerated().forEach { index, progressView in
            guard index >= self.index else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: duration, animations: {
                    progressView.setProgress(1.0, animated: true)
                    self.imageView.image = .init(named: self.images[index])
                })
            }
            delay += duration
        }
    }
    
    private func initialViews() -> [UIView] {
        let views: [UIView] = [
            imageView
        ]
        return views
    }
}

