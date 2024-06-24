import SnapKit

final class GameViewController: UIViewController {
    // MARK: Properties
    
    private var currentDeal: Double = min(200, UserDefaults.balance.double)
    private var bonusMultiplier = 1
    private var bonusImage: UIImage?
    
    // MARK: UI elements
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
    
    private lazy var bonusButton = UIView.button {
        self.bonusButtonTapped()
    }.setupImage(.bonus)
    
    private func bonusButtonTapped() {
        self.push(Bonus(completion: { model in
            // TODO
//            if image == UIImage.strawberry {
//                self.bonusImage = .item6
//                self.bonusMultiplier = 25
//            } else if image == UIImage.lemon {
//                self.bonusImage = .item7
//                self.bonusMultiplier = 50
//            } else if image == UIImage.grape {
//                self.bonusImage = .item5
//                self.bonusMultiplier = 10
//            }
            
            print("<<< image = \(model)")
            self.bonusButton.setupImage(model.image)
        }))
        SoundService.shared.playSound(named: .click)
    }
    
    private lazy var dealView = DealView(
        minValue: 10,
        value: currentDeal,
        step: 10
    ) { [weak self] deal in
        self?.currentDeal = deal
    }
    
    private lazy var spinButton = UIView.button { [weak self] in
        guard let self = self else { return }
        self.currentDeal = self.dealView.value
        self.slotsView.spin { resultItem in
            SoundService.shared.playSound(named: .win)
            var multiplier = resultItem.multiplier
            if resultItem.images.contains(where: { $0 == self.bonusImage }) {
                multiplier *= self.bonusMultiplier
            }
            // TODO
//            if multiplier == 0  {
//                if UserDefaults.balance.double > self.currentDeal {
//                    UserDefaults.balance -= Int(self.currentDeal)
//                } else {
//                    UserDefaults.balance = Int(self.dealView.minValue)
//                }
//                print("<<< lose = \(self.currentDeal)")
//                let alertView = AlertView(money: -Int(self.currentDeal)) { _ in }
//                self.view.addSubview(alertView)
//                alertView.makeConstraints { make in
//                    make.edges.equalToSuperview()
//                }
//                
//            } else {
//                let winValue = Int(self.currentDeal) * multiplier
//                print("<<< win = \(winValue)")
//                UserDefaults.balance += winValue
//                
//                
//                let alertView = AlertView(money: winValue) { _ in }
//                self.view.addSubview(alertView)
//                alertView.makeConstraints { make in
//                    make.edges.equalToSuperview()
//                }
//            }
            
            self.balanceLabel.text = UserDefaults.balance.string
            self.dealView.fixDeal()
            
            if self.bonusImage != nil {
                // Disable bonus after using spin
                self.bonusButton.isHidden = true
                self.bonusImage = nil
                self.bonusMultiplier = 1
            }
        }
    }.setupImage(.spin)
    
    private lazy var slotsView = SlotsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.image(.gameViewController)
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
        
        view.addSubview(slotsView)
        slotsView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(slotsView.snp.width)
        }
        
        view.addSubview(dealView)
        dealView.snp.makeConstraints { make in
            make.top.equalTo(slotsView.snp.bottom).inset(-30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(dealView.snp.width).multipliedBy(272.0 / 797.0)
        }
        
        view.addSubview(spinButton)
        spinButton.snp.makeConstraints { make in
            make.top.equalTo(dealView.snp.bottom).inset(-30)
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalTo(spinButton.snp.width).multipliedBy(141.0 / 420.0)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(bonusButton)
        bonusButton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalTo(bonusButton.snp.width).multipliedBy(88.0 / 263.0)
            make.trailing.equalTo(slotsView).inset(20)
            make.bottom.equalTo(slotsView.snp.top)
        }
    }
}
