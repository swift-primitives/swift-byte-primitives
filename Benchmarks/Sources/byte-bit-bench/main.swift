// byte-bit-bench — zero-cost validation for the typed byte→bit decomposition.
//
// Compares the TYPED decomposition surface (byte.bits / byte[i] -> Bit) against
// a RAW UInt8 baseline doing the identical shift+mask arithmetic. Reports
// ns/op (median + worst within-run CV over warmup + >=9 samples) and a
// heap-allocation delta (malloc_zone_statistics blocks_in_use) per kernel.
//
// Run RELEASE only, binary directly (never `swift test`):
//   rm -rf .build && swift build -c release && .build/release/byte-bit-bench

import Bit_Pattern_Primitives
import Bit_Primitive
import Byte_Bit_Primitives
import Byte_Primitive
import Darwin

// MARK: - Opaque source / sink (defeat constant folding)

@inline(never)
func opaque<T>(_ value: T) -> T { value }

@inline(never)
func blackHole<T>(_ value: T) {
    // Force the value to be observed without the optimizer discarding the work.
    if CommandLine.arguments.count == Int.max { print(value) }
}

// MARK: - Inputs (allocated once, outside any timed region)

let count = 1 << 16  // 65,536 bytes
// Runtime-seeded pattern so the optimizer cannot precompute the folds.
let seed = UInt8(truncatingIfNeeded: CommandLine.arguments.count &* 0x9E &+ 0x37)
let rawInput: [UInt8] = (0..<count).map { UInt8(truncatingIfNeeded: $0) &* 31 &+ seed }
let byteInput: [Byte] = rawInput.map(Byte.init)

// MARK: - Kernels — fold the 8 bits of every byte into a checksum

@inline(never)
func rawFold(_ input: [UInt8]) -> UInt64 {
    var acc: UInt64 = 0
    for u in input {
        for i in 0..<8 {
            acc &+= UInt64((u >> UInt8(i)) & 1)
        }
    }
    return acc
}

@inline(never)
func typedFold(_ input: [Byte]) -> UInt64 {
    var acc: UInt64 = 0
    for byte in input {
        for i in 0..<8 {
            acc &+= UInt64(byte[i].rawValue)
        }
    }
    return acc
}

// MARK: - Kernels — population count of every byte

@inline(never)
func rawPopcount(_ input: [UInt8]) -> UInt64 {
    var acc: UInt64 = 0
    for u in input {
        acc &+= UInt64(u.nonzeroBitCount)
    }
    return acc
}

@inline(never)
func typedPopcount(_ input: [Byte]) -> UInt64 {
    var acc: UInt64 = 0
    for byte in input {
        acc &+= UInt64(byte.bits.popcount)
    }
    return acc
}

// MARK: - Timing harness

struct Sample {
    let nsPerOp: Double
}

func measure(
    name: String,
    opsPerBatch: Int,
    warmup: Int = 5,
    samples: Int = 11,
    batch: () -> UInt64
) -> (median: Double, cvPercent: Double, sink: UInt64) {
    var sink: UInt64 = 0
    for _ in 0..<warmup { sink &+= opaque(batch()) }

    var nsValues: [Double] = []
    nsValues.reserveCapacity(samples)
    let clock = ContinuousClock()
    for _ in 0..<samples {
        let elapsed = clock.measure { sink &+= opaque(batch()) }
        let ns = Double(elapsed.components.attoseconds) / 1_000_000_000.0
            + Double(elapsed.components.seconds) * 1_000_000_000.0
        nsValues.append(ns / Double(opsPerBatch))
    }
    let sorted = nsValues.sorted()
    let median = sorted[sorted.count / 2]
    let mean = nsValues.reduce(0, +) / Double(nsValues.count)
    let variance = nsValues.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(nsValues.count)
    let cv = (variance.squareRoot() / mean) * 100
    blackHole(sink)
    return (median, cv, sink)
}

// MARK: - Allocation probe

func heapBlocksDelta(_ body: () -> UInt64) -> (delta: Int, sink: UInt64) {
    var before = malloc_statistics_t()
    var after = malloc_statistics_t()
    let zone = malloc_default_zone()
    // settle
    var sink: UInt64 = 0
    sink &+= opaque(body())
    malloc_zone_statistics(zone, &before)
    sink &+= opaque(body())
    malloc_zone_statistics(zone, &after)
    blackHole(sink)
    return (Int(after.blocks_in_use) - Int(before.blocks_in_use), sink)
}

// MARK: - Run

// One timed "op" = processing one byte (the 8-bit inner work counts as the op).
let opsPerBatch = count

let rawFoldR = measure(name: "raw fold", opsPerBatch: opsPerBatch) { rawFold(rawInput) }
let typedFoldR = measure(name: "typed fold", opsPerBatch: opsPerBatch) { typedFold(byteInput) }
let rawPopR = measure(name: "raw popcount", opsPerBatch: opsPerBatch) { rawPopcount(rawInput) }
let typedPopR = measure(name: "typed popcount", opsPerBatch: opsPerBatch) { typedPopcount(byteInput) }

let rawFoldAlloc = heapBlocksDelta { rawFold(rawInput) }
let typedFoldAlloc = heapBlocksDelta { typedFold(byteInput) }
let rawPopAlloc = heapBlocksDelta { rawPopcount(rawInput) }
let typedPopAlloc = heapBlocksDelta { typedPopcount(byteInput) }

// Correctness cross-check: typed and raw MUST agree (else the comparison is void).
precondition(rawFoldR.sink % 1 == typedFoldR.sink % 1)  // keep sinks live
precondition(rawFold(rawInput) == typedFold(byteInput), "fold mismatch")
precondition(rawPopcount(rawInput) == typedPopcount(byteInput), "popcount mismatch")

func fmt(_ d: Double) -> String {
    // Foundation-free fixed 4-decimal formatting.
    let scaled = (d * 10_000).rounded()
    let whole = Int(scaled) / 10_000
    let frac = Int(scaled) % 10_000
    var fracStr = "\(frac)"
    while fracStr.count < 4 { fracStr = "0" + fracStr }
    return "\(whole).\(fracStr)"
}

print("byte-bit decomposition — typed vs raw  (\(count) bytes/batch, 11 samples)")
print("")
print("kernel           | ns/byte (median) | CV%    | heap blocks delta")
print("-----------------|------------------|--------|------------------")
print("raw   fold       | \(fmt(rawFoldR.median))           | \(fmt(rawFoldR.cvPercent))  | \(rawFoldAlloc.delta)")
print("typed fold       | \(fmt(typedFoldR.median))           | \(fmt(typedFoldR.cvPercent))  | \(typedFoldAlloc.delta)")
print("raw   popcount   | \(fmt(rawPopR.median))           | \(fmt(rawPopR.cvPercent))  | \(rawPopAlloc.delta)")
print("typed popcount   | \(fmt(typedPopR.median))           | \(fmt(typedPopR.cvPercent))  | \(typedPopAlloc.delta)")
print("")
let foldRatio = typedFoldR.median / rawFoldR.median
let popRatio = typedPopR.median / rawPopR.median
print("fold     typed/raw ratio: \(fmt(foldRatio))×")
print("popcount typed/raw ratio: \(fmt(popRatio))×")
