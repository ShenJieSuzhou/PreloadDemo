//
//  ProloadTableViewCell.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import UIKit

class ProloadTableViewCell: UITableViewCell {
    private var loadingIndicator: UIActivityIndicatorView?
    private var thumbImageView: UIImageView?
    private var order: UILabel?
    
    
    override func layoutSubviews() {
        self.backgroundColor = .black
        thumbImageView = UIImageView(frame: CGRect(x: (self.frame.size.width - 100)/2, y: 0, width: 100, height: 100))
        self.addSubview(thumbImageView!)
        
        order = UILabel(frame: CGRect(x: 20, y: 0, width: 30, height: self.frame.size.height))
        order?.tintColor = .black
        order?.textAlignment = .center
        order?.textColor = .black
        self.addSubview(order!)
        
        loadingIndicator = UIActivityIndicatorView(frame: self.frame)
        loadingIndicator?.color = .blue
        loadingIndicator?.startAnimating()
        self.addSubview(loadingIndicator!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(_ image: UIImage?, orderNo: String){
        DispatchQueue.main.async {
            self.displayImage(image: image, orderNo: orderNo)
        }
    }
    
    private func displayImage(image: UIImage?, orderNo: String) {
        if let _image = image {
            thumbImageView?.image = _image
            order?.text = orderNo
            loadingIndicator?.stopAnimating()
        } else {
            loadingIndicator?.startAnimating()
            order?.text = orderNo
            thumbImageView?.image = .none
        }
    }
    
}
