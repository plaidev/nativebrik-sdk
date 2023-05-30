//
//  page.swift
//  Nativebrik
//
//  Created by Ryosuke Suzuki on 2023/05/01.
//

import Foundation
import UIKit
import YogaKit

class PageController: UIViewController {
    private let page: UIPageBlock?
    private let props: [Property]?
    private let config: Config
    private var data: JSON? = nil
    private var event: UIBlockEventManager? = nil
    // TODO: rename to isFirstModal
    private var fullScreenInitialNavItemVisibility = false
    private var loading: Bool = false

    required init?(coder: NSCoder) {
        self.page = nil
        self.props = nil
        self.config = Config(apiKey: "")
        super.init(coder: coder)
    }

    init(page: UIPageBlock?, props: [Property]?, event: UIBlockEventManager?, config: Config) {
        self.page = page
        self.props = props
        self.config = config
        self.event = event
        super.init(nibName: nil, bundle: nil)

        if page?.data?.kind == PageKind.MODAL {
            if let sheet = self.sheetPresentationController {
                sheet.detents = parseModalScreenSize(page?.data?.modalScreenSize)
            }
        }
    }

    func showFullScreenInitialNavItem() {
        self.fullScreenInitialNavItemVisibility = true
    }

    override func viewDidLoad() {
        self.renderNavItems()
        self.loadDataAndRender()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.yoga.applyLayout(preservingOrigin: true)
    }

    func renderView() {
        if let renderAs = self.page?.data?.renderAs {
            self.view = UIViewBlock(
                data: renderAs,
                context: UIBlockContext(
                    data: self.data,
                    event: self.event,
                    parentClickListener: nil,
                    parentDirection: nil,
                    loading: self.loading
                )
            )
        }
    }

    func loadDataAndRender() {
        let query = self.page?.data?.query ?? ""
        if query == "" {
            self.loading = false
            self.renderView()
            return
        } else {
            self.loading = true
            self.renderView()
        }

        let properties: [PropertyInput] = self.page?.data?.props?.enumerated().map { (index, property) in
            let propIndexInEvent = self.props?.firstIndex(where: { prop in
                return property.name == prop.name
            }) ?? -1
            let propInEvent = propIndexInEvent >= 0 ? self.props![propIndexInEvent] : nil

            return PropertyInput(
                name: property.name ?? "",
                value: propInEvent?.value ?? property.value ?? "",
                ptype: property.ptype ?? PropertyType.STRING
            )
        } ?? []
        let placeholderInput = PlaceholderInput(properties: properties)

        DispatchQueue.global().async {
            Task {
                let data = try await getData(
                    query: getDataQuery(
                        query: query,
                        placeholder: placeholderInput
                    ),
                    apiKey: self.config.apiKey,
                    url: self.config.url
                )
                DispatchQueue.main.async {
                    if let data = data.data?.data {
                        self.data = data
                    }
                    self.loading = false
                    self.renderView()
                }
            }
        }
    }

    func renderNavItems() {
        let buttonData = self.page?.data?.modalNavigationBackButton
        if buttonData?.visible == false {
            self.navigationItem.setHidesBackButton(true, animated: true)
            return
        } else {
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
        let leftButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(onClickBack)
        )

        if let color = buttonData?.color {
            leftButton.tintColor = parseColor(color)
        }

        if self.fullScreenInitialNavItemVisibility {
            leftButton.title = "Close"
            if let title = buttonData?.title {
                if title != "" {
                    leftButton.title = title
                }
            }
            self.navigationItem.leftBarButtonItem = leftButton
        } else {
            leftButton.title = "Back"
            if let title = buttonData?.title {
                if title != "" {
                    leftButton.title = title
                }
            }
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = leftButton
        }
    }

    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}