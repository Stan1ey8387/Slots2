import SnapKit

struct МодельБонуса {
    let изображение: UIImage
    let умноженоНа: Int
}

final class Бонус: UIViewController {
    
    private let завершение: ((МодельБонуса) -> ())
    
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
    private lazy var изображениеКресуса = UIView.imageView(.queen)
    
    private lazy var видБонуса = UIView.imageView(.bonusView).isUserInteractionEnabled(true)

    private lazy var прокручиваемыйВид: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var страничныйКонтроль = PageView(
        count: 2,
        pageViewSettings: .init(
            selectedColor: .init(hex: 0xF3D980),
            unselectedColor: .init(hex: 0x790C8C)
        )
    )
    
    init(завершение: @escaping ((МодельБонуса) -> ())) {
        self.завершение = завершение
        super.init(nibName: nil, bundle: nil)
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
        меткаБаланса.text = UserDefaults.balance.string
    }
    
    private func кнопкаБонуса(_ изображение: UIImage, нажатие: @escaping (() -> ())) -> UIView {
        let кнопка = UIView.button {
            нажатие()
            self.pop()
        }.setupImage(изображение)
        let стек = UIView.centerStackView(views: [кнопка])
        кнопка.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(кнопка.snp.width).multipliedBy(109.0 / 341.0)
        }
        return стек
    }
    
    private func настроитьВид() {
        view.image(.mainViewController)
        
        let вертикальныеСтекВиды = [
            UIView.verticalStackView(
                views: [
                    кнопкаБонуса(.goldx10, нажатие: {
                        self.завершение(.init(изображение: .goldx10, умноженоНа: 10))
                    }),
                    кнопкаБонуса(.redx25, нажатие: {
                        self.завершение(.init(изображение: .redx25, умноженоНа: 25))
                    }),
                    кнопкаБонуса(.bluex50, нажатие: {
                        self.завершение(.init(изображение: .bluex50, умноженоНа: 50))
                    })
                ]
            ),
            .verticalStackView(
                views: [
                    кнопкаБонуса(.purplex10, нажатие: {
                        self.завершение(.init(изображение: .purplex10, умноженоНа: 10))
                    }),
                    кнопкаБонуса(.greenx25, нажатие: {
                        self.завершение(.init(изображение: .greenx25, умноженоНа: 25))
                    }),
                    кнопкаБонуса(.lightgreenx50, нажатие: {
                        self.завершение(.init(изображение: .lightgreenx50, умноженоНа: 50))
                    })
                ]
            ),
            .verticalStackView(
                views: [
                    кнопкаБонуса(.ringx10, нажатие: {
                        self.завершение(.init(изображение: .ringx10, умноженоНа: 10))
                    }),
                    кнопкаБонуса(.crownx25, нажатие: {
                        self.завершение(.init(изображение: .crownx25, умноженоНа: 25))
                    }),
                    кнопкаБонуса(.cupx50, нажатие: {
                        self.завершение(.init(изображение: .cupx50, умноженоНа: 50))
                    })
                ]
            )
        ]
        
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
        
        view.addSubview(видБонуса)
        видБонуса.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().dividedBy(1.3)
            make.height.equalTo(видБонуса.snp.width).multipliedBy(616.0 / 663.0)
        }
        
        видБонуса.addSubview(прокручиваемыйВид)
        прокручиваемыйВид.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        видБонуса.addSubview(страничныйКонтроль)
        страничныйКонтроль.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(изображениеКресуса)
        изображениеКресуса.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalToSuperview().dividedBy(1.7)
        }
        
        let горизонтальныйЭлементыВид = UIView.horizontalStackView(views: вертикальныеСтекВиды).distribution(.fillEqually).alignment(.center)
        прокручиваемыйВид.addSubview(горизонтальныйЭлементыВид)
        горизонтальныйЭлементыВид.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(вертикальныеСтекВиды.count)
        }
        вертикальныеСтекВиды.enumerated().forEach { index, view in
            view.spacing(10)
        }
    }
}

extension Бонус: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let текущаяСтраница = (scrollView.contentOffset.x / view.bounds.width)
        let текущийИндекс = Int(текущаяСтраница.rounded(.toNearestOrEven))
        страничныйКонтроль.currentIndex = текущийИндекс
    }
}
