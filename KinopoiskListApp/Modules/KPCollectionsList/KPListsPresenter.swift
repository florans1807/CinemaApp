//
//  KPCollectionLIstPresenter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 17.04.2024.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class KPListsPresenter: KPListsViewOutputProtocol {
    // MARK: - Properties
    private unowned let view: KPListsViewInputProtocol
    var interactor: KPListsInteractorInputProtocol!
    var router: KPListsRouterProtocol!
    private let section = SectionViewModel()

    // MARK: - Initialization
    required init(with view: KPListsViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchData()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        guard 
            let viewModel = section.kpListItems[indexPath.item] as? CellViewModel,
            let kpList = viewModel.kpList else { return }
        router.routeToMoviesListVC(of: kpList)
    }
}

// MARK: - Extensions - KPListsInteractorOutputProtocol
extension KPListsPresenter: KPListsInteractorOutputProtocol {
    func didReceiveData(with kpLists: [KPList], and category: String) {
        section.categoryName = category
        kpLists.forEach { item in
            section.kpListItems.append(CellViewModel(kpList: item))
        }
        view.reloadData(section: section)
    }
}
