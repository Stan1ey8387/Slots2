import SnapKit

final class Settings: UIViewController {
    
    private lazy var balanceLabel = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .init(hex: 0xF3D980))
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
        
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().dividedBy(1.3)
            make.height.equalTo(settingsView.snp.width).multipliedBy(616.0 / 663.0)
        }
        
        settingsView.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        view.addSubview(cresusImageView)
        cresusImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalToSuperview().dividedBy(1.7)
        }
    }
    
    private func musicView() -> UIView {
        var toggle = UserDefaults.isMusicEnabled
        
        let musicView = UIView.imageView(.musicView)
        let hstack = UIView.horizontalStackView(
            views: [
                musicView
            ]
        ).spacing(18)
        musicView.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(musicView.snp.width).multipliedBy(89.0 / 279.0)
        }
        let reelSwitch = ReelsSwitch(isOn: toggle, width: 70) { _ in
            toggle.toggle()
            UserDefaults.isMusicEnabled = toggle
            switch toggle {
            case true:
                SoundService.shared.playMusic()
            case false:
                SoundService.shared.stopMusic()
            }
            SoundService.shared.playSound(named: .click)
        }
        hstack.addArrangedSubview(reelSwitch)
        
        return hstack
    }
    
    private func soundView() -> UIView {
        var toggle = UserDefaults.isSoundsEnabled
        let soundView = UIView.imageView(.soundView)
        let hstack = UIView.horizontalStackView(
            views: [
                soundView
            ]
        ).spacing(18)
        soundView.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(soundView.snp.width).multipliedBy(89.0 / 279.0)
        }
        let reelSwitch = ReelsSwitch(isOn: toggle, width: 70) { _ in
            toggle.toggle()
            UserDefaults.isSoundsEnabled = toggle
            SoundService.shared.playSound(named: .click)
        }
        hstack.addArrangedSubview(reelSwitch)
        
        return hstack
    }
}
