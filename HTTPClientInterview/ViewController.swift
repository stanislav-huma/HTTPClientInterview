//
//  ViewController.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

/*
 Задача: Реализовать клиент поиска репозитория на Github
 Дано:
 ● страница API - https://docs.github.com/en/rest/search#search-repositories
 ● допускается использование только системных фреймворков iOS 15
 ● языки Swift или ObjC
 Решение: Приложение состоящее из двух экранов:
 ● экран со строкой поиска и результатами
 ● экран с веб-страницей репозитория на Github

 Условия:
 ● при изменении значения строки поиска, результаты должны соответственно
 обновляться
 ● ячейка результатов должна отображать аватар пользователя, имя репозитория и
 его описание
 ● при нажатии на результат поиска должен отобразиться экран с веб-страницей
 репозитория
 ● все возможные ошибки должны быть доступны для обработки в пользовательском
 интерфейсе
 
 Пункты оценки результата в порядке приоритета:
 1. Общая работоспособность приложения, – при изменении строки поиска
 происходит обновление результатов. При выборе результата отображается страница. Ячейки результатов поиска содержат: аватар, название и описание репозитория
 2. Структура кода и общая стилистика.
 3. Учтено ограничение кол-ва запросов в минуту, отсекания лишних запросов.
 4. Отмена запросов, которые стали не нужны.
 5. Отображение сообщений работы сети: прогрессы, ошибки и т/д
 6. Тесты
 7. Поддержка: альбомного режима, св/темная темы, локализации. При оценке, влиять
 на результат не будут.
 
 */

import UIKit
import WebKit

final class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var tableView: UITableView?
    
    private let httpClient = HTTPClient(urlSession: .shared)
    private var currentWorkItem: DispatchWorkItem?
    private var response: SearchRepositoriesResponse? {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(
            .init(nibName: String(describing: RepoTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: RepoTableViewCell.self)
        )
    }
    
    func show(error: Error) {
        let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(.init(title: "Ok", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func search(query: String) {
        httpClient.execute(SearchRequest.searchRepository(query)) { [weak self] (result: Result<SearchRepositoriesResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self?.response = success
                case .failure(let failure):
                    self?.show(error: failure)
                }
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let workItem = DispatchWorkItem { [weak self] in
            self?.search(query: searchText)
            
            self?.currentWorkItem = nil
        }
        
        self.currentWorkItem?.cancel()
        
        self.currentWorkItem = workItem
        
        DispatchQueue.global().asyncAfter(wallDeadline: .now() + 3, execute: workItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        currentWorkItem?.cancel()
        currentWorkItem = nil
        response = nil
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoTableViewCell.self), for: indexPath) as? RepoTableViewCell else {
            fatalError("Not registered cell")
        }
        
        let item = response?.items[indexPath.item]
        cell.repoNameLabel?.text = item?.fullName ?? item?.name ?? ""
        cell.repoDescriptionLabel?.text = item?.repoDescription
        
        DispatchQueue.global().async {
            guard let url = item?.owner.ownerImageURL,
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                cell.avatarView?.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = WebViewController()
        
        controller.url = response?.items[indexPath.item].url ?? ""
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
