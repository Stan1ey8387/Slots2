import UIKit

class CustomDatePicker: UIDatePicker {
    private let dateChangeHandler: (Date) -> Void
    
    init(mode: UIDatePicker.Mode, preferredDatePickerStyle: UIDatePickerStyle? = nil, dateChangeHandler: @escaping (Date) -> Void) {
        self.dateChangeHandler = dateChangeHandler
        super.init(frame: .zero)
        
        self.overrideUserInterfaceStyle = .dark
        self.datePickerMode = mode
        if let preferredDatePickerStyle = preferredDatePickerStyle {
            self.preferredDatePickerStyle = preferredDatePickerStyle
        }
        addTarget(self, action: #selector(textFieldDidChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ datePicker: UIDatePicker) {
        dateChangeHandler(datePicker.date)
    }
}
