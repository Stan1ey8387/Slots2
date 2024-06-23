import SnapKit

final class Settings: UIViewController {
    
    private lazy var balanceLabel = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .white)
    private lazy var balanceView = UIView.imageView(.balanceView)
    private lazy var popButton = UIView.button {
        self.pop()
        SoundService.shared.playSound(named: .click)
    }.setupImage(.popButton)
    private lazy var settingsView = UIView.imageView(.settingsView).isUserInteractionEnabled(true)
    private lazy var vstack = UIView.verticalStackView(
        views: [
            musicView(),
            soundView()
        ]
    ).spacing(15).distribution(.fillEqually)
    private lazy var cresusImageView = UIView.imageView(.queen)
    
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
        }
        
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        settingsView.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(25)
        }
        
        view.addSubview(cresusImageView)
        cresusImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    private func musicView() -> UIView {
        var toggle = UserDefaults.isMusicEnabled
        
        let hstack = UIView.horizontalStackView(
            views: [
                .imageView(.musicView)
            ]
        ).spacing(18)
        let button = UIView.button {
            toggle.toggle()
            let button = hstack.subviews.last as? CustomButton
            button?.setupImage(toggle ?  UIImage.musicButtonOn : UIImage.musicButtonOff)
            UserDefaults.isMusicEnabled = toggle
            switch toggle {
            case true:
                SoundService.shared.playMusic()
            case false:
                SoundService.shared.stopMusic()
            }
            SoundService.shared.playSound(named: .click)
        }.setupImage(toggle ? UIImage.musicButtonOn : UIImage.musicButtonOff)
        hstack.addArrangedSubview(button)
        
        return hstack
    }
    
    private func soundView() -> UIView {
        var toggle = UserDefaults.isSoundsEnabled
        let hstack = UIView.horizontalStackView(
            views: [
                .imageView(.soundView)
            ]
        ).spacing(18)
        let button = UIView.button {
            toggle.toggle()
            let button = hstack.subviews.last as? CustomButton
            button?.setupImage(toggle ? UIImage.soundButtonOn : UIImage.soundButtonOff)
            UserDefaults.isSoundsEnabled = toggle
            SoundService.shared.playSound(named: .click)
        }.setupImage(toggle ? UIImage.soundButtonOn : UIImage.soundButtonOff)
        hstack.addArrangedSubview(button)
        
        return hstack
    }
}
