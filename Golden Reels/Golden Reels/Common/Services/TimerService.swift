import Foundation

struct TimerTime {
    enum TimeType {
        case prepare
        case work
        case rest
        case finish
    }
    
    let timeType: TimeType
    let time: Int
    let currentRound: Int
}

class TimerService {
    var isPause: Bool = false
    var isFireing: Bool {
        return timer?.isValid == true
    }
    
    var currentRoundWithOutRests: Int {
        switch currentIntervalIndex {
        case 0: return 1
        case 1: return 2
        case 2: return 2
        case 3: return 3
        case 4: return 3
        default: return 3
        }
    }
    
    var currentTypeWithOutPrepare: TimerTime.TimeType {
        return ((currentIntervalIndex) % 2 == 0 ? .work : .rest)
    }
    
    private var timer: Timer?
    private var intervals: [Int] = []
    private var currentInterval = 0 {
        didSet {
            
            handlerTime?(
                .init(
                    timeType: currentIntervalIndex == 0 ? .prepare : ((currentIntervalIndex - 1) % 2 == 0 ? .work : .rest),
                    time: currentInterval,
                    currentRound: max(0, currentIntervalIndex - 1)
                )
            )
        }
    }
    var currentIntervalIndex = 0
    private var isNext = false
    private var isPrevious = false
    
    private var handlerTime: ((_ time: TimerTime) -> Void)?
    
    func startTimer(
        workTime: Int,
        restTime: Int,
        rounds: Int,
        handlerTime: @escaping (_ time: TimerTime) -> Void
    ) {
        self.handlerTime = handlerTime
        timer?.invalidate()
        intervals = []
        
        intervals.append(10)
        for _ in 0..<rounds {
            intervals.append(workTime)
            intervals.append(restTime)
        }
        intervals.removeLast() // remove last rest
        
        currentInterval = workTime
        currentIntervalIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.TimerFire()
        })
    }
    
    func startTimer(
        intervals: [Int],
        handlerTime: @escaping (_ time: TimerTime) -> Void
    ) {
        self.isPause = false
        self.handlerTime = handlerTime
        timer?.invalidate()
        self.intervals = intervals
        
        currentInterval = intervals[0]
        currentIntervalIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.TimerFire()
        })
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func previous() {
        isPrevious = true
        isPause = false
        TimerFire()
    }
    
    func next() {
        isNext = true
        isPause = false
        TimerFire()
    }
    
    private func TimerFire() {
        if isPause { return }
        
        guard currentIntervalIndex <= intervals.count - 1 else {
            timer?.invalidate() // Цикл закончился
            handlerTime?(
                .init(
                    timeType: .finish,
                    time: currentInterval,
                    currentRound: 1
                )
            )
            return
        }
        
        if isPrevious == true {
            isPrevious = false
            if currentIntervalIndex >= 1 {
                currentInterval = intervals[currentIntervalIndex - 1]
                currentIntervalIndex -= 1
            }
        } else if currentInterval == 0 || isNext {
            currentIntervalIndex += 1
            if currentIntervalIndex <= intervals.count - 1 {
                currentInterval = intervals[currentIntervalIndex]
            }
            if isNext {
                isNext = false
            }
        } else {
            currentInterval -= 1
        }
    }
}
