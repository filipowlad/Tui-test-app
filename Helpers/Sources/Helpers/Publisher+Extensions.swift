//
//  Publisher+Extensions.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Combine

// MARK: - Sink

public extension Publisher where Failure == Never {
    func sink() -> AnyCancellable {
        sink { _ in }
    }

    func sink<A: AnyObject>(
        weak obj: A,
        block: @escaping (A, Output) -> Void
    ) -> AnyCancellable {
        sink { [weak obj] output in
            guard let obj = obj else {
                return
            }
            block(obj, output)
        }
    }
    
    func asyncSink<A: AnyObject>(
        weak obj: A,
        withPriority priority: TaskPriority? = nil,
        block: @escaping (A, Output) async -> Void
    ) -> AnyCancellable {
        sink { [weak obj] output in
            guard let obj = obj else {
                return
            }

            Task(priority: priority) {
                await block(obj, output)
            }
        }
    }
}

// MARK: - Map

public extension Publisher {
    func compactMap<A: AnyObject, Result>(weak obj: A, selector: @escaping (A, Output) -> Result?) -> Publishers.CompactMap<Self, Result> {
        compactMap { [weak obj] value -> Result? in
            guard let obj = obj else {
                return nil
            }
            return selector(obj, value)
        }
    }
    
    func flatMap<A: AnyObject, P: Publisher>(weak obj: A, selector: @escaping (A, Output) -> P) -> AnyPublisher<P.Output, P.Failure> where Failure == P.Failure {
        flatMap { [weak obj] value -> AnyPublisher<P.Output, P.Failure> in
            guard let obj = obj else {
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
            return selector(obj, value)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Filter

public extension Publisher {
    func filter<A: AnyObject>(weak obj: A, selector: @escaping (A, Output) -> Bool) -> Publishers.Filter<Self> {
        filter { [weak obj] value -> Bool in
            guard let obj = obj else {
                return false
            }
            return selector(obj, value)
        }
    }
}
