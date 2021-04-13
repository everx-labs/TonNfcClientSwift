import Quick
import Nimble
@testable import TonNfcClientSwift

@available(iOS 13.0, *)
class CoinManagerApduCommandsTest: QuickSpec {
    override func spec() {
        let badPins : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x36, count: TonWalletAppletConstants.PIN_SIZE - 1),
            [UInt8](repeating: 0x36, count: TonWalletAppletConstants.PIN_SIZE + 1)
        ]
        let pin : [UInt8] = [UInt8](repeating: 0x35, count: TonWalletAppletConstants.PIN_SIZE)
        let newPin : [UInt8] = [UInt8](repeating: 0x36, count: TonWalletAppletConstants.PIN_SIZE)
        let badLabels : [[UInt8]] = [
            [],
            [UInt8](repeating: 0, count: CoinManagerConstants.LABEL_LENGTH - 1),
            [UInt8](repeating: 0, count: CoinManagerConstants.LABEL_LENGTH + 1)
        ]
        let label : [UInt8] = [UInt8](repeating: 0, count: CoinManagerConstants.LABEL_LENGTH)
        
        
        context("When it's requesting GENERATE_SEED APDU command with incorrect pin", {
            it("throws a error") {
                for badPin in badPins {
                    expect ( expression: {try CoinManagerApduCommands.getGenSeedApdu(pin: badPin) })
                        .to(throwError { (error: Error) in
                            expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT
                        })
                }
            }
        })
        
        context("When it's requesting CHANGE_PIN APDU command with incorrect old pin", {
            it("throws a error") {
                for badPin in badPins {
                    expect ( expression: {try CoinManagerApduCommands.getChangePinApdu(oldPin: badPin, newPin: newPin)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        
        context("When it's requesting CHANGE_PIN APDU command with incorrect new pin", {
            it("throws a error") {
                for badPin in badPins {
                    expect ( expression: {try CoinManagerApduCommands.getChangePinApdu(oldPin: pin, newPin: badPin)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting SET_DEVICE_LABEL APDU command with incorrect label", {
            it("throws a error") {
                for badLabel in badLabels {
                    expect ( expression: {try CoinManagerApduCommands.getSetDeviceLabelApdu(label: badLabel)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_LABEL_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting CHANGE_PIN APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try CoinManagerApduCommands.getChangePinApdu(oldPin: pin, newPin: newPin)
                    expect(apdu.instructionClass) == CoinManagerApduCommands.CLA
                    expect(apdu.instructionCode) == CoinManagerApduCommands.INS
                    expect(apdu.p1Parameter) == CoinManagerApduCommands.P1
                    expect(apdu.p2Parameter) == CoinManagerApduCommands.P2
                    let data =  Data(_ : CoinManagerApduCommands.CHANGE_PIN_BYTES + [UInt8(TonWalletAppletConstants.PIN_SIZE)] + pin + [UInt8(TonWalletAppletConstants.PIN_SIZE)] + newPin)
                    expect(apdu.data) == data
                    expect(apdu.expectedResponseLength) == -1
                }
                catch{
                    fail()
                }
            }
        })
        
        context("When it's requesting SET_DEVICE_LABEL APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try CoinManagerApduCommands.getSetDeviceLabelApdu(label: label)
                    expect(apdu.instructionClass) == CoinManagerApduCommands.CLA
                    expect(apdu.instructionCode) == CoinManagerApduCommands.INS
                    expect(apdu.p1Parameter) == CoinManagerApduCommands.P1
                    expect(apdu.p2Parameter) == CoinManagerApduCommands.P2
                    let data =  Data(_ : CoinManagerApduCommands.SET_DEVICE_LABEL_BYTES + [UInt8(CoinManagerConstants.LABEL_LENGTH)] + label)
                    print()
                    expect(apdu.data) == data
                    expect(apdu.expectedResponseLength) == -1
                }
                catch{
                    fail()
                }
            }
        })
    }
}


