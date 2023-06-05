//
//  DetailViewController.swift
//  Test ML
//
//  Created by Juan Esteban Pelaez on 16/11/21.
//

import UIKit
import SDWebImage
import ImageSlideshow
import SkeletonView

class DetailViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelOriginalPrice: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCondition: UILabel!
    @IBOutlet weak var labelWarranty: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!

    @IBAction func openAtrributes(_ sender: UIButton) {
        openAttributes()
    }

    var productResult: ResultItem?
    var viewModel = DetailViewModel()

    private var viewDidAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViewModel()
        self.updateBasicUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.viewDidAppear {
            view.showAnimatedGradientSkeleton()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppear = true
    }

}
// MARK: - Private Methods
extension DetailViewController {

    private func initViewModel() {

        self.viewModel.reloadUI = {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }

        self.viewModel.reloadUIDescription = {
            DispatchQueue.main.async {
                self.updateUIDescription()
            }
        }
    }

    // cargar campos basicos de UI
    private func updateBasicUI() {
        if let productResult = self.productResult {
            self.labelTitle.text = productResult.title
            self.updateUIPrice(price: productResult.price)

            // Llamar servicios para obtener informacion detallada
            self.viewModel.detailProductFromService(id: productResult.id)
        }
    }

    // Abrir vista de atributos
    private func openAttributes() {
        guard let attributes = self.viewModel.product?.attributes, !attributes.isEmpty else {
            return
        }
        let attributesVC = AttributesUITableViewController()
        attributesVC.attributes = attributes
        self.navigationController?.pushViewController(attributesVC, animated: true)
    }

    // Actualizar UI
    private func updateUI() {
        if let product =  self.viewModel.product {

            view.hideSkeleton()

            self.configureImageSlideUI(pictures: product.pictures)

            if let priceOriginal = product.originalPrice, priceOriginal != product.price, let str = self.viewModel.currencyFormatter.string(from: NSNumber(value: priceOriginal)) {
                let attributedString = NSMutableAttributedString(string: "$ \(str)")
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))

                let valueDiscount = (Double(product.price-priceOriginal)/Double(priceOriginal))*(-100)
                self.labelDiscount.text = "\(Int(valueDiscount))% OFF"

                self.labelOriginalPrice.attributedText = attributedString
                self.labelOriginalPrice.isHidden = false
            }

            self.labelCondition.isHidden = product.condition != "new"
            self.labelWarranty.text = product.warranty

            self.viewModel.detailProductDescriptionFromService(id: product.id)
        }
    }

    // Actualizar descripcion
    private func updateUIDescription() {
        self.labelDescription.text = self.viewModel.productDescription
    }

    // Actualizar precioAnterior
    private func updateUIPrice(price: Int) {
        if let str = self.viewModel.currencyFormatter.string(from: NSNumber(value: price)) {
            self.labelPrice.text = "$ \(str)"
        }
    }

    // Configurar el imageSlide
    private func configureImageSlideUI(pictures: [Picture]) {

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        pageControl.pageIndicatorTintColor = UIColor.lightGray

        self.imageSlideshow.pageIndicator = pageControl
        self.imageSlideshow.activityIndicator = DefaultActivityIndicator()

        self.imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        self.imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFit

        var images: [SDWebImageSource] = []

        pictures.forEach({ urlImage in
            if let imageSource = SDWebImageSource(urlString: urlImage.secureURL, placeholder: UIImage()) {
                images.append(imageSource)
            }
        })

        self.imageSlideshow.setImageInputs(images)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.imageSlideshow.addGestureRecognizer(recognizer)
    }

    @objc func didTap() {
        let fullScreenController = self.imageSlideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        fullScreenController.closeButton.tintColor = .white
        fullScreenController.closeButton.backgroundColor = .black.withAlphaComponent(0.4)
        fullScreenController.closeButton.layer.cornerRadius = 20
    }

}
