import Foundation

func rand_int(_ n: Int) -> Int {
    Int.random(in: 0...n)
}

func doseq(_ range: ClojureRange, _ completion: @escaping (Int) -> Void) {
    range.forEach { completion($0) }
}

func forloop(_ range: ClojureRange) -> LazySequence<Generator> {
    Generator(range: range).lazy
}

// (doseq [x (range 0 10)] (prn x))
// doseq(range(0, 10)) { print($0) }

//forloop(range(0, 10))
//    .map { String($0) + "!" }
//    .forEach { print($0) }

func merge<S>(_ seq1: S, _ seq2: S) -> [S] where S: Sequence {
    return []
}

func inc<N>(_ s: N) -> N where N: Numeric {
    return s + 1
}

func dec<N>(_ s: N) -> N where N: Numeric {
    return s - 1
}

inc(dec(rand_int(10)))

inc(0)
inc(dec(0))

/// `cycle`
/// "Returns a lazy (infinite!) sequence of repetitions of the items in coll."
/// - Parameter range: range to cycle repeatedly
func cycle(_ range: ClojureRange) ->
    CycleSequence<Range<LazySequence<Array<Int>>.Element>> {
//    AnySequence<IndexingIterator<Array<Int>>.Element> {
    return CycleSequence(cycling: range.first!..<range.last!)
//    return cycleSequence(for: range)
}

take(10, cycle(range(0, 2)))
// [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]

//func cycleSequence<C: Collection>(for c: C) -> AnySequence<C.Iterator.Element> {
//    AnySequence(sequence(state: (elements: c, elementIterator: c.makeIterator()),
//                         next: { state in
//                            if let nextElement = state.elementIterator.next() {
//                                return nextElement
//                            } else {
//                                state.elementIterator = state.elements.makeIterator()
//                                return state.elementIterator.next()
//                            }
//                         })
//    )
//}

public struct CycleSequence<C: Collection>: Sequence {
    public let cycledElements: C

    public init(cycling cycledElements: C) {
        self.cycledElements = cycledElements
    }

    public func makeIterator() -> CycleIterator<C> {
        return CycleIterator(cycling: cycledElements)
    }
}

public struct CycleIterator<C: Collection>: IteratorProtocol {
    public let cycledElements: C
    public private(set) var cycledElementIterator: C.Iterator

    public init(cycling cycledElements: C) {
        self.cycledElements = cycledElements
        self.cycledElementIterator = cycledElements.makeIterator()
    }

    public mutating func next() -> C.Iterator.Element? {
        if let next = cycledElementIterator.next() {
            return next
        } else {
            self.cycledElementIterator = cycledElements.makeIterator() // Cycle back again
            return cycledElementIterator.next()
        }
    }
}

//let s1 = CycleSequence(cycling: [1, 2, 3]) // Works with arrays of numbers, as you would expect.
//// Taking one element at a time, manually
//var i1 = s1.makeIterator()
//print(i1.next() as Any) // => Optional(1)
//print(i1.next() as Any) // => Optional(2)
//print(i1.next() as Any) // => Optional(3)
//print(i1.next() as Any) // => Optional(1)
//print(i1.next() as Any) // => Optional(2)
//print(i1.next() as Any) // => Optional(3)
//print(i1.next() as Any) // => Optional(1)
//
//let s2 = CycleSequence(cycling: 2...5) // Works with any Collection. Ranges work!
//// Taking the first 10 elements
//print(Array(s2.prefix(10))) // => [2, 3, 4, 5, 2, 3, 4, 5, 2, 3]
//
//let s3 = CycleSequence(cycling: "abc") // Strings are Collections, so those work, too!
//s3.prefix(10).map{ "you can even map over me! \($0)" }.forEach{ print($0) }


//func cycle2(_ range: LazySequence<Array<Int>>, _ generator: Generator? = nil) {
//    var generator = generator == nil ? Generator(start: range.first!) : generator
//
//    let res = generator!.next()!
//    if res >= range.last! {
//        generator = Generator(start: range.first!)
//    }
//
//    cycle2(range, generator)
//}
//
//// cycle(range(0, 2))
//let result = (1...)
//   .lazy
//   .map { $0 }
//   .first(where: { $0 > 100})

struct Generator: Sequence, IteratorProtocol {
    var start: Int = 1
    var end: Int = 1
    var i: Int = 1
    
    init(range: ClojureRange) {
        start = range.first!
        end = range.last!
    }
    
    mutating func next()-> Int? {
        defer {
            start += i
        }
        
        if start >= end {
            return nil
        } else {
            return start
        }
    }
}

/// `take`
///
/// "Returns a lazy sequence of the first n items in coll, or all items if
/// there are fewer than n.  Returns a stateful transducer when
/// no collection is provided."
/// - Parameter n: number to take out of range
/// - Parameter range: given range of array
func take<S: Sequence>(_ n: Int, _ range: S) -> [S.Element] {
    zip(1...n, range).map { $1 }
}

/// `map`
///
/// "Returns a lazy sequence of the first n items in coll, or all items if
/// there are fewer than n.  Returns a stateful transducer when
/// no collection is provided."
/// - Parameter upto: number to take out of range
/// - Parameter range: given range of array
func map<A,B>(_ arr: [A], _ fn: ((A) -> B)) -> [B] where A: Equatable, B: Equatable {
    var res = [B]()

    for i in arr {
        res.append(fn(i))
    }

    return res
}

//let res2 = map(range(0, 10)) { String($0) }
// print(res2)
// ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

func filter<F>(_ arr: [F], _ fn: ((F) -> Bool)) -> [F] {
    var res = [F]()

    for i in arr {
        if fn(i) {
            res.append(i)
        }
    }

    return res
}

//let res3 = filter(range(0,6)) { $0 % 2 == 0 }
// print(res3)
// [0, 2, 4, 6]

//let arr = [1, 2, 3]
//var a: Int = 0

func reduce<F>(_ arr: [F], _ fn: ((F) -> F)) -> F where F: Numeric {
    var res: F = 0

    for i in arr {
        res += fn(i)
    }

    return res
}

//let sum = reduce(range(0, 100), +)
// print(sum)
// 5050

typealias ClojureRange = LazySequence<Array<Int>>
func range(_ from: Int, _ to: Int) -> ClojureRange {
    Array((from..<to)).lazy
}

//class FibIterator : IteratorProtocol {
//    var (a, b) = (0, 1)
//
//    func next() -> Int? {
//        (a, b) = (b, a + b)
//        return a
//    }
//}
//
//let fibs = AnySequence{ FibIterator() }
//Array(fibs.prefix(10))

// [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
