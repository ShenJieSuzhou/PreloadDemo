// The MIT License (MIT)
//
// Copyright (c) 2015-2021 Alexander Grebenyuk (github.com/kean).

import UIKit
import Nuke
import Gifu

// MARK: - AnimatedImageViewController

final class AnimatedImageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ImagePipeline.Configuration.isAnimatedImageDataEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(AnimatedImageCell.self, forCellWithReuseIdentifier: imageCellReuseID)
        collectionView?.backgroundColor = UIColor.systemBackground

        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 8
    }

    // MARK: Collection View

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        default: return imageURLs.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellReuseID, for: indexPath) as! AnimatedImageCell
        cell.setImage(with: imageURLs[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right
        return CGSize(width: width, height: width)
    }
}

private let imageCellReuseID = "imageCellReuseID"

// MARK: - Image URLs

private let root = "https://cloud.githubusercontent.com/assets"
private let imageURLs = [
    URL(string: "\(root)/1567433/6505557/77ff05ac-c2e7-11e4-9a09-ce5b7995cad0.gif")!,
    URL(string: "\(root)/1567433/6505565/8aa02c90-c2e7-11e4-8127-71df010ca06d.gif")!,
    URL(string: "\(root)/1567433/6505571/a28a6e2e-c2e7-11e4-8161-9f39cc3bb8df.gif")!,
    URL(string: "\(root)/1567433/6505576/b785a8ac-c2e7-11e4-831a-666e2b064b95.gif")!,
    URL(string: "\(root)/1567433/6505579/c88c77ca-c2e7-11e4-88ad-d98c7360602d.gif")!,
    URL(string: "\(root)/1567433/6505595/def06c06-c2e7-11e4-9cdf-d37d28618af0.gif")!,
    URL(string: "\(root)/1567433/6505634/26e5dad2-c2e8-11e4-89c3-3c3a63110ac0.gif")!,
    URL(string: "\(root)/1567433/6505643/42eb3ee8-c2e8-11e4-8666-ac9c8e1dc9b5.gif")!
]

// MARK: - AnimatedImageCell

private final class AnimatedImageCell: UICollectionViewCell {
    private let imageView: GIFImageView
    private let spinner: UIActivityIndicatorView
    private var task: ImageTask?

    override init(frame: CGRect) {
        imageView = GIFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        spinner = UIActivityIndicatorView(style: .medium)

        super.init(frame: frame)

        backgroundColor = UIColor(white: 235.0 / 255.0, alpha: 1.0)

        contentView.addSubview(imageView)
        contentView.addSubview(spinner)

        imageView.pinToSuperview()
        spinner.centerInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setImage(with url: URL) {
        let pipeline = ImagePipeline.shared
        let request = ImageRequest(url: url)

        if let image = pipeline.cachedImage(for: request) {
            return display(image)
        }

        spinner.startAnimating()
        task = pipeline.loadImage(with: request) { [weak self] result in
            self?.spinner.stopAnimating()
            if case let .success(response) = result {
                self?.display(response.container)
                self?.animateFadeIn()
            }
        }
    }

    private func display(_ container: Nuke.ImageContainer) {
        if let data = container.data {
            imageView.animate(withGIFData: data)
        } else {
            imageView.image = container.image
        }
    }

    private func animateFadeIn() {
        imageView.alpha = 0
        UIView.animate(withDuration: 0.33) { self.imageView.alpha = 1 }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        spinner.stopAnimating()
        imageView.prepareForReuse()
    }
}
