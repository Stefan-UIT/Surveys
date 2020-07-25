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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Surveys".uppercased()
        setupTableView()
        setupNavigationBar()
        setupVerticalPageView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureVerticalPageControlView(withTotalPages: self.surveys.count)
        self.tableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - API
    private func fetchSurveys(completionHandler: @escaping ()->() = {}) {
        self.showSpinner(onView: self.view)
        APIServices.shared.fetchSurveys(success: { (surveys) in
            self.removeSpinner()
            self.surveys = surveys
            self.configureVerticalPageControlView(withTotalPages: self.surveys.count)
            self.tableView.reloadData()
            completionHandler()
        }) { (error) in
            self.removeSpinner()
            self.showAlert(message: Messages.CouldNotGetSurveysData)
            completionHandler()
        }
    }
    
    // MARK: - Support Functions
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        let leftBarButton = UIBarButtonItem.barButton(imageName: Constants.Images.RefreshIcon, selector: #selector(onReloadTouchUp(sender:)),actionController: self)
        
        let rightBarButton = UIBarButtonItem.barButton(imageName: Constants.Images.MenuIcon,selector: nil, actionController: nil)
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func onReloadTouchUp(sender:UIBarButtonItem) {
        sender.isEnabled = false
        fetchSurveys {
            sender.isEnabled = true
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: surveyCellIdentifier, bundle: nil), forCellReuseIdentifier: surveyCellIdentifier)
    }
    
    private func setupVerticalPageView() {
        let activedDot = UIImage(named: Constants.Images.ActivedDot)
        let unactivedDot = UIImage(named: Constants.Images.UnactivedDot)
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
        cell.delegate = self
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

//MARK: - SurveyTableViewCellDelegate
extension SurveysViewController:SurveyTableViewCellDelegate {
    func didTouchUpTakeTheSurvey(_ cell: SurveyTableViewCell, survey: Survey) {
        redirectToSurveyDetailVC(survey: survey)
    }
    
    func redirectToSurveyDetailVC(survey:Survey) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.Main, bundle: nil)
        let vc :SurveyDetailViewController = storyboard.instantiateViewController(withIdentifier: K.SurveyDetailViewController) as! SurveyDetailViewController
        vc.survey = survey
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
