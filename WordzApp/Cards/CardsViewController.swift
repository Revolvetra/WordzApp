import UIKit
import GoogleMobileAds

protocol CardInteractionController: class {
    func enableSwipeButtons(isEnabled enabled: Bool)
    func updateSwipedCard(isFamilarWordSwiped: Bool)
    func returnBack()
}

// MARK:- Global Refactor
final class CardsViewController: UIViewController {
    var bannerView: GADBannerView!
    
    // MARK:- Outlets
    public var category: Category?
    
    public var sentences = [Sentence]()
    public var learnedSentences = [Sentence]()
    
    private var adStackView: UIStackView!
    private var tmp1StackView: UIStackView!
    private var cardContentStackView: UIStackView!
    private var cardButtonsStackView: UIStackView!
    private var cardsStackView: UIStackView!
    private var tmp2StackView: UIStackView!
    private var overallStackView: UIStackView!
    
    private let backButton: UIButton = {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        backButton.setImage(UIImage(named: "leftArrowFatIcon"), for: .normal)
        backButton.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0, blue: 1, alpha: 1)
        backButton.layer.cornerRadius = 8
        backButton.layer.shadowColor = UIColor.appColor(.buttonShadow_purple_darkpurple)?.cgColor
        backButton.layer.shadowRadius = 3
        backButton.layer.shadowOpacity = 0.5
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        return backButton
    }()
    
    private let settingsButton: UIButton = {
        let settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        settingsButton.setImage(UIImage(named: "threePointsIcon"), for: .normal)
        settingsButton.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0, blue: 1, alpha: 1)
        settingsButton.layer.cornerRadius = 8
        settingsButton.layer.shadowColor = #colorLiteral(red: 0.3647058824, green: 0.4156862745, blue: 0.9764705882, alpha: 1)
        settingsButton.layer.shadowRadius = 3
        settingsButton.layer.shadowOpacity = 0.5
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        return settingsButton
    }()
    
    private let swipeLeftButton: UIButton = {
        let swipeLeftButton = UIButton()
        swipeLeftButton.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 23)
        swipeLeftButton.setTitle("Я не знаю\nэто слово", for: .normal)
        swipeLeftButton.titleLabel?.numberOfLines = 2
        swipeLeftButton.setTitleColor(UIColor.appColor(.button_white_x2lighthray), for: .normal)
        swipeLeftButton.setTitleColor(#colorLiteral(red: 0.006038194057, green: 0.06411762536, blue: 0.6732754707, alpha: 1), for: .highlighted)
        swipeLeftButton.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.09411764706, blue: 1, alpha: 1)
        swipeLeftButton.clipsToBounds = false
        swipeLeftButton.translatesAutoresizingMaskIntoConstraints = false
        swipeLeftButton.layer.shadowColor = #colorLiteral(red: 0.3647058824, green: 0.4156862745, blue: 0.9764705882, alpha: 1)
        swipeLeftButton.layer.shadowRadius = 5
        swipeLeftButton.layer.shadowOpacity = 0.2
        swipeLeftButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        swipeLeftButton.titleLabel?.textAlignment = .center
        
        let right = UIImage(named: "leftSwipeArrow")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: right)
        imgView.tintColor = UIColor.appColor(.button_white_x2lighthray)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        swipeLeftButton.addSubview(imgView)
        
        imgView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imgView.centerYAnchor.constraint(equalTo: swipeLeftButton.centerYAnchor).isActive = true
        imgView.rightAnchor.constraint(equalTo: swipeLeftButton.rightAnchor, constant: -12).isActive = true
        return swipeLeftButton
    }()
    
    private let swipeRightButton: UIButton = {
        let swipeRightButton = UIButton()
        swipeRightButton.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: 23)
        swipeRightButton.setTitle("Я знаю\nэто слово", for: .normal)
        swipeRightButton.titleLabel?.numberOfLines = 2
        swipeRightButton.setTitleColor(UIColor.appColor(.buttonText_blue_white), for: .normal)
        swipeRightButton.setTitleColor(#colorLiteral(red: 0.3647058824, green: 0.4156862745, blue: 0.9764705882, alpha: 1), for: .highlighted)
        swipeRightButton.backgroundColor = UIColor.appColor(.white_lightgray)
        swipeRightButton.clipsToBounds = false
        swipeRightButton.translatesAutoresizingMaskIntoConstraints = false
        swipeRightButton.layer.shadowColor = #colorLiteral(red: 0.3647058824, green: 0.4156862745, blue: 0.9764705882, alpha: 1)
        swipeRightButton.layer.shadowRadius = 5
        swipeRightButton.layer.shadowOpacity = 0.2
        swipeRightButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        swipeRightButton.titleLabel?.textAlignment = .center
        let right = UIImage(named: "rightSwipeArrow")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: right)
        imgView.tintColor = UIColor.appColor(.buttonText_blue_white)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        swipeRightButton.addSubview(imgView)
        
        imgView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imgView.centerYAnchor.constraint(equalTo: swipeRightButton.centerYAnchor).isActive = true
        imgView.leftAnchor.constraint(equalTo: swipeRightButton.leftAnchor, constant: 12).isActive = true
        
        return swipeRightButton
    }()
    
    private var circle1 : UIView!
    private var loadingView: CardLoadingView!
    
    private var result = (unfamilarWords: 0, familarWords: 0)
    
    private var cardsView = [CardView]()
    private var oneCardView: CardResultView!
    
    public var words = [Word]()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performActionWithLoadingView(isNeedToShow: true)
        
        setupLayout()
        setupNavigationBar()
        
        setupStackViews()
        if (Purchases.fullVersion == false) {
            setupAd()
        }
    }
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK:- TODO Add refactor
        if TeachUserDefaults.showSwipeAlerts < 2 {
            TeachUserDefaults.addTeachSwipes()
            
            let action = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
            let alert = UIAlertController(title: "Свайпайте карточки", message: "Вы можете свайпать карточки вправо и влево. А также можете нажимать на кнопки, которые находятся ниже карточек со словами", preferredStyle: .alert)
            alert.addAction(action)
            let queue = DispatchQueue(label: "Alert")
            queue.asyncAfter(wallDeadline: .now() + .seconds(1)) {
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
//        TeachUserDefaults.showSwipeAlerts = 0
        fillCards()
    }
    
    private func setupAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        // REAL AD BANNER
        bannerView.adUnitID = "ca-app-pub-5331338247155415/3531927651"
        
        
        // TEST AD
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        self.view.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK:- Fill Cards Logic
    private func fillCards() {
        let frame = cardContentStackView.frame
        
        oneCardView = CardResultView(frame: frame, view: self)
        oneCardView.layer.shadowColor = UIColor.appColor(.buttonShadow_purple_darkpurple_alpha)?.cgColor
        oneCardView.layer.shadowRadius = 3
        oneCardView.layer.shadowOpacity = 0.5
        oneCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContentStackView.addSubview(oneCardView)
        oneCardView.finishButton.isEnabled = false
        
        for i in 0..<sentences.count-1 {
            let number1 = Int.random(in: 0..<sentences.count-1)
            let tmp = sentences[i]
            sentences[i] = sentences[number1]
            sentences[number1] = tmp
        }
        
        sentences.forEach { (sentence) in
            let cardView = CardView(frame: frame, sentence: sentence, view: self)
            cardView.setupLabels()
            cardView.isHidden = true
            self.cardsView.append(cardView)
            cardView.isUserInteractionEnabled = false
            cardContentStackView.addSubview(cardView)
        }
        
        if cardsView.count > 2 {
            cardsView[cardsView.count - 1].isHidden = false
            cardsView[cardsView.count - 2].isHidden = false
            cardsView.last?.isUserInteractionEnabled = true
        }
        
        performActionWithLoadingView(isNeedToShow: false)
    }
    
    //MARK:- Fetch Sentences
    public func fetchSentences() -> [Sentence] {
        let sentences = CoreDataManager.shared.fetchNotLearnedSentences(category: category)
        let shuffledSentences = sentences[randomPick: CardsSettings.сardsInPack as Int]
        return shuffledSentences
    }
    
    // MARK:- LoadingView control method
    private func performActionWithLoadingView(isNeedToShow state: Bool) {
        if (state == true) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            loadingView = CardLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            window?.addSubview(loadingView)
        } else {
            loadingView.stopLoading()
            let duration: Int = 1
            UIView.animate(withDuration: Double(duration) / 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.loadingView.alpha = 0
                let queue = DispatchQueue.global()
                queue.asyncAfter(deadline: .now() + .seconds(Int(duration))) {
                    DispatchQueue.main.async {
                        self.loadingView.removeFromSuperview()
                        self.loadingView = nil
                    }
                }
            }, completion: nil)
        }
    }
    
    // MARK:- Setups
    private func setupLayout() {
        self.view.backgroundColor = UIColor.appColor(.lightyellow_darkgray)
        setupDesign()
    }
    
    private func setupDesign() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let circle1Height = CGFloat(height / 2.5)
        
        self.circle1 = UIView(frame: CGRect(x: (-1 ) * circle1Height / 1.8, y: height * (1/5), width: circle1Height, height: circle1Height))
        circle1.layer.cornerRadius = circle1Height / 2
        circle1.clipsToBounds = true
        circle1.backgroundColor = #colorLiteral(red: 0, green: 0.08235294118, blue: 1, alpha: 1)
        
        let circle2Height = CGFloat(height / 3.5)
        
        let circle2 = UIView(frame: CGRect(x: width * 0.552, y: (-1) * circle2Height / 5, width: circle2Height, height: circle2Height))
        circle2.layer.cornerRadius = circle2Height / 2
        circle2.clipsToBounds = true
        circle2.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.7607843137, alpha: 1)
        
        let circle3Height = CGFloat(height / 2.9)
        
        let circle3 = UIView(frame: CGRect(x: width * (2.5 / 3.5), y: height * (0.4), width: circle3Height, height: circle3Height))
        circle3.layer.cornerRadius = circle3Height / 2
        circle3.clipsToBounds = true
        circle3.backgroundColor = #colorLiteral(red: 0, green: 0.8196078431, blue: 1, alpha: 1)
        
        self.view.addSubview(circle1)
        self.view.addSubview(circle2)
        self.view.addSubview(circle3)
    }
    
    private func setupStackViews() {
        setupMoveCardButtons()
        setupDummyCards()
        setupOverallStackView()
        setupAnchors()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(sender:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupDummyCards() {
        let tmpCardResultView = CardResultView()
        tmpCardResultView.fillSuperview()
        tmpCardResultView.translatesAutoresizingMaskIntoConstraints = false
        cardContentStackView = UIStackView(arrangedSubviews: [tmpCardResultView])
        cardContentStackView.axis = .vertical
    }
    
    private func setupMoveCardButtons() {
        swipeLeftButton.addTarget(self, action: #selector(swipeLeft), for: .touchUpInside)
        swipeRightButton.addTarget(self, action: #selector(swipeRight), for: .touchUpInside)
        
        cardButtonsStackView = UIStackView(arrangedSubviews: [swipeLeftButton, swipeRightButton])
        
        cardButtonsStackView.axis = .horizontal
        cardButtonsStackView.distribution = .fillProportionally
        cardButtonsStackView.spacing = 0
    }
    
    private func setupOverallStackView() {
        tmp1StackView = UIStackView(arrangedSubviews: [UIView()])
        tmp2StackView = UIStackView(arrangedSubviews: [UIView()])
        
        let tmpView = UIView()
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsStackView = UIStackView(arrangedSubviews: [cardContentStackView, tmpView, cardButtonsStackView])
        
        tmpView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        cardsStackView.translatesAutoresizingMaskIntoConstraints = false
        cardsStackView.axis = .vertical
        
        overallStackView = UIStackView(arrangedSubviews: [tmp1StackView, cardsStackView, tmp2StackView])
        overallStackView.spacing = 0
        overallStackView.axis = .vertical
        overallStackView.distribution = .fill
        
        self.view.addSubview(overallStackView)
        
        overallStackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    private func setupAnchors() {
        print()
        tmp1StackView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        if UIScreen.main.bounds.height < 700 {
            cardContentStackView.heightAnchor.constraint(equalToConstant: 390).isActive = true
        } else if UIScreen.main.bounds.height > 870 {
            cardContentStackView.heightAnchor.constraint(equalToConstant: 490).isActive = true
        } else {
            cardContentStackView.heightAnchor.constraint(equalToConstant: 440).isActive = true
        }
        
        cardButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        cardButtonsStackView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        if cardButtonsStackView.arrangedSubviews.count > 1 {
            cardButtonsStackView.arrangedSubviews[1].widthAnchor.constraint(equalTo: cardButtonsStackView.arrangedSubviews[0].widthAnchor, multiplier: 1).isActive = true
        }
        
        tmp2StackView.heightAnchor.constraint(equalTo: tmp1StackView.heightAnchor, multiplier: 1.35).isActive = true
        cardsStackView.bringSubviewToFront(cardContentStackView)
    }
    
    // MARK:- Selectors
    @objc
    private func backButtonTapped(sender: UIButton) {
        returnBack()
    }
    
    @objc internal func swipeLeft() {
        if let card = cardsView.last {
            card.swipeCard(IfPositiveNumberThenSwipeRightElseLeft: -1)
            updateSwipedCard(isFamilarWordSwiped: false)
        }
    }
    
    @objc internal func swipeRight() {
        if let card = cardsView.last {
            card.swipeCard(IfPositiveNumberThenSwipeRightElseLeft: 1)
            updateSwipedCard(isFamilarWordSwiped: true)
        }
    }
    
    fileprivate lazy var settingsViewController: CardSettingsViewController = {
        let svc = CardSettingsViewController()
        svc.category = category
        svc.keyWindow = self.view.window
        return svc
    }()
    
    @objc fileprivate func settingsButtonTapped(sender: UIButton) {
        settingsViewController.show()
    }
    private let screenSize = UIScreen.main.bounds.size
}

// MARK:- CardInteractionController Protocol Realization
extension CardsViewController: CardInteractionController {
    internal func enableSwipeButtons(isEnabled enabled: Bool) {
        backButton.isUserInteractionEnabled = enabled
        settingsButton.isUserInteractionEnabled = enabled
        swipeLeftButton.isUserInteractionEnabled = enabled
        swipeRightButton.isUserInteractionEnabled = enabled
    }
    
    internal func updateSwipedCard(isFamilarWordSwiped: Bool) {
        
        
        if cardsView.count > 0 {
            cardsView[cardsView.count - 1].isHidden = false
        }
        
        if cardsView.count > 1 {
            cardsView[cardsView.count - 2].isHidden = false
        }
        
        if cardsView.count > 2 {
            cardsView[cardsView.count - 3].isHidden = false
        }
        
        let card = cardsView.popLast()
        
        if isFamilarWordSwiped == true {
            result.familarWords += 1
            if let card = card {
                learnedSentences.append(card.Sentence)
            }
        } else {
            result.unfamilarWords += 1
        }
        
        if cardsView.count < 1 {
            oneCardView.finishButton.isEnabled = true
            CoreDataManager.shared.learnSentences(sentences: learnedSentences)
            print(learnedSentences)
        }
        
        cardsView.last?.isUserInteractionEnabled = true
        
        
        oneCardView.updateLabel(message: result)
    }
    
    internal func returnBack() {
        DispatchQueue.global(qos: .utility).async {
            StatisticCollector.addToStatistic(unfamilarWords: self.result.unfamilarWords,
                                              familarWords: self.result.familarWords)
        }
        circle1.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
}

extension CardsViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("recevied ad")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
}
