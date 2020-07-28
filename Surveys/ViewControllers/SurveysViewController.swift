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
    var surveysModel:SurveysModel!
    
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - API
    private func fetchSurveys(completionHandler: @escaping ()->() = {}) {
        self.showSpinner(onView: self.view)
        surveysModel.fetchSurveys(success: {
            self.removeSpinner()
            self.reloadVerticalPageControl(totalPages: self.surveysModel.count)
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
        let leftBarButton = UIBarButtonItem.barButton(imageName: Images.RefreshIcon, selector: #selector(onReloadTouchUp(sender:)),actionController: self)
        let rightBarButton = UIBarButtonItem.barButton(imageName: Images.MenuIcon,selector: nil, actionController: nil)
        
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
        let activedDot = UIImage(named: Images.ActivedDot)
        let inactivedDot = UIImage(named: Images.InactivedDot)
        verticalPageControlView.setImageActiveState(activedDot, inActiveState: inactivedDot)
        verticalPageControlView.verticalPageControlDelegate = self
    }
    
    private func configureVerticalPageControlView(withTotalPages totalPages: Int) {
        setupVerticalPageView()
        reloadVerticalPageControl(totalPages: totalPages)
    }
    
    private func reloadVerticalPageControl(totalPages:Int) {
        verticalPageControlView.setNumberOfPages(totalPages)
        do {
            try verticalPageControlView.show()
        } catch let error as VPCValidationError {
            showAlert(message: error.errorDescription)
        } catch {
            showAlert(message: Messages.SomethingWentWrong)
        }
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
        return (surveysModel == nil) ? 0 : surveysModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: surveyCellIdentifier, for: indexPath) as! SurveyTableViewCell
        let survey = surveysModel.survey(at: indexPath.row)
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
        let point = CGPoint(x: 0.0, y: CGFloat(CGFloat(currentPage) * tableView.frame.size.height))
        tableView.scrollTo(point)
    }
}

//MARK: - SurveyTableViewCellDelegate
extension SurveysViewController:SurveyTableViewCellDelegate {
    func didTouchUpTakeTheSurvey(_ cell: SurveyTableViewCell, survey: Survey) {
        redirectToSurveyDetailVC(survey: survey)
    }
    
    private func redirectToSurveyDetailVC(survey:Survey) {
        guard let surveyDetailController = ControllerHelper.load(SurveyDetailViewController.self, fromStoryboard: K.Main) else { return }
        surveyDetailController.survey = survey
        self.navigationController?.pushViewController(surveyDetailController, animated: true)
    }
}
