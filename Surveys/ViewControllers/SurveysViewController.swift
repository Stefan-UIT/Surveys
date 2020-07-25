//
//  SurveysViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/23/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//
import UIKit

class SurveysViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verticalPageControlView: VerticalPageControlView!
    
    // MARK: - Private Var
    private let surveyCellIdentifier = "SurveyTableViewCell"
    
    // MARK: - Variables
    var surveys:[Survey]!
//    var surveys = [Survey]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupVerticalPageView()
        fetchSurveys()
    }
    
    // MARK: - API
    private func fetchSurveys() {
        self.showSpinner(onView: self.view)
        APIServices.shared.fetchSurveys { (surveys) in
            self.removeSpinner()
            self.surveys = surveys
            self.configureVerticalPageControlView(withTotalPages: self.surveys.count)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Support Functions
    private func setupNavigationBar() {
        let leftBarButton = barButton(imageName: "refresh_icon", selector: #selector(onReloadTouchUp))
        navigationItem.leftBarButtonItem = leftBarButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
    
    func barButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    @objc func onReloadTouchUp() {
        fetchSurveys()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: surveyCellIdentifier, bundle: nil), forCellReuseIdentifier: surveyCellIdentifier)
    }
    
    private func setupVerticalPageView() {
        let activedDot = UIImage(named: "actived_dot")
        let unactivedDot = UIImage(named: "unactived_dot")
        verticalPageControlView.setImageActiveState(activedDot, inActiveState: unactivedDot)
        verticalPageControlView.verticalPageControlDelegate = self
    }
    
    private func configureVerticalPageControlView(withTotalPages totalPages: Int) {
        verticalPageControlView.setNumberOfPages(totalPages)
        verticalPageControlView.show()
    }
}

// MARK: - UIScrollViewDelegate
extension SurveysViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        verticalPageControlView.proceed(contentOffsetY: scrollView.contentOffset.y, pageHeight: scrollView.bounds.height)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        verticalPageControlView.proceed(contentOffsetY: scrollView.contentOffset.y, pageHeight: scrollView.bounds.height)
    }
}

// MARK: - UITableViewDataSource
extension SurveysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (surveys == nil) ? 0 : surveys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: surveyCellIdentifier, for: indexPath) as! SurveyTableViewCell
        let survey = surveys[indexPath.row]
        cell.configureCell(survey: survey)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
}

//MARK: - UITableViewDelegate
extension SurveysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - VerticalPageControlViewDelegate
extension SurveysViewController:VerticalPageControlViewDelegate {
    func verticalPageControlView(_ view: VerticalPageControlView?, currentPage: Int) {
        tableView.setContentOffset(CGPoint(x: 0, y: CGFloat(CGFloat(currentPage) * tableView.frame.size.height)), animated: true)
    }
}
