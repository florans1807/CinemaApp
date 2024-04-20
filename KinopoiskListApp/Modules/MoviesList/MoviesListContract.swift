//
//  MoviesListContract.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 18.04.2024.
//  
//

/// ViewInputProtocol (VC conforms, Presenter contains)
protocol ViewToPresenterMoviesListProtocol: AnyObject {
    func reloadData(with section: SectionViewModel)
    func reloadHeader(with title: String)
}

/// ViewOutputProtocol (Presenter conforms, VC contains)
protocol PresenterToViewMoviesListProtocol: AnyObject {
    init(with view: ViewToPresenterMoviesListProtocol)
    var interactor: PresenterToInteractorMoviesListProtocol! { get set }
    var router: PresenterToRouterMoviesListProtocol! { get set }
    func viewDidLoad()
}

/// InteractorInputProtocol (Interactor confroms, Presenter contains)
protocol PresenterToInteractorMoviesListProtocol {
    init(with presenter: InteractorToPresenterMoviesListProtocol, and kpList: KPList)
    func fetchData()
}

/// InteractorOutputProtocol (Presenter conforms, Interactor contains)
protocol InteractorToPresenterMoviesListProtocol: AnyObject {
    func didReceiveData(with movies: [Movie], and kpList: KPList)
    func setHeader(with title: String)
}

/// RouterInputProtocol (Router conforms, Presenter contains)
protocol PresenterToRouterMoviesListProtocol {
    
}