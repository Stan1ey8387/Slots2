import SnapKit
import Darwin

final class ОсновнойКонтроллер: UIViewController {
    
    private lazy var меткаВремени = UIView.label("11:59:59".uppercased()).font(.monospacedDigitSystemFont(ofSize: 14, weight: .bold)).textColor(.init(hex: 0xF3D980)).textAlignment(.center)
    private lazy var изображениеБонусногоВремени = UIView.imageView(.bonusTime)
    private var таймерОбратногоОтсчета: Timer?
    private var времяОкончания: Date?
    private lazy var меткаБаланса = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .init(hex: 0xF3D980))
    private lazy var видБаланса = UIView.imageView(.balanceView)
    private lazy var кнопкаНастроек = UIView.button {
        self.push(Настройки())
    }.setupImage(.settingsButton)
    private lazy var изображениеЦезаря = UIView.imageView(.cresus1)
    private lazy var кнопкаИграть = UIView.button {
        self.push(КонтроллерИгры())
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.playGame)
    private lazy var кнопкаПолитики = UIView.button {
        //TODO: открыть политику
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.POLICY)
    private lazy var кнопкаВыхода = UIView.button {
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
        exit(0)
    }.setupImage(.QUIT_GAME)
    private lazy var вертикальнаяСтековаяПанель = UIView.verticalStackView(
        views: [
            кнопкаИграть,
            кнопкаПолитики,
            кнопкаВыхода
        ]
    ).spacing(5).distribution(.fillEqually).alignment(.center)
    private lazy var оповещение = Оповещение(деньги: 3000) { сумма in
        self.сохранитьДеньги(сумма)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        СервисЗвука.общий.воспроизвестиМузыку()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        настроитьВид()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        меткаБаланса.text = UserDefaults.balance.string
        
        загрузитьВремяОкончания()
        обновитьТаймер()
    }
    
    private func настроитьВид() {
        view.image(.mainViewController)
        view.addSubview(видБаланса)
        
        видБаланса.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(15)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(видБаланса.snp.width).multipliedBy(104.0 / 321.0)
        }
        
        видБаланса.addSubview(меткаБаланса)
        меткаБаланса.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(5)
        }
        
        view.addSubview(кнопкаНастроек)
        кнопкаНастроек.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(64)
            make.height.equalTo(кнопкаНастроек.snp.width).multipliedBy(129.15 / 129.36)
        }
        
        view.addSubview(изображениеБонусногоВремени)
        изображениеБонусногоВремени.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().dividedBy(6.5)
            make.height.equalTo(изображениеБонусногоВремени.snp.width).multipliedBy(136.0 / 144.0)
        }
        
        view.addSubview(меткаВремени)
        меткаВремени.snp.makeConstraints { make in
            make.top.equalTo(изображениеБонусногоВремени.snp.bottom).offset(10)
            make.centerX.equalTo(изображениеБонусногоВремени)
            make.width.equalToSuperview().dividedBy(5)
        }
        
        view.addSubview(изображениеЦезаря)
        изображениеЦезаря.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().dividedBy(1.3)
        }
        
        view.addSubview(вертикальнаяСтековаяПанель)
        вертикальнаяСтековаяПанель.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        кнопкаИграть.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(кнопкаИграть.snp.width).multipliedBy(168.0 / 607.0)
        }
        
        кнопкаПолитики.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(кнопкаИграть.snp.width).multipliedBy(168.0 / 607.0)
        }
        
        кнопкаВыхода.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(1.5)
            make.height.equalTo(кнопкаИграть.snp.width).multipliedBy(168.0 / 607.0)
        }
                
        оповещение.isHidden = UserDefaults.endTime != nil
        view.addSubview(оповещение)
        оповещение.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func сохранитьДеньги(_ деньги: Int) {
        UserDefaults.balance += деньги
        меткаБаланса.text = UserDefaults.balance.string
        оповещение.isHidden = true
        начать12ЧасовойТаймер()
    }
    
    private func начать12ЧасовойТаймер() {
        времяОкончания = Date().addingTimeInterval(12 * 60 * 60) // 12 часов с текущего момента
        сохранитьВремяОкончания()
        начатьОбратныйОтсчет()
    }
    
    private func начатьОбратныйОтсчет() {
        таймерОбратногоОтсчета?.invalidate()
        таймерОбратногоОтсчета = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(обновитьТаймер), userInfo: nil, repeats: true)
    }
    
    @objc private func обновитьТаймер() {
        guard let времяОкончания = времяОкончания else { return }
        let текущееВремя = Date()
        let оставшеесяВремя = времяОкончания.timeIntervalSince(текущееВремя)
        
        if (оставшеесяВремя <= 0) {
            таймерОбратногоОтсчета?.invalidate()
        } else {
            let часы = Int(оставшеесяВремя) / 3600
            let минуты = Int(оставшеесяВремя) % 3600 / 60
            let секунды = Int(оставшеесяВремя) % 60
            меткаВремени.text = "\(String(format: "%02d:%02d:%02d", часы, минуты, секунды))".uppercased()
        }
    }
    
    private func сохранитьВремяОкончания() {
        UserDefaults.endTime = времяОкончания
    }
    
    private func загрузитьВремяОкончания() {
        if let сохраненноеВремяОкончания = UserDefaults.endTime {
            let текущееВремя = Date()
            if (сохраненноеВремяОкончания.timeIntervalSince(текущееВремя) > 0) {
                времяОкончания = сохраненноеВремяОкончания
                начатьОбратныйОтсчет()
            } else {
                времяОкончания = nil
                UserDefaults.endTime = nil
            }
        }
    }
}
