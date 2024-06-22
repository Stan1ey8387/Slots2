import UIKit

class CustomTextView: UITextView {
    enum Constants {
        static let textColor = UIColor.black
        static let placeholederColor = UIColor.white.withAlphaComponent(0.6)
        static let placeholederText = """
        Write text...
        """
    }
    
    private let textChangeHandler: (String) -> Void
    private let maxLeght: Int?
    
    init(maxLeght: Int? = nil, textChangeHandler: @escaping (String) -> Void) {
        self.maxLeght = maxLeght
        self.textChangeHandler = textChangeHandler
        super.init(frame: .zero, textContainer: nil)
        
        textColor = Constants.textColor
        delegate = self
        backgroundColor(.black)
        font = .systemFont(ofSize: 12)
        
        text = Constants.placeholederText
        textColor = Constants.placeholederColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextView {
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

extension CustomTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChangeHandler(textView.text ?? "")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.placeholederText {
            textView.text = nil
            textView.textColor = Constants.textColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholederText
            textView.textColor = Constants.placeholederColor
        }
    }
    
//    func textView(
//        _ textView: UITextView,
//        shouldChangeTextIn range: NSRange,
//        replacementText text: String
//    ) -> Bool {
//        let maxLength = 40
//        let currentText = textView.text as NSString
//        let newText = currentText.replacingCharacters(in: range, with: text)
//        return newText.count <= maxLength
//    }
}
