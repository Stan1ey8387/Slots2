import UIKit

class SlotsViewCell: UICollectionViewCell {
    static let identifier = "SlotsViewCell"
    let imageView = UIView.imageView("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor(.clear)
        
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        clipsToBounds = false
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

