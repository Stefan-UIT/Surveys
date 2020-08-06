//
//  SurveysViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/23/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//
import UIKit
import os.log

class SurveysViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verticalPageControlView: VerticalPageControlView!
    
    // MARK: - Private Var
    private let surveyCellIdentifier = "SurveyTableViewCell"
    private var leftBarButton: UIBarButtonItem!
    
    // MARK: - Variables
    var surveysModel: SurveysViewModel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Texts.Surveys.uppercased()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureVerticalPageControlView(withTotalPages: surveysModel.count)
        self.tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - API
    private func fetchSurveys(completionHandler: @escaping () -> Void = {}) {
        leftBarButton.isEnabled = false
        self.showSpinner(onView: self.view)
        surveysModel.fetchSurveys(success: {
            self.leftBarButton.isEnabled = true
            self.handleFetchingDataSuccess()
            completionHandler()
        }, failure: { (_) in
            self.leftBarButton.isEnabled = true
            self.handleFetchingDataFailed()
        })
    }
    
    private func handleFetchingDataSuccess() {
        removeSpinner()
        reloadVerticalPageControl(totalPages: surveysModel.count)
        tableView.reloadData()
    }
    
    private func handleFetchingDataFailed() {
        removeSpinner()
        showAlert(message: Messages.CouldNotGetSurveysData)
    }
    
    // MARK: - Support Functions
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        leftBarButton = UIBarButtonItem.barButton(imageName: Images.RefreshIcon, selector: #selector(onReloadTouchUp(sender:)), actionController: self)
        let rightBarButton = UIBarButtonItem.barButton(imageName: Images.MenuIcon, selector: nil, actionController: nil)
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func onReloadTouchUp(sender: UIBarButtonItem) {
        os_log(LogMessages.RefreshSurveyData, log: .surveys, type: .info)
        refreshData()
    }
    
    private func refreshData() {
        resetData()
        fetchSurveys()
    }
    
    private func resetData() {
        surveysModel.resetData()
        verticalPageControlView.resetData()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: surveyCellIdentifier, bundle: nil), forCellReuseIdentifier: surveyCellIdentifier)
    }
    
    private func setupVerticalPageView() {
        let activedDot = UIImage(named: Images.ActivedDot)
        let inactivedDot = UIImage(named: Images.InactivedDot)
        verticalPageControlView.setImageActiveState(activedDot, inActiveState: inactivedDot)
        verticalPageControlView.verticalPageControlDelegate = self
    }
    
    private func configureVerticalPageControlView(withTotalPages totalPages: Int) {
        setupVerticalPageView()
        reloadVerticalPageControl(totalPages: totalPages)
    }
    
    private func reloadVerticalPageControl(totalPages: Int) {
        verticalPageControlView.setNumberOfPages(totalPages)
        do {
            try verticalPageControlView.show()
            os_log(LogMessages.VPCHasBeenShowedWithTotalPages, log: .surveys, type: .info, totalPages)
        } catch let error as VPCValidationError {
            let mes = error.errorDescription
            os_log("%@", log: .surveys, type: .error, mes)
            showAlert(message: mes)
        } catch {
            let mes = Messages.FailedToShowVerticalPageControl
            os_log("%@", log: .surveys, type: .error, mes)
            showAlert(message: mes)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SurveysViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        verticalPageControlView.proceed(contentOffsetY: scrollView.contentOffset.y, pageHeight: scrollView.bounds.height)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        verticalPageControlView.proceed(contentOffsetY: scrollView.contentOffset.y, pageHeight: scrollView.bounds.height)
    }
}

// MARK: - UITableViewDataSource
extension SurveysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (surveysModel == nil) ? 0 : surveysModel.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if surveysModel.shouldLoadMoreItems(currentRow: indexPath.row) {
            fetchSurveys()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellSurvey(tableView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func  cellSurvey(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> SurveyTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: surveyCellIdentifier, for: indexPath) as? SurveyTableViewCell else {
            os_log(LogMessages.CouldNotReusedCell, log: .surveys, type: .error, surveyCellIdentifier)
            return SurveyTableViewCell()
        }
        let survey = surveysModel.survey(at: indexPath.row)
        cell.configureCell(survey: survey)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SurveysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - VerticalPageControlViewDelegate
extension SurveysViewController: VerticalPageControlViewDelegate {
    func verticalPageControlView(_ view: VerticalPageControlView?, currentPage: Int) {
        let point = CGPoint(x: 0.0, y: CGFloat(CGFloat(currentPage) * tableView.frame.size.height))
        tableView.scrollTo(point)
    }
}

// MARK: - SurveyTableViewCellDelegate
extension SurveysViewController: SurveyTableViewCellDelegate {
    func didTouchUpTakeTheSurvey(_ cell: SurveyTableViewCell, survey: Survey) {
        os_log(LogMessages.RedirectToSurveyDetail, log: .userFlows, type: .info, survey.title)
        redirectToSurveyDetailVC(survey: survey)
    }
    
    private func redirectToSurveyDetailVC(survey: Survey) {
        guard let surveyDetailController = ControllerHelper.load(SurveyDetailViewController.self, fromStoryboard: Keys.Main) else { return }
        surveyDetailController.survey = survey
        self.navigationController?.pushViewController(surveyDetailController, animated: true)
    }
}
