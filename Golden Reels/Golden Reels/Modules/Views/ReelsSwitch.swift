import UIKit
import SnapKit

class ReelsSwitch: UIView {
    private var isOn: Bool {
        didSet {
            changeHandler(isOn)
        }
    }
    private let backgroundImageView: UIImageView
    private let thumbImageView = UIView.imageView(.switchThumb)
    private let changeHandler: (Bool) -> Void
    private var thumbLeftConstraint: Constraint?
    private var thumbRigthConstraint: Constraint?
    
    init(isOn: Bool, width: CGFloat = 100, changeHandler: @escaping (Bool) -> Void) {
        self.isOn = isOn
        self.backgroundImageView = UIView.imageView(isOn ? .switchOn : .switchOff)
        self.changeHandler = changeHandler
        super.init(frame: .zero)
        
        addTapGesture { [weak self] in
            self?.didTap()
        }
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            thumbLeftConstraint = make.leading.equalToSuperview().inset(6).constraint
            thumbRigthConstraint = make.trailing.equalToSuperview().inset(6).constraint
            make.width.equalTo(thumbImageView.snp.height)
        }
        
        self.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(self.snp.width).multipliedBy(79.9 / 140.0)
        }
        
        if isOn {
            thumbLeftConstraint?.isActive = false
        } else {
            thumbRigthConstraint?.isActive = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTap() {
        isOn.toggle()
        
        UIView.animate(withDuration: 0.36) {
            if self.isOn {
                self.backgroundImageView.image = .switchOn
                self.thumbLeftConstraint?.isActive = false
                self.thumbRigthConstraint?.isActive = true
            } else {
                self.backgroundImageView.image = .switchOff
                self.thumbLeftConstraint?.isActive = true
                self.thumbRigthConstraint?.isActive = false
            }
            
            self.layoutIfNeeded()
        }
    }
}

//extension UIView {
//    static func customSwitch(color: UIColor, tapHandler: @escaping (Bool) -> Void) -> UISwitch {
//        return CustomSwitch(color: color, tapHandler: tapHandler)
//    }
//}
