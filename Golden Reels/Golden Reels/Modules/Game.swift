import SnapKit

final class КонтроллерИгры: UIViewController {
    // MARK: Свойства
    
    private var текущаяСтавка: Double = min(200, UserDefaults.balance.double)
    private var множительБонуса = 1
    private var изображениеБонуса: UIImage?
    
    // MARK: UI элементы
    private lazy var меткаБаланса = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .white)
    private lazy var видБаланса = UIView.imageView(.balanceView)
    private lazy var кнопкаНазад = UIView.button {
        self.pop()
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.popButton)
    private lazy var кнопкаНастроек = UIView.button {
        self.push(Настройки())
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.settingsButton)
    
    private lazy var кнопкаБонуса = UIView.button {
        self.нажатаКнопкаБонуса()
    }.setupImage(.bonus)
    
    private func нажатаКнопкаБонуса() {
        self.push(Бонус(завершение: { модель in
            self.изображениеБонуса = модель.изображение
            self.множительБонуса = модель.умноженоНа
            self.кнопкаБонуса.setupImage(модель.изображение)
        }))
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }
    
    private lazy var видСтавки = СделкаView(
        минимальноеЗначение: 10,
        значение: текущаяСтавка,
        шаг: 10
    ) { [weak self] ставка in
        self?.текущаяСтавка = ставка
    }
    
    private lazy var кнопкаВращения = UIView.button { [weak self] in
        guard let self = self else { return }
        self.текущаяСтавка = self.видСтавки.значение
        self.видСлотов.spin { результат in
            СервисЗвука.общий.воспроизвестиЗвук(название: .выигрыш)
            var множитель = результат.multiplier
            if результат.images.contains(where: { $0 == self.изображениеБонуса }) {
                множитель *= self.множительБонуса
            }
            
            if множитель == 0 {
                if UserDefaults.balance.double > self.текущаяСтавка {
                    UserDefaults.balance -= Int(self.текущаяСтавка)
                } else {
                    UserDefaults.balance = Int(self.видСтавки.минимальноеЗначение)
                }
                print("<<< проигрыш = \(self.текущаяСтавка)")
                let оповещение = Оповещение(деньги: -Int(self.текущаяСтавка)) { _ in }
                self.view.addSubview(оповещение)
                оповещение.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
            } else {
                let выигрыш = Int(self.текущаяСтавка) * множитель
                print("<<< выигрыш = \(выигрыш)")
                UserDefaults.balance += выигрыш
                
                let оповещение = Оповещение(деньги: выигрыш) { _ in }
                self.view.addSubview(оповещение)
                оповещение.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            
            self.меткаБаланса.text = UserDefaults.balance.string
            self.видСтавки.зафиксироватьСделку()
            
            if self.изображениеБонуса != nil {
                // Отключить бонус после использования
                self.кнопкаБонуса.isHidden = true
                self.изображениеБонуса = nil
                self.множительБонуса = 1
            }
        }
    }.setupImage(.spin)
    
    private lazy var видСлотов = SlotsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        настроитьВид()
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
        
        view.addSubview(кнопкаНазад)
        кнопкаНазад.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(64)
            make.height.equalTo(кнопкаНазад.snp.width).multipliedBy(129.15 / 129.36)
        }
        
        view.addSubview(кнопкаНастроек)
        кнопкаНастроек.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(64)
            make.height.equalTo(кнопкаНастроек.snp.width).multipliedBy(129.15 / 129.36)
        }
        
        view.addSubview(видСлотов)
        видСлотов.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(видСлотов.snp.width)
        }
        
        let изображениеБога = UIView.imageView(.cresus1)
        view.addSubview(изображениеБога)
        изображениеБога.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.6)
            make.height.equalTo(изображениеБога.snp.width).multipliedBy(882.0 / 344.0)
        }
        
        view.addSubview(видСтавки)
        видСтавки.snp.makeConstraints { make in
            make.top.equalTo(видСлотов.snp.bottom).inset(-30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(видСтавки.snp.width).multipliedBy(215.0 / 725.0)
        }
        
        view.addSubview(кнопкаВращения)
        кнопкаВращения.snp.makeConstraints { make in
            make.top.equalTo(видСтавки.snp.bottom).inset(-30)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalTo(кнопкаВращения.snp.width).multipliedBy(173.0 / 219)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(кнопкаБонуса)
        кнопкаБонуса.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalTo(кнопкаБонуса.snp.width).multipliedBy(88.0 / 263.0)
            make.trailing.equalTo(видСлотов).inset(20)
            make.bottom.equalTo(видСлотов.snp.top)
        }
    }
}
