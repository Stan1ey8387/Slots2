import UIKit

class СделкаView: UIView {
    private let обработчикИзмененияЗначения: (Double) -> Void
    let минимальноеЗначение: Double
    private let шаг: Double
    
    var значение: Double {
        didSet {
            метка.text = Int(значение).string
            обработчикИзмененияЗначения(значение.rounded(toPlaces: 1))
            
            if значение <= минимальноеЗначение {
                минусКнопка.isEnabled(false)
            } else {
                минусКнопка.isEnabled(true)
            }
            
            if значение >= UserDefaults.balance.double {
                плюсКнопка.isEnabled(false)
            } else {
                плюсКнопка.isEnabled(true)
            }
        }
    }
    
    private lazy var минусКнопка = UIView.button {
        self.значение -= self.шаг
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.minus).size(45)
    
    private lazy var метка = UIView.boldLabel("", fontSize: 16, textColor: .white).textAlignment(.center)
    
    private lazy var плюсКнопка = UIView.button {
        self.значение += self.шаг
        СервисЗвука.общий.воспроизвестиЗвук(название: .клик)
    }.setupImage(.plus).size(45)
    
    private lazy var максимальнаяСтавкаКнопка = UIView.button {
        self.значение = UserDefaults.balance.double
        self.зафиксироватьСделку()
    }.setupImage(.maxBet).size(45)
    
    init(
        минимальноеЗначение: Double = 0,
        значение: Double,
        шаг: Double = 10,
        обработчикИзмененияЗначения: @escaping (Double) -> Void
    ) {
        self.минимальноеЗначение = минимальноеЗначение
        self.значение = значение
        self.шаг = шаг
        self.обработчикИзмененияЗначения = обработчикИзмененияЗначения
        super.init(frame: .zero)
        
        if значение <= минимальноеЗначение {
            self.значение = минимальноеЗначение
            минусКнопка.isEnabled(false)
        }
        
        if значение == UserDefaults.balance.double {
            плюсКнопка.isEnabled(false)
        }
        
        метка.text = Int(self.значение).string
        
        let стекВид = UIView.horizontalStackView(views: [
            минусКнопка,
            .horizontalStackView(views: [метка]).image(.frame96).height(45),
            плюсКнопка,
            .emptyWidthView(width: 5),
            максимальнаяСтавкаКнопка
        ]).spacing(5).distribution(.equalSpacing).alignment(.center).contentInset(.init(horizontal: 25, vertical: 0))
        
        addSubview(стекВид)
        стекВид.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.image(.backgroundForABet)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func зафиксироватьСделку() {
        if значение >= UserDefaults.balance.double {
            значение = UserDefaults.balance.double
        }
        
        if значение < минимальноеЗначение {
            значение = минимальноеЗначение
        }
        
        значение += 0
    }
}
