//
//  RocketWikiViewController.swift
//  SpaceX
//
//  Created by Егор Бадмаев on 05.03.2022.
//

import UIKit
import WebKit

final class RocketWikiViewController: UIViewController {
    
    private let url: String
    
    lazy var webView = WKWebView()
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.items = [backButton, spacer, forwardButton, spacer, shareButton, spacer, safariButton]
        toolBar.tintColor = .coral
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "chevronBackward"), style: .plain, target: self, action: #selector(backAction))
        button.isEnabled = false
        return button
    }()
    lazy var forwardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "chevronForward"), style: .plain, target: self, action: #selector(forwardAction))
        button.isEnabled = false
        return button
    }()
    lazy var shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareAction))
    lazy var safariButton = UIBarButtonItem(image: UIImage(named: "safari"), style: .plain, target: self, action: #selector(safariAction))
    lazy var spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevronBackward")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(dismissThisVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "reload")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(reloadPage))
        navigationController?.navigationBar.tintColor = .coral
        
        loadRequest(url: url)
        setupView()
        setConstraints()
    }
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadRequest(url: String) {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    private func setupView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(toolBar)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            toolBar.topAnchor.constraint(equalTo: webView.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func dismissThisVC() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIBarButtonItems @objc methods
extension RocketWikiViewController {
    
    @objc private func backAction() {
        guard webView.canGoBack else { return }
        webView.goBack()
    }
    
    @objc private func forwardAction() {
        guard webView.canGoForward else { return }
        webView.goForward()
    }
    
    @objc private func shareAction() {
        
    }
    
    @objc private func safariAction() {
        
    }
    
    @objc private func reloadPage() {
        webView.reload()
    }
}

// MARK: - WKNavigationDelegate
extension RocketWikiViewController: WKNavigationDelegate {
    
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        <#code#>
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
}
