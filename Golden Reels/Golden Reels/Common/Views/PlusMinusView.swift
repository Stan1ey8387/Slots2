import UIKit

class PlusMinusView: UIView {
    private let valueChangeHandler: (Double) -> Void
    private let minValue: Double
    private let step: Double
    private let maxValue: Double?
    
    private var value: Double {
        didSet {
            label.text = Int(value).string
            valueChangeHandler(value.rounded(toPlaces: 1))
            
            if value == minValue {
                minusButton.isEnabled(false)
            } else {
                minusButton.isEnabled(true)
            }
            
            if let maxValue = maxValue, value >= maxValue {
                plusButton.isEnabled(false)
            } else {
                plusButton.isEnabled(true)
            }
        }
    }
    
    private lazy var minusButton = UIView.button {
        self.value -= self.step
    }.setupImage("")
    
    private lazy var label = UIView.boldLabel("", fontSize: 16, textColor: .white).textAlignment(.center)
    
    private lazy var plusButton = UIView.button {
        self.value += self.step
    }.setupImage("")
    
    init(
        minValue: Double = 0,
        maxValue: Double? = nil,
        value: Double,
        step: Double = 1,
        valueChangeHandler: @escaping (Double) -> Void
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.value = value
        self.step = step
        self.valueChangeHandler = valueChangeHandler
        super.init(frame: .zero)
        
        label.text = Int(value).string
        
        if value == minValue {
            minusButton.isEnabled(false)
        }
        
        if value == maxValue {
            plusButton.isEnabled(false)
        }
        
        let stackView = UIView.horizontalStackView(views: [
            minusButton,
            .horizontalStackView(views: [label]),
            plusButton
        ]).spacing(5).distribution(.equalSpacing)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
