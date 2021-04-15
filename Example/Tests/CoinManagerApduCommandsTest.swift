import Quick
import Nimble
@testable import TonNfcClientSwift


@available(iOS 13.0, *)
class CoinManagerApduCommandsTest: QuickSpec {
    override func spec() {
        let badPins : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x36, count: CommonConstants.PIN_SIZE - 1),
            [UInt8](repeating: 0x36, count: CommonConstants.PIN_SIZE + 1)
        ]
        let pin : [UInt8] = [UInt8](repeating: 0x35, count: CommonConstants.PIN_SIZE)
        let newPin : [UInt8] = [UInt8](repeating: 0x36, count: CommonConstants.PIN_SIZE)
        let badLabels : [[UInt8]] = [
            [],
            [UInt8](repeating: 0, count: CoinManagerConstants.LABEL_LENGTH - 1),
            [UInt8](repeating: 0, count: CoinManagerConstants.LABEL_LENGTH + 1)
        ]
        let label : [UInt8] = [UInt8](repeating: 0, count: CoinManagerConstants.LABEL_LENGTH)
        
        
        context("When it's requesting GENERATE_SEED APDU command with incorrect pin", {
            it("throws a error") {
                for badPin in badPins {
                    expect ( expression: {try CoinManagerApduCommands.getGenSeedApdu(badPin) })
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
                    expect ( expression: {try CoinManagerApduCommands.getSetDeviceLabelApdu(badLabel)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_LABEL_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GENERATE_SEED APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try CoinManagerApduCommands.getGenSeedApdu(pin)
                    expect(apdu.instructionClass) == CoinManagerApduCommands.COIN_MANAGER_CLA
                    expect(apdu.instructionCode) == CoinManagerApduCommands.COIN_MANAGER_INS
                    expect(apdu.p1Parameter) == CoinManagerApduCommands.COIN_MANAGER_P1
                    expect(apdu.p2Parameter) == CoinManagerApduCommands.COIN_MANAGER_P2
                    let data =  Data(_ : CoinManagerApduCommands.GENERATE_SEED_DATA + [UInt8(CommonConstants.PIN_SIZE)] + pin)
                    expect(apdu.data) == data
                    expect(apdu.expectedResponseLength) == -1
                }
                catch{
                    fail()
                }
            }
        })
        
        context("When it's requesting CHANGE_PIN APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try CoinManagerApduCommands.getChangePinApdu(oldPin: pin, newPin: newPin)
                    expect(apdu.instructionClass) == CoinManagerApduCommands.COIN_MANAGER_CLA
                    expect(apdu.instructionCode) == CoinManagerApduCommands.COIN_MANAGER_INS
                    expect(apdu.p1Parameter) == CoinManagerApduCommands.COIN_MANAGER_P1
                    expect(apdu.p2Parameter) == CoinManagerApduCommands.COIN_MANAGER_P2
                    let data =  Data(_ : CoinManagerApduCommands.CHANGE_PIN_DATA + [UInt8(CommonConstants.PIN_SIZE)] + pin + [UInt8(CommonConstants.PIN_SIZE)] + newPin)
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
                    let apdu = try CoinManagerApduCommands.getSetDeviceLabelApdu(label)
                    expect(apdu.instructionClass) == CoinManagerApduCommands.COIN_MANAGER_CLA
                    expect(apdu.instructionCode) == CoinManagerApduCommands.COIN_MANAGER_INS
                    expect(apdu.p1Parameter) == CoinManagerApduCommands.COIN_MANAGER_P1
                    expect(apdu.p2Parameter) == CoinManagerApduCommands.COIN_MANAGER_P2
                    let data =  Data(_ : CoinManagerApduCommands.SET_DEVICE_LABEL_DATA + [UInt8(CoinManagerConstants.LABEL_LENGTH)] + label)
                    expect(apdu.data) == data
                    expect(apdu.expectedResponseLength) == -1
                }
                catch{
                    fail()
                }
            }
        })
        
        context("When it's requesting CoinManager APDU command name", {
            it("returns name") {
                do {
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.SELECT_COIN_MANAGER_APDU)) == CoinManagerApduCommands.SELECT_COIN_MANAGER_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_PIN_TLT_APDU)) == CoinManagerApduCommands.GET_PIN_TLT_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_PIN_RTL_APDU)) == CoinManagerApduCommands.GET_PIN_RTL_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_DEVICE_LABEL_APDU)) == CoinManagerApduCommands.GET_DEVICE_LABEL_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_SE_VERSION_APDU)) == CoinManagerApduCommands.GET_SE_VERSION_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_CSN_APDU)) == CoinManagerApduCommands.GET_CSN_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_APPLET_LIST_APDU)) == CoinManagerApduCommands.GET_APPS_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_ROOT_KEY_STATUS_APDU)) == CoinManagerApduCommands.GET_ROOT_KEY_STATUS_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.RESET_WALLET_APDU)) == CoinManagerApduCommands.RESET_WALLET_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: try CoinManagerApduCommands.getGenSeedApdu(pin))) == CoinManagerApduCommands.GENERATE_SEED_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: CoinManagerApduCommands.GET_AVAILABLE_MEMORY_APDU)) == CoinManagerApduCommands.GET_AVAILABLE_MEMORY_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: try CoinManagerApduCommands.getChangePinApdu(oldPin: pin, newPin: pin))) == CoinManagerApduCommands.CHANGE_PIN_NAME
                    expect(CoinManagerApduCommands.getApduName(apdu: try CoinManagerApduCommands.getSetDeviceLabelApdu(label))) == CoinManagerApduCommands.SET_DEVICE_LABEL_NAME
                }
                catch{
                    fail()
                }
            }
        })
        
        context("When it's requesting NOT CoinManager APDU command name", {
            it("returns nil") {
                expect(CoinManagerApduCommands.getApduName(apdu: TonWalletAppletApduCommands.GET_APP_INFO_APDU)).to(beNil())
            }
        })
        
        
    }
}


