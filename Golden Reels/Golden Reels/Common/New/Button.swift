import UIKit

class CustomButton: UIButton {
    private let tapHandler: () -> Void
    
    init(tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        titleLabel?.adjustsFontSizeToFitWidth = true
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                alpha = 0.4
            }
            else {
                alpha = 1
            }
            super.isHighlighted = newValue
        }
    }
    
    @objc private func buttonDidTap() {
        tapHandler()
    }
}

extension UIView {
    static func button(tapHandler: @escaping () -> Void) -> UIButton {
        return CustomButton(tapHandler: tapHandler)
    }
}


extension UIButton {
    @discardableResult
    func setupTitle(_ text: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(text, for: state)
        return self
    }
    
    @discardableResult
    func setupImage(_ image: UIImage, for state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func setupImage(_ name: String, for state: UIControl.State = .normal) -> Self {
        self.setImage(.init(named: name), for: state)
        return self
    }
    
    @discardableResult
    func setupTextColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func setupFont(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func isEnabled(_ isEnabled: Bool, alpha: CGFloat = 0.6) -> Self {
        self.alpha = isEnabled ? 1 : alpha
        self.isEnabled = isEnabled
        return self
    }
}
