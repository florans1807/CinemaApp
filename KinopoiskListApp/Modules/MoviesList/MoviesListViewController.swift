//
//  MoviesInCollectionViewController.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 01.04.2024.
//

import UIKit
import SkeletonView

final class MoviesListViewController: UIViewController {
    // MARK: - Properties
    private var sectionViewModel: SectionViewModelProtocol = SectionViewModel()
    var presenter: PresenterToViewMoviesListProtocol!
    var tableView: UITableView!
    private var lastYScrollOffset: CGFloat = 0
    private var wasAnyStatusChanged = false
    private var editedFilm: Film?
    
    weak var delegate: MovieStatusChangedDelegate!
   
    private lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.sizeToFit()
        label.isSkeletonable = true
        label.skeletonCornerRadius = 3
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupTableView()
        addSkeletonAnimation()
        presenter.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Adjust Height of Table HeaderView
        tableView.updateHeaderViewHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let editedFilm = editedFilm else { return }
        if wasAnyStatusChanged {
            delegate.reloadMoviesSection(film: editedFilm)
        }
    }
}

// MARK: - Extensions -  Private Methodds
extension MoviesListViewController {
    // MARK: - Setup the SkeletonView
    private func addSkeletonAnimation() {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
    
    // MARK: - Setup the Table View
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(MovieTableViewCell.self)
        tableView.rowHeight = 100
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

// MARK: - Extensions -  ViewToPresenterMoviesListProtocol
extension MoviesListViewController: ViewToPresenterMoviesListProtocol {
    // MARK: - Set Table HeaderView
    func reloadHeader(with title: String) {
        navTitleLabel.text = title
        navTitleLabel.numberOfLines = navTitleLabel.maxNumberOfLines

        let headerView = UIView()
        headerView.isSkeletonable = true
        headerView.addSubview(navTitleLabel)
        navTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        tableView.tableHeaderView = headerView
    }
    
    func reloadData(with section: SectionViewModel) {
        sectionViewModel = section
        tableView.hideSkeleton()
    }
}

// MARK: - Extensions - UIScrollViewDelegate
extension MoviesListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentY = scrollView.contentOffset.y
        let headerHeight = tableView.tableHeaderView?.bounds.height ?? 0
        
        // header disappears
        if (lastYScrollOffset <= headerHeight) && (currentY > headerHeight) {
            title = navTitleLabel.text
        }
        
        // header appears
        if (lastYScrollOffset > headerHeight) && (currentY <= headerHeight) {
            title = ""
        }
        
        lastYScrollOffset = currentY
    }
}

// MARK: - Extensions - SkeletonTableViewDataSource, SkeletonTableViewDelegate
extension MoviesListViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionViewModel.numberOfMovieItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseId,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        cell.viewModel = sectionViewModel.movieItems[indexPath.item]
        return cell
    }
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return MovieTableViewCell.reuseId
    }
    
    func collectionSkeletonView(
        _ skeletonView: UITableView,
        prepareCellForSkeleton cell: UITableViewCell,
        at indexPath: IndexPath
    ) {
        cell.isSkeletonable = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapCell(at: indexPath.row)
    }
    
}

// MARK: - Extensions - UpdateFavoriteStatusDelegate
extension MoviesListViewController: UpdateFavoriteStatusDelegate {
    func modalClosed(filmStatus: FilmStatus, film: Film) {
        editedFilm = film
        sectionViewModel.favoriteFilms.append(CellViewModel(film: film))
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        switch filmStatus {
        case .none:
            tableView.deselectRow(at: indexPath, animated: false)
        default:
            wasAnyStatusChanged = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
//        if let indexPath = tableView.indexPathForSelectedRow {
//            wasStatusChanged 
//            ? tableView.reloadRows(at: [indexPath], with: .automatic)
//            : tableView.deselectRow(at: indexPath, animated: false)
//        }
    }
}

protocol UpdateFavoriteStatusDelegate: AnyObject {
    func modalClosed(filmStatus: FilmStatus, film: Film)
}
