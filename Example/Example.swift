import XCTest

class Foo {
    var x: Bool

    init(x: Bool) {
        self.x = x
    }
}

class SomeService {
    func performAsynSideEffect(on foo: Foo) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
            foo.x = !foo.x
        }
    }
}

class ExampleTestCase: XCTestCase {

    func testExpectationWithBlockPredicate() {
        let foo = Foo(x: false)

        let predicate = NSPredicate(block: { any, _ in
            guard let foo = any as? Foo else { return false }
            return foo.x == true
        })
        _ = self.expectation(for: predicate, evaluatedWith: foo, handler: .none)

        let service = SomeService()
        service.performAsynSideEffect(on: foo)

        waitForExpectations(timeout: 1, handler: .none)
    }
}