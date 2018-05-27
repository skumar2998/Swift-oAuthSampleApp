//
//  ViewController.swift
//  oAuthSampleApp
//
//  Created by Kumar, Sunil on 26/05/18.
//  Copyright © 2018 AppScullery. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {
    
    var oauthswift: OAuthSwift?

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
                //self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                print("Gitter Token's are \r\n Key:\(credential.consumerKey) \r\n Secret:\(credential.consumerSecret)")
        },
            failure: { error in
                print(error.localizedDescription, terminator: "")
        })
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
}

