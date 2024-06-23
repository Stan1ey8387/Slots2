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
    private lazy var grape = UIView.button {
        self.completion(.grape)
        self.pop()
    }.setupImage(.grape)
    private lazy var strawberry = UIView.button {
        self.completion(.strawberry)
        self.pop()
    }.setupImage(.strawberry)
    private lazy var lemon = UIView.button {
        self.completion(.lemon)
        self.pop()
    }.setupImage(.lemon)
    
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
    
    private func setupView() {
        view.image(.mainViewController)
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
        
        bonusView.addSubview(grape)
        grape.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(grape.snp.width).multipliedBy(141.0 / 420.0)
        }
        
        bonusView.addSubview(strawberry)
        strawberry.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(grape.snp.bottom).offset(10)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(grape.snp.width).multipliedBy(141.0 / 420.0)
        }
        
        bonusView.addSubview(lemon)
        lemon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(strawberry.snp.bottom).offset(10)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(grape.snp.width).multipliedBy(141.0 / 420.0)
        }
        
        view.addSubview(cresusImageView)
        cresusImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalToSuperview().dividedBy(1.7)
        }
    }
}
