import SwiftIO

public final class LCD1602 {

    private enum Command {
        static let clearDisplay: UInt8 = 0x01
        static let returnHome: UInt8 = 0x02
        static let entryModeSet: UInt8 = 0x04
        static let displayControl: UInt8 = 0x08
        static let cursorShift: UInt8 = 0x10
        static let functionSet: UInt8 = 0x20
        static let setCGRAMAddr: UInt8 = 0x40
        static let setDDRAMAddr: UInt8 = 0x80
    }

    private enum EntryMode {
        static let entryRight: UInt8 = 0x00
        static let entryLeft: UInt8 = 0x02
        static let entryShiftIncrement: UInt8 = 0x01
        static let entryShiftDecrement: UInt8 = 0x00
    }

    private enum Control {
        static let displayOn: UInt8 = 0x04
        static let displayOff: UInt8 = 0x00
        static let cursorOn: UInt8 = 0x02
        static let cursorOff: UInt8 = 0x00
        static let blinkOn: UInt8 = 0x01
        static let blinkOff: UInt8 = 0x00
    }

    private enum Shift {
        static let displayMove: UInt8 = 0x08
        static let cursorMove: UInt8 = 0x00
        static let moveRight: UInt8 = 0x04
        static let moveLeft: UInt8 = 0x00
    }

    private enum Mode {
        static let _8BitMode: UInt8 = 0x10
        static let _4BitMode: UInt8 = 0x00
        static let _2Line: UInt8 = 0x08
        static let _1Line: UInt8 = 0x00
        static let _5x10Dots: UInt8 = 0x04
        static let _5x8Dots: UInt8 = 0x00
    }

    public let address: UInt8 = 0x3E

    public let i2c: I2C

    public var displayFunctionState: UInt8
    public var displayControlState: UInt8
    public var displayModeState: UInt8
    public var numLines: UInt8
    public var currLine: UInt8


    public convenience init(_ i2c: I2C) {
        self.init(i2c, 16, 2, 0)
    }

    public init(_ i2c: I2C, _ cols: UInt8, _ rows: UInt8, _ dotSize: UInt8) {
        self.i2c = i2c

        displayFunctionState = 0
        displayControlState = 0
        displayModeState = 0

        if rows > 1 {
            displayFunctionState |= Mode._2Line
        }

        numLines = rows
        currLine = 0

        if dotSize != 0 && rows == 1 {
            displayFunctionState |= Mode._5x10Dots
        }

        writeCommand(Command.functionSet | displayFunctionState)
        wait(us: 4500)

        writeCommand(Command.functionSet | displayFunctionState)
        wait(us: 150)

        writeCommand(Command.functionSet | displayFunctionState)
        writeCommand(Command.functionSet | displayFunctionState)

        displayControlState =   Control.displayOn | Control.cursorOff | Control.blinkOff
        turnOn()

        clear()

        displayModeState = EntryMode.entryLeft | EntryMode.entryShiftDecrement
        writeCommand(Command.entryModeSet | displayModeState)
    }


    public func turnOn() {
        displayControlState |= Control.displayOn
        writeCommand(Command.displayControl | displayControlState)
    }

    public func turnOff() {
        displayControlState &= ~Control.displayOn;
        writeCommand(Command.displayControl | displayControlState)
    }

    public func clear() {
        writeCommand(Command.clearDisplay)
        wait(us: 2000)
    }

    public func home() {
        writeCommand(Command.returnHome)
        wait(us: 2000)
    }

    public func noCursor() {
        displayControlState &= ~Control.cursorOn
        writeCommand(Command.displayControl | displayControlState)
    }

    public func cursor() {
        displayControlState |= Control.cursorOn
        writeCommand(Command.displayControl | displayControlState)
    }

    public func noBlink() {
        displayControlState &= ~Control.blinkOn
        writeCommand(Command.displayControl | displayControlState)
    }

    public func blink() {
        displayControlState |= Control.blinkOn
        writeCommand(Command.displayControl | displayControlState)
    }

    public func scrollLeft() {
        writeCommand(Command.cursorShift | Shift.displayMove | Shift.moveLeft)
    }

    public func scrollRight() {
        writeCommand(Command.cursorShift | Shift.displayMove | Shift.moveRight)
    }

    public func leftToRight() {
        displayModeState |= EntryMode.entryLeft
        writeCommand(Command.entryModeSet | displayModeState)
    }

    public func rightToLeft() {
        displayModeState &= ~EntryMode.entryLeft
        writeCommand(Command.entryModeSet | displayModeState)
    }

    public func autoScroll() {
        displayModeState |= EntryMode.entryShiftIncrement
        writeCommand(Command.entryModeSet | displayModeState)
    }

    public func noAutoScroll() {
        displayModeState &= ~EntryMode.entryShiftIncrement
        writeCommand(Command.entryModeSet | displayModeState)
    }

    public func writeCommand(_ value: UInt8) {
        let data: [UInt8] = [0x80, value]
        i2c.write(data, to: address)
    }

    public func clear(x: Int, y: Int, _ count: Int) {
        let data: [UInt8] = [0x40, 0x20]

        setCursor(x: x, y: y)
        for _ in 1...count {
            i2c.write(data, to: address)
        }
        setCursor(x: x, y: y)
    }

    public func setCursor(x: Int, y: Int) {
        let val: UInt8 = y == 0 ? UInt8(x) | 0x80 : UInt8(x) | 0xc0
        writeCommand(val)
    }

    public func write(_ str: String) {
        let array: [UInt8] = Array(str.utf8)
        var data: [UInt8] = [0x40, 0]

        for item in array {
            data[1] = UInt8(item)
            i2c.write(data, to: address)
        }
    }

    public func write(x: Int, y: Int, _ num: Int) {
        write(x: x, y: y, String(num))
    }

    public func write(x: Int, y: Int, _ str: String) {
        setCursor(x: x, y: y)
        write(str)
    }
}
