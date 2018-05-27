//
//  ViewController.swift
//  oAuthSampleApp
//
//  Created by Kumar, Sunil on 26/05/18.
//  Copyright © 2018 AppScullery. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftEntryKit

class ViewController: UIViewController {
    
    var oauthswift: OAuthSwift?
    
    private lazy var attributesWrapper: EntryAttributeWrapper = {
        var attributes = EKAttributes()
        attributes.positionConstraints = .fullWidth
        attributes.hapticFeedbackType = .success
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.entryBackground = .visualEffect(style: .light)
        attributes.position = .center
        attributes.screenInteraction = .dismiss
        attributes.displayDuration = .infinity
        return EntryAttributeWrapper(with: attributes)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func oauthViaSafariButtonPressed(_ sender: UIButton) {

        let oauthswift = OAuth2Swift(
            consumerKey:    "be8889735ac2f94d7d2e8c16212635b4a9eb932f",
            consumerSecret: "11c4db6422c8cbb378bea66a0dec5e57ddef348b",
            authorizeUrl:   "https://gitter.im/login/oauth/authorize",
            accessTokenUrl: "https://gitter.im/login/oauth/token",
            responseType:   "code"
        )
        
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()
        let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-sample://oauth-callback/gitter")!, scope: "flow", state: state,
            success: { credential, response, parameters in
                
                self.showMessageToUser("Gitter Token's ", body: "Key:\(credential.consumerKey) \r\nSecret:\(credential.consumerSecret)")
        },
            failure: { error in
                print(error.localizedDescription, terminator: "")
        })

    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
    
    func showMessageToUser(_ title: String, body: String) {
        let title = EKProperty.LabelContent(text: title, style: EKProperty.LabelStyle(font: MainFont.bold.with(size: 16), color: .black))
        let description = EKProperty.LabelContent(text: body, style: EKProperty.LabelStyle(font: MainFont.light.with(size: 14), color: .black))
        let image = EKProperty.ImageContent(image: UIImage(named: "ic_info_outline")!, size: CGSize(width: 30, height: 30))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        
        
        SwiftEntryKit.display(entry: contentView, using: attributesWrapper.attributes)
    }
}

