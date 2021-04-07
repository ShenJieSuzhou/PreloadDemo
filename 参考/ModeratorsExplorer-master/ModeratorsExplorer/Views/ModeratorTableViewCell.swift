
import UIKit

class ModeratorTableViewCell: UITableViewCell {
  @IBOutlet var displayNameLabel: UILabel!
  @IBOutlet var reputationLabel: UILabel!
  @IBOutlet var reputationContainerView: UIView!
  @IBOutlet var indicatorView: UIActivityIndicatorView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    configure(with: .none)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    reputationContainerView.backgroundColor = .lightGray
    reputationContainerView.layer.cornerRadius = 6
    
    indicatorView.hidesWhenStopped = true
    indicatorView.color = ColorPalette.RWGreen
  }
  
  func configure(with moderator: Moderator?) {
    if let moderator = moderator {
      displayNameLabel?.text = moderator.displayName
      reputationLabel?.text = moderator.reputation
      displayNameLabel.alpha = 1
      reputationContainerView.alpha = 1
      indicatorView.stopAnimating()
    } else {
      displayNameLabel.alpha = 0
      reputationContainerView.alpha = 0
      indicatorView.startAnimating()
    }
  }
}
