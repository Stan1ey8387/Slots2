import UIKit

class DealView: UIView {
    private let valueChangeHandler: (Double) -> Void
    let minValue: Double
    private let step: Double
    
    var value: Double {
        didSet {
            label.text = Int(value).string
            valueChangeHandler(value.rounded(toPlaces: 1))
            
            if value <= minValue {
                minusButton.isEnabled(false)
            } else {
                minusButton.isEnabled(true)
            }
            
            if value >= UserDefaults.balance.double {
                plusButton.isEnabled(false)
            } else {
                plusButton.isEnabled(true)
            }
        }
    }
    
    private lazy var minusButton = UIView.button {
        self.value -= self.step
        SoundService.shared.playSound(named: .click)
    }.setupImage(.minus).size(45)
    
    private lazy var label = UIView.boldLabel("", fontSize: 16, textColor: .white).textAlignment(.center)
    
    private lazy var plusButton = UIView.button {
        self.value += self.step
        SoundService.shared.playSound(named: .click)
    }.setupImage(.plus).size(45)
    
    private lazy var maxBetButton = UIView.button {
        self.value = UserDefaults.balance.double
        self.fixDeal()
    }.setupImage(.maxBet).size(45)
    
    init(
        minValue: Double = 0,
        value: Double,
        step: Double = 10,
        valueChangeHandler: @escaping (Double) -> Void
    ) {
        self.minValue = minValue
        self.value = value
        self.step = step
        self.valueChangeHandler = valueChangeHandler
        super.init(frame: .zero)
        
        if value <= minValue {
            self.value = minValue
            minusButton.isEnabled(false)
        }
        
        if value == UserDefaults.balance.double {
            plusButton.isEnabled(false)
        }
        
        label.text = Int(self.value).string
        
        let stackView = UIView.horizontalStackView(views: [
            minusButton,
            .horizontalStackView(views: [label]).image(.frame96).height(45),
            plusButton,
            .emptyWidthView(width: 5),
            maxBetButton
        ]).spacing(5).distribution(.equalSpacing).alignment(.center).contentInset(.init(horizontal: 25, vertical: 0))
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.image(.backgroundForABet)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fixDeal() {
        if value >= UserDefaults.balance.double {
            value = UserDefaults.balance.double
        }
        
        if value < minValue {
            value = minValue
        }
        
        value += 0
    }
}
