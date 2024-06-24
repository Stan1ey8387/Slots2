import SnapKit

final class Настройки: UIViewController {
    
    private lazy var меткаБаланса = UIView.boldLabel(UserDefaults.balance.string, fontSize: 12, textColor: .init(hex: 0xF3D980))
    private lazy var видБаланса = UIView.imageView(.balanceView)
    private lazy var кнопкаНазад = UIView.button {
        self.pop()
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.popButton)
    private lazy var видНастроек = UIView.imageView(.settingsView).isUserInteractionEnabled(true)
    private lazy var vstack = UIView.verticalStackView(
        views: [
            музыкаВид(),
            звукВид()
        ]
    ).spacing(15).distribution(.fillEqually)
    private lazy var изображениеКресуса = UIView.imageView(.queen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        настроитьВид()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        меткаБаланса.text = UserDefaults.balance.string
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
        
        view.addSubview(видНастроек)
        видНастроек.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().dividedBy(1.3)
            make.height.equalTo(видНастроек.snp.width).multipliedBy(616.0 / 663.0)
        }
        
        видНастроек.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        view.addSubview(изображениеКресуса)
        изображениеКресуса.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalToSuperview().dividedBy(1.7)
        }
    }
    
    private func музыкаВид() -> UIView {
        var переключатель = UserDefaults.isMusicEnabled
        
        let музыкаВид = UIView.imageView(.musicView)
        let hstack = UIView.horizontalStackView(
            views: [
                музыкаВид
            ]
        ).spacing(18)
        музыкаВид.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(музыкаВид.snp.width).multipliedBy(89.0 / 279.0)
        }
        let reelSwitch = ПереключательКатушек(включено: переключатель, ширина: 70) { _ in
            переключатель.toggle()
            UserDefaults.isMusicEnabled = переключатель
            switch переключатель {
            case true:
                СервисЗвука.общий.воспроизвестиМузыку()
            case false:
                СервисЗвука.общий.остановитьМузыку()
            }
            СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
        }
        hstack.addArrangedSubview(reelSwitch)
        
        return hstack
    }
    
    private func звукВид() -> UIView {
        var переключатель = UserDefaults.isSoundsEnabled
        let звукВид = UIView.imageView(.soundView)
        let hstack = UIView.horizontalStackView(
            views: [
                звукВид
            ]
        ).spacing(18)
        звукВид.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(звукВид.snp.width).multipliedBy(89.0 / 279.0)
        }
        let reelSwitch = ПереключательКатушек(включено: переключатель, ширина: 70) { _ in
            переключатель.toggle()
            UserDefaults.isSoundsEnabled = переключатель
            СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
        }
        hstack.addArrangedSubview(reelSwitch)
        
        return hstack
    }
}
