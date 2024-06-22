import UIKit

class CustomSwitch: UISwitch {
    private let tapHandler: (Bool) -> Void
    
    init(color: UIColor, tapHandler: @escaping (Bool) -> Void) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        onTintColor = color
        
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonDidTap() {
        tapHandler(isOn)
    }
}

extension UIView {
    static func customSwitch(color: UIColor, tapHandler: @escaping (Bool) -> Void) -> UISwitch {
        return CustomSwitch(color: color, tapHandler: tapHandler)
    }
}

