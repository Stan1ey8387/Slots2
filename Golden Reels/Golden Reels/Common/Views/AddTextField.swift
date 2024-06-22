import UIKit

class AddTextFieldView: UIView {
    private let textChangeHandler: ((String) -> Void)?
    
    private let title: String
    private let placeholderText: String
    private let imageName: String?
    private let datePickerMode: UIDatePicker.Mode?
    
    private lazy var titleLabel = UIView.systemLabel(title, fontSize: 12, textColor: .white)
    private(set) lazy var placeholderLabel = UIView.systemLabel(placeholderText, fontSize: 16, textColor: .init(hex: 0x898B89))
    
    private(set) lazy var textField = CustomTextField { [weak self] text in
        guard let self = self else { return }
        if text == "" {
            self.placeholderLabel.isHidden = false
        } else {
            self.placeholderLabel.isHidden = true
        }
        
        self.textChangeHandler?(text)
    }
    
    init(
        title: String = "",
        titleColor: UIColor = .white,
        text: String? = nil,
        placeholderText: String,
        imageName: String? = nil,
        keyboardType: UIKeyboardType? = nil,
        datePickerMode: UIDatePicker.Mode? = nil,
        textChangeHandler: ((String) -> Void)? = nil
    ) {
        self.textChangeHandler = textChangeHandler
        self.title = title
        self.placeholderText = placeholderText
        self.datePickerMode = datePickerMode
        self.imageName = imageName
        super.init(frame: .zero)
        self.titleLabel.textColor(titleColor)
        setupView()
        // SETUP
        textField.textColor = .white
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
        }
        
        if let text = text {
            if datePickerMode == nil {
                placeholderLabel.text = ""
            } else {
                placeholderLabel.text = text
                placeholderLabel.textColor = textField.textColor ?? .black
            }
            textField.text = text
        }
        
        // Text aligment
//        textField.textAlignment = .center
//        placeholderLabel.textAlignment = .center
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        backgroundColor = .white
//        cornerRadius(10)
        textField.placeholder = ""
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
        }
        
        let view = UIView.empty()//.backgroundColor(.init(hex: 0x353535))
        
        if let imageName = imageName {
            let imageView = UIView.imageView(imageName)//.setColor(.init(hex: 0xD4B57F))
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(14)
                make.centerY.equalToSuperview()
                make.size.equalTo(14)
            }
        }
        
        if let datePickerMode = datePickerMode {
            let picker = CustomDatePicker(mode: datePickerMode) { [weak self] date in
                let formate: String
                
                if datePickerMode == .time {
                    formate = "HH:mm"
                } else {
                    formate = "MM.dd.yyyy"
                }
                
                self?.placeholderLabel.text = date.formate(formate)
                self?.placeholderLabel.textColor = self?.textField.textColor ?? .black
                self?.textChangeHandler?(date.formate(formate))
            }
            picker.alpha = 0.1
            view.addSubview(picker)
            picker.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            if imageName == nil {
                make.trailing.equalToSuperview().inset(14)
            } else {
                make.trailing.equalToSuperview().inset(8 + 14 + 8)
            }
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        
        if datePickerMode == nil {
            view.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.centerY.equalTo(placeholderLabel)
                make.leading.trailing.equalTo(placeholderLabel)
            }
        }
        view.backgroundColor(.init(hex: 0x1E2021)).cornerRadius(8).height(46)
//        view.applyBorder(color: .init(hex: 0xFE9505), width: 1)
        placeholderLabel.backgroundColor(.init(hex: 0x1E2021))
        
        addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-6)
//            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(34)
        }
        
//        let lineView = UIView.empty().height(1).backgroundColor(.init(hex: 0x898B89))
//        view.addSubview(lineView)
//        lineView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//        }
    }
}
