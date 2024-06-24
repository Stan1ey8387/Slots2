import SnapKit

final class Оповещение: UIView {
    init(
        деньги: Int,
        обработчикНажатия: @escaping (Int) -> Void
    ) {
        super.init(frame: .zero)
        backgroundColor(.black.withAlphaComponent(0.8))
        
        let изображение = UIView.imageView(.alertViewCouins)
        addSubview(изображение)
        изображение.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(изображение.snp.width).multipliedBy(168.0 / 512.0)
        }
        
        let метка = UIView.boldLabel("\(деньги > 0 ? "+" : "") \(деньги)", fontSize: 23, textColor: .white)
        изображение.addSubview(метка)
        метка.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(15)
        }
        
        let кнопка = UIView.button {
            self.removeFromSuperview()
            обработчикНажатия(деньги)
        }.setupImage(.collect)
        кнопка.alpha = 0.0
        addSubview(кнопка)
        кнопка.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(изображение.snp.bottom).offset(10)
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalTo(изображение.snp.width).multipliedBy(141.0 / 420.0)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            кнопка.alpha = 1.0
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
