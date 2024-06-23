import SnapKit
import Darwin

final class MainViewController: UIViewController {
    
    private lazy var timeLabel = UIView.label("11:59:59".uppercased()).font(.monospacedDigitSystemFont(ofSize: 14, weight: .bold)).textColor(.init(hex: 0xF3D980)).textAlignment(.center)
    private lazy var bonusTimeImageView = UIView.imageView(.bonusTime)
    private var countdownTimer: Timer?
    private var endTime: Date?
    private lazy var balanceLabel = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .init(hex: 0xF3D980))
    private lazy var balanceView = UIView.imageView(.balanceView)
    private lazy var settingsButton = UIView.button {
        self.push(Settings())
    }.setupImage(.settingsButton)
    private lazy var cresusImageView = UIView.imageView(.cresus1)
    private lazy var playGameButton = UIView.button {
        self.push(GameViewController())
        SoundService.shared.playSound(named: .click)
    }.setupImage(.playGame)
    private lazy var policyButton = UIView.button {
        //TODO: open policy
        SoundService.shared.playSound(named: .click)
    }.setupImage(.POLICY)
    private lazy var quitButton = UIView.button {
        SoundService.shared.playSound(named: .click)
        exit(0)
    }.setupImage(.QUIT_GAME)
    private lazy var vstack = UIView.verticalStackView(
        views: [
            playGameButton,
            policyButton,
            quitButton
        ]
    ).spacing(5).distribution(.fillEqually).alignment(.center)
    private lazy var alertView = AlertView(money: 3000) { int in
        self.saveMoney(int)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        SoundService.shared.playMusic()
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
        balanceLabel.text = UserDefaults.balance.string
        
        loadEndTime()
        updateTimer()
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
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(64)
            make.height.equalTo(settingsButton.snp.width).multipliedBy(129.15 / 129.36)
        }
        
        view.addSubview(bonusTimeImageView)
        bonusTimeImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().dividedBy(6.5)
            make.height.equalTo(bonusTimeImageView.snp.width).multipliedBy(136.0 / 144.0)
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(bonusTimeImageView.snp.bottom).offset(10)
            make.centerX.equalTo(bonusTimeImageView)
            make.width.equalToSuperview().dividedBy(5)
        }
        
        view.addSubview(cresusImageView)
        cresusImageView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().dividedBy(1.3)
        }
        
        view.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        playGameButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(playGameButton.snp.width).multipliedBy(168.0 / 607.0)
        }
        
        policyButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(playGameButton.snp.width).multipliedBy(168.0 / 607.0)
        }
        
        quitButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(playGameButton.snp.width).multipliedBy(168.0 / 607.0)
        }
                
        alertView.isHidden = UserDefaults.endTime != nil
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func saveMoney(_ money: Int) {
        UserDefaults.balance += money
        balanceLabel.text = UserDefaults.balance.string
        alertView.isHidden = true
        start12HourTimer()
    }
    
    private func start12HourTimer() {
        endTime = Date().addingTimeInterval(12 * 60 * 60) // 12 часов с текущего момента
        saveEndTime()
        startCountdown()
    }
    
    private func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        guard let endTime = endTime else { return }
        let currentTime = Date()
        let remainingTime = endTime.timeIntervalSince(currentTime)
        
        if remainingTime <= 0 {
            countdownTimer?.invalidate()
        } else {
            let hours = Int(remainingTime) / 3600
            let minutes = Int(remainingTime) % 3600 / 60
            let seconds = Int(remainingTime) % 60
            timeLabel.text = "\(String(format: "%02d:%02d:%02d", hours, minutes, seconds))".uppercased()
        }
    }
    
    private func saveEndTime() {
        UserDefaults.endTime = endTime
    }
    
    private func loadEndTime() {
        if let savedEndTime = UserDefaults.endTime {
            let currentTime = Date()
            if savedEndTime.timeIntervalSince(currentTime) > 0 {
                endTime = savedEndTime
                startCountdown()
            } else {
                endTime = nil
                UserDefaults.endTime = nil
            }
        }
    }
}

