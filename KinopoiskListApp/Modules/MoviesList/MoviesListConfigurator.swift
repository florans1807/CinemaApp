//
//  MoviesListConfigurator.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 18.04.2024.
//

final class MoviesListConfigurator {
    static func configure(withView view: MoviesListViewController, and kpList: KPList) {
        let presenter = MoviesListPresenter(with: view)
        let interactor = MoviesListInteractor(with: presenter, and: kpList)
        let router = MoviesListRouter()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}