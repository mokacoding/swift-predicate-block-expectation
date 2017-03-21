import XCTest

class ProductView: UIView {
    let name: UILabel = UILabel()
    let price: UILabel = UILabel()
}

class ProductViewConfigurator {
    let view: ProductView

    init(view: ProductView) {
        self.view = view
    }

    func configure(withProductId id: Int) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.view.name.text = "Foo"
            strongSelf.view.price.text = "$42"
        }
    }
}

class ProductViewConfiguratorTests: XCTestCase {

    func testItConfiguresTheView() {
        let view = ProductView()
        let configurator = ProductViewConfigurator(view: view)

        let predicate = NSPredicate(block: { any, _ in
            guard let view = any as? ProductView else { return false }
            return view.name.text == "Foo" && view.price.text == "$42"
        })
        _ = self.expectation(for: predicate, evaluatedWith: view, handler: .none)

        configurator.configure(withProductId: 123)

        waitForExpectations(timeout: 1, handler: .none)
    }
}
