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
    
    override func layoutSubviews() {
        thumbImageView = UIImageView(frame: CGRect(x: (self.frame.size.width - 100)/2, y: 0, width: 100, height: 100))
        self.addSubview(thumbImageView!)
        
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

    func updateUI(_ image: UIImage?){
        DispatchQueue.main.async {
            self.displayImage(image: image)
        }
    }
    
    private func displayImage(image: UIImage?) {
        if let _image = image {
            thumbImageView?.image = _image
            loadingIndicator?.stopAnimating()
        } else {
            loadingIndicator?.startAnimating()
            thumbImageView?.image = .none
        }
    }
    
}
