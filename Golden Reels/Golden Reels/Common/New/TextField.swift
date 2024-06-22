import UIKit

class CustomTextField: UITextField {
    private let textChangeHandler: (String) -> Void
    private let maxLeght: Int?
    private let datePickerMode: UIDatePicker.Mode?
    
    init(
        maxLeght: Int? = nil,
        placeholder: String = "",
        placeholderColor: UIColor? = .black,
        keyboardType: UIKeyboardType? = nil,
        datePickerMode: UIDatePicker.Mode? = nil,
        textChangeHandler: @escaping (String) -> Void
    ) {
        self.maxLeght = maxLeght
        self.datePickerMode = datePickerMode
        self.textChangeHandler = textChangeHandler
        super.init(frame: .zero)
        
        delegate = self
        self.keyboardType = keyboardType ?? .default
        tintColor = .gray
        font = .systemFont(ofSize: 16)
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? .black]
        )
        
        if let datePickerMode = datePickerMode {
            let picker = CustomDatePicker(mode: datePickerMode) { [weak self] date in
                let formate: String
                
                if datePickerMode == .time {
                    formate = "HH:mm"
                } else {
                    formate = "MM.dd.yyyy"
                }
                
                self?.text = date.formate(formate)
                self?.textChangeHandler(date.formate(formate))
            }
            picker.alpha = 0.1
            addSubview(picker)
            picker.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(14)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textChangeHandler(textField.text ?? "")
    }
}

extension UITextField {
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let maxLeght = maxLeght else { return true }
        
        let newLength = text.count + string.count - range.length
        return newLength <= maxLeght
    }
}
