//
//  SignUpEmailViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/4.
//

import Foundation
import UIKit
import FirebaseAuth
import Lottie
import SnapKit

class SignUpEmailViewController: UIViewController {
    
    let blackView = UIView(frame: UIScreen.main.bounds)
    let logoMessageTypingAnimationView = LottieAnimationView(name: "LogoMessageTyping")
    
    let signUpNickNameVC = SignUpNickNameViewController()
    
//    private let logoMessageTypingAnimationView: UIImageView = {
//        let logoMessageTypingAnimationView = UIImageView()
//        logoMessageTypingAnimationView.image = UIImage(named: "BlueParrot.png")
//        logoMessageTypingAnimationView.contentMode = .scaleAspectFit
//        return logoMessageTypingAnimationView
//    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create a Murmur Wall Account"
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .PrimaryMidDarkContrast
        return titleLabel
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 18
        return stack
    }()
    private let ball1: UIView = {
        let ball1 = UIView()
        ball1.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        ball1.layer.cornerRadius = 4
        ball1.backgroundColor = .PrimaryMiddle
        return ball1
    }()
    private let ball2: UIView = {
        let ball2 = UIView()
        ball2.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        ball2.layer.cornerRadius = 4
        ball2.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
        ball2.layer.borderWidth = 2
        return ball2
    }()
    private let emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = .SecondarySaturate
        return emailLabel
    }()
    private let emailTextField: MessageTypeTextField = {
        let emailTextField = MessageTypeTextField()
        emailTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        emailTextField.textColor = .SecondaryDark
        emailTextField.placeholder = "Email"
//        emailTextField.attributedPlaceholder = NSAttributedString(string: "請輸入 email", attributes: [
//            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 18.0),
//            NSAttributedString.Key.kern: 1.5,
////            NSAttributedString.Key.foregroundColor: UIColor.green
//        ])
        emailTextField.layer.cornerRadius = 12
        emailTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        emailTextField.layer.addShineShadow()
        return emailTextField
    }()
    private let passwordLabel: UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = .SecondarySaturate
        return passwordLabel
    }()
    private let passwordTextField: MessageTypeTextField = {
        let passwordTextField = MessageTypeTextField()
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        passwordTextField.textColor = .SecondaryDark
        passwordTextField.placeholder = "Must contain at least 6 characters"
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        passwordTextField.layer.addShineShadow()
        return passwordTextField
    }()
    private let EULALabel: UILabel = {
        let EULALabel = UILabel()
        EULALabel.textColor = .SecondaryMidDark
        EULALabel.text = "By creating an account, you agree to the:"
        return EULALabel
    }()
    lazy var termsOfServiceButton: UIButton = {
        let termsOfServiceButton = UIButton()
        termsOfServiceButton.setTitle("Terms Of Service,", for: .normal)
        termsOfServiceButton.setTitleColor(UIColor.SecondarySaturate, for: .normal)
        termsOfServiceButton.addTarget(self, action: #selector(termsOfServiceButtonTouchUpInside), for: .touchUpInside)
        return termsOfServiceButton
    }()
    lazy var privacyPolicyButton: UIButton = {
        let privacyPolicyButton = UIButton()
        privacyPolicyButton.setTitle("Privacy Policy", for: .normal)
        privacyPolicyButton.setTitleColor(UIColor.SecondarySaturate, for: .normal)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTouchUpInside), for: .touchUpInside)
        return privacyPolicyButton
    }()
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.GrayScale20, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
        nextButton.backgroundColor = .SecondaryMiddle
        nextButton.layer.cornerRadius = 12
        nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTouchDown), for: .touchDown)
        return nextButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        layoutView()
        lottieLogoMessageTyping()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // swiftlint:disable function_body_length
    @objc func termsOfServiceButtonTouchUpInside() {
        
        let privacyPolicyText = """
                
                Privacy Policy for Murmur Wall

                Privacy Policy
                Last updated: July 11, 2023

                This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

                We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Privacy Policy Generator.

                Interpretation and Definitions
                Interpretation
                The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.

                Definitions
                For the purposes of this Privacy Policy:

                Account means a unique account created for You to access our Service or parts of our Service.

                Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.

                Application refers to Murmur Wall, the software program provided by the Company.

                Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Murmur Wall.

                Country refers to: Taiwan

                Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.

                Personal Data is any information that relates to an identified or identifiable individual.

                Service refers to the Application.

                Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.

                Third-party Social Media Service refers to any website or any social network website through which a User can log in or create an account to use the Service.

                Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).

                You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.

                Collecting and Using Your Personal Data
                Types of Data Collected
                Personal Data
                While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:

                Email address

                Usage Data

                Usage Data
                Usage Data is collected automatically when using the Service.

                Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.

                When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.

                We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.

                Information from Third-Party Social Media Services
                The Company allows You to create an account and log in to use the Service through the following Third-party Social Media Services:

                Google
                Facebook
                Instagram
                Twitter
                LinkedIn
                If You decide to register through or otherwise grant us access to a Third-Party Social Media Service, We may collect Personal data that is already associated with Your Third-Party Social Media Service's account, such as Your name, Your email address, Your activities or Your contact list associated with that account.

                You may also have the option of sharing additional information with the Company through Your Third-Party Social Media Service's account. If You choose to provide such information and Personal Data, during registration or otherwise, You are giving the Company permission to use, share, and store it in a manner consistent with this Privacy Policy.

                Information Collected while Using the Application
                While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:

                Information regarding your location

                Pictures and other information from your Device's camera and photo library

                We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company's servers and/or a Service Provider's server or it may be simply stored on Your device.

                You can enable or disable access to this information at any time, through Your Device settings.

                Use of Your Personal Data
                The Company may use Personal Data for the following purposes:

                To provide and maintain our Service, including to monitor the usage of our Service.

                To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.

                For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.

                To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.

                To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.

                To manage Your requests: To attend and manage Your requests to Us.

                For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.

                For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.

                We may share Your personal information in the following situations:

                With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.
                For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.
                With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.
                With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.
                With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. If You interact with other users or register through a Third-Party Social Media Service, Your contacts on the Third-Party Social Media Service may see Your name, profile, pictures and description of Your activity. Similarly, other users will be able to view descriptions of Your activity, communicate with You and view Your profile.
                With Your consent: We may disclose Your personal information for any other purpose with Your consent.
                Retention of Your Personal Data
                The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.

                The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.

                Transfer of Your Personal Data
                Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.

                Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.

                The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.

                Delete Your Personal Data
                You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.

                Our Service may give You the ability to delete certain information about You from within the Service.

                You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.

                Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.

                Disclosure of Your Personal Data
                Business Transactions
                If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.

                Law enforcement
                Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).

                Other legal requirements
                The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:

                Comply with a legal obligation
                Protect and defend the rights or property of the Company
                Prevent or investigate possible wrongdoing in connection with the Service
                Protect the personal safety of Users of the Service or the public
                Protect against legal liability
                Security of Your Personal Data
                The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.

                Children's Privacy
                Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.

                If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information.

                Links to Other Websites
                Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.

                We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.

                Changes to this Privacy Policy
                We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.

                We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.

                You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

                Contact Us
                If you have any questions about this Privacy Policy, You can contact us:

                By email: kelly912718@gmail.com


                """
        
        let controller = UIAlertController(title: "termsOfService", message: privacyPolicyText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
           print("在行事曆裡加入送宵夜的提醒")
        }
        controller.addAction(okAction)
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
//        controller.addAction(cancelAction)
        present(controller, animated: true)
        
//        let presentVC = PopupViewController()
//        presentVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
////        presentVC.modalPresentationStyle = UIModalPresentationStyle.custom
//        presentVC.modalPresentationStyle = .custom
//        presentVC.modalTransitionStyle = .crossDissolve
//
//        self.present(presentVC, animated: true) { [self] in
            
//            self.blackView.backgroundColor = .black
//            blackView.alpha = 0
//            self.navigationController?.view.addSubview(blackView)
////            self.view.addSubview(self.blackView)
////            self.view.bringSubviewToFront(self.blackView)
//            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.05, delay: 0) {
//                self.blackView.alpha = 0.5
//            }
            
//        }
   
    }
    
    @objc func privacyPolicyButtonTouchUpInside() {
        
    }
    
    func lottieLogoMessageTyping() {
        logoMessageTypingAnimationView.play()
        logoMessageTypingAnimationView.loopMode = .loop
    }
    
    // 當點擊view任何一處鍵盤收起
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func nextButtonTouchDown() {// 点击改变背景色
        nextButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    @objc func nextButtonTouchUpInside() {
        
        signUpNickNameVC.userEmail = emailTextField.text
        signUpNickNameVC.userPassword = passwordTextField.text
        self.navigationController?.pushViewController(signUpNickNameVC, animated: true)
        
    }
    
    func layoutView() {
        
        self.view.backgroundColor = .PrimaryLighter
        
        [logoMessageTypingAnimationView, titleLabel, stack, emailLabel, emailTextField, passwordLabel, passwordTextField, EULALabel, termsOfServiceButton, privacyPolicyButton, nextButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        [ball1, ball2].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        
        ball1.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(stack)
            make.height.width.equalTo(8)
        }
        
        ball2.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(stack)
            make.height.width.equalTo(8)
        }
        
        logoMessageTypingAnimationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(22)
            make.height.width.equalTo(34)
            make.centerX.equalTo(self.view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoMessageTypingAnimationView.snp.bottom).offset(4)
            make.leading.greaterThanOrEqualTo(self.view).offset(60)
            make.trailing.lessThanOrEqualTo(self.view).offset(-60)
            make.centerX.equalTo(self.view)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(self.view)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-5)
            make.leading.equalTo(self.view).offset(30)
        }
        passwordTextField.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY).offset(8)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(43)
        }
        EULALabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(passwordTextField)
        }
        termsOfServiceButton.snp.makeConstraints { make in
            make.top.equalTo(EULALabel.snp.bottom).offset(0)
            make.leading.equalTo(EULALabel)
        }
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(EULALabel.snp.bottom).offset(0)
            make.leading.equalTo(termsOfServiceButton.snp.trailing).offset(4)
        }
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordLabel.snp.top).offset(-18)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(43)
        }
        emailLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-5)
            make.leading.equalTo(passwordTextField)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(39)
            make.width.equalTo(119)
            make.trailing.equalTo(self.view).offset(-30)
            make.top.equalTo(passwordTextField.snp.bottom).offset(112)
        }
        
    }
}
