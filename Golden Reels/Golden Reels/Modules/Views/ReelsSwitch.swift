import UIKit
import SnapKit

class ПереключательКатушек: UIView {
    private var включено: Bool {
        didSet {
            обработчикИзменения(включено)
        }
    }
    private let фоновоеИзображение: UIImageView
    private let изображениеПереключателя = UIView.imageView(.switchThumb)
    private let обработчикИзменения: (Bool) -> Void
    private var ведущийConstraint: Constraint?
    private var правыйConstraint: Constraint?
    
    init(включено: Bool, ширина: CGFloat = 100, обработчикИзменения: @escaping (Bool) -> Void) {
        self.включено = включено
        self.фоновоеИзображение = UIView.imageView(включено ? .switchOn : .switchOff)
        self.обработчикИзменения = обработчикИзменения
        super.init(frame: .zero)
        
        addTapGesture { [weak self] in
            self?.нажать()
        }
        
        addSubview(фоновоеИзображение)
        фоновоеИзображение.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(изображениеПереключателя)
        изображениеПереключателя.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            ведущийConstraint = make.leading.equalToSuperview().inset(6).constraint
            правыйConstraint = make.trailing.equalToSuperview().inset(6).constraint
            make.width.equalTo(изображениеПереключателя.snp.height)
        }
        
        self.snp.makeConstraints { make in
            make.width.equalTo(ширина)
            make.height.equalTo(self.snp.width).multipliedBy(79.9 / 140.0)
        }
        
        if включено {
            ведущийConstraint?.isActive = false
        } else {
            правыйConstraint?.isActive = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func нажать() {
        включено.toggle()
        
        UIView.animate(withDuration: 0.36) {
            if self.включено {
                self.фоновоеИзображение.image = .switchOn
                self.ведущийConstraint?.isActive = false
                self.правыйConstraint?.isActive = true
            } else {
                self.фоновоеИзображение.image = .switchOff
                self.ведущийConstraint?.isActive = true
                self.правыйConstraint?.isActive = false
            }
            
            self.layoutIfNeeded()
        }
    }
}

// Раскомментируйте и измените, если требуется дополнительный функционал

//extension UIView {
//    static func customSwitch(color: UIColor, tapHandler: @escaping (Bool) -> Void) -> UISwitch {
//        return CustomSwitch(color: color, tapHandler: tapHandler)
//    }
//}
