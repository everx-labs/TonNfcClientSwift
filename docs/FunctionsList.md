# Full functions list (TonNfcClientSwift API)

There is full functions list provided by TonNfcClientSwift API to make different requests to NFC TON Labs Security cards. All these functions work via callbacks. The last two arguments of each function are _resolve : @escaping NfcResolver, reject : @escaping NfcRejecter_ (we omit them below for short). In the case of success wrapped card response is put into _resolve_. In the case of exception error message and error object are put into _reject_.

## NFC related functions

Here there are functions to check/change the state of your NFC hardware.  In TonNfcClientSwift library there is a class NfcApi for this.

- **checkIfNfcSupported()**

    Check if your Android device has NFC hardware. 

    *Responses:*

        {"message":"true","status":"ok"}
        {"message":"false","status":"ok"}

    
## CoinManager functions (CardCoinManagerApi)

Here there are functions to call APDU commands of CoinManager. CoinManager is an additional software integrated into NFC TON Labs Security card. It is responsible for maintaining ed25519 seed, related PIN and it provides some auxiliary operations.  In TonNfcClientSwift library there is a class CardCoinManagerApi providing all CoinManager functions.

- **setDeviceLabel(deviceLabel: String)**

    This function is used to set the device label. Now we do not use this device label stored in Coin Manager.

    *Arguments requirements:*
    
        deviceLabel — hex string of length 64, 
        example: '005815A3942073A6ADC70C035780FDD09DF09AFEEA4173B92FE559C34DCA0550'

    *Response:*

        {"message":"done","status":"ok"}


- **getDeviceLabel()**

    This function is used to get device label. Now we do not use this device label stored in Coin Manager.

    *Exemplary response:*

        {"message":"005815A3942073A6ADC70C035780FDD09DF09AFEEA4173B92FE559C34DCA0550","status":"ok"}

- **getSeVersion()**

    This function is used to get SE (secure element) version. 

    *Response:*

        {"message":"1008","status":"ok"}


- **getCsn()**

    This function is used to get CSN (SEID).

    *Exemplary response:*

        {"message":"11223344556677881122334455667788","status":"ok"}


- **getMaxPinTries()**

    This function is used to get retry maximum times of PIN. 

    *Response:*

        {"message":"10","status":"ok"}

- **getRemainingPinTries()**

    This function is used to get remaining retry times of PIN.

    *Exemplary response:*

        {"message":"10","status":"ok"}


- **getRootKeyStatus()**

    This function is used to get the status of seed for ed25519: is it generated or not.

    *Response:*
    
        a) If seed is present: {"message":"generated","status":"ok"}
        b) If seed is not present: {"message":"not generated","status":"ok"}


- **resetWallet()**

    This function is used to reset the wallet state to the initial state. After resetting the wallet, the default PIN value would be 5555. The remaining number of retry for PIN will be reset to MAX (default is 10). The seed for ed25519 will be erased. And after its calling any card operation (except of CoinManager stuff) will fail with 6F02 error. TON Labs wallet applet does not work without seed at all.

    *Response:*

        {"message":"done","status":"ok"}


- **getAvailableMemory()**

    This function is used to obtain the amount of memory of the specified type that is available to the applet. Note that implementation-dependent memory overhead structures may also use the same memory pool.
        
    *Exemplary response:*

        will be added soon


- **getAppsList()**

    This function is used to get application list. It returns list of applets AIDs that were installed onto card.

    *Exemplary response:*

        {"message":"4F0D31313232333334343535363600","status":"ok"}

    _Note:_ Here 313132323333343435353636 is AID of our TON Labs wallet applet

- **generateSeed(pin: String)**

    This function is used to generate the seed for ed25519 with RNG.

    *Arguments requirements:*

        pin — numeric string of length 4, example: '5555'

    By the way 5555 is a default PIN for all cards. 

    *Response:*

        If seed does not exist then: {"message":"done","status":"ok"}
        If seed already exists and you call generateSeed then it will throw a error.


- **changePin(oldPin: String, newPin: String**

    This function is used to change PIN.

    *Arguments requirements:*
           
        oldPin — numeric string of length 4, example: '5555'
        newPin — numeric string of length 4, example: '6666'

    *Response:*

        {"message":"done","status":"ok"}


## Functions to work with TON Labs wallet applet

TON Labs wallet applet is software developed by TON Labs team and integrated into NFC TON Labs Security card. It provides main card functionality. It takes seed for ed25519 signature from CoinManager entity.

These functions are naturally divided into four groups. And there are respectively four classes in TonNfcClientAndroid library providing an API: CardActivationApi,  CardCryptoApi,  CardKeyChainApi, RecoveryDataApi. And there is a superclass TonWalletApi containing some common functions and functions to maintain keys for HMAC SHA256 signature (see section Protection against MITM).

### TonWalletApi functions

#### 1) Common functions

- **getTonAppletState()**

    This function returns state of TON Labs wallet applet.

    *Exemplary responses:*

    {"message":"TonWalletApplet waits two-factor authorization.","status":"ok"}

    {"message":"TonWalletApplet is personalized.","status":"ok"}

    Note: Full list of applet states you may find in previous sections.

- **getSerialNumber()**

    This function returns serial number (SN). It must be identical to SN printed on the card.

    *Exemplary response:*

    {"message":"504394802433901126813236","status":"ok"}

- **getSault()**

    This function returns fresh 32 bytes sault generated by the card. 

    *Exemplary response:*

    {"message":"B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A","status":"ok"}

- **disconnectCard()**

    Breaks NFC connection. 

    *Response:*

    {"message":"done","status":"ok"}

#### 2) Functions to mantain keys for HMAC SHA256 

- **selectKeyForHmac(String serialNumber)**

    Manually select new active card (it selects the serial number and correspondingly choose the appropriate key HMAC SHA256 from Android Keystore).

    *Arguments requirements:*

    serialNumber — numeric string of length 24, example: "50439480243390112681323"

    *Response:*

    {"message":"done","status":"ok"}

- **createKeyForHmac(String authenticationPassword, String commonSecret, String serialNumber)**

    If you reinstalled app and lost HMAC SHA256 symmetric key for the card from your Android keystore, then create the key for your card using this function.

    *Arguments requirements:*

     authenticationPassword — hex string of length 256, example: "4A0FD62FFC3249A45ED369BD9B9CB340829179E94B8BE546FB19A1BC67C9411BC5DC85B5E38F96689B921A64DEF1A3B6F4D2F5C7D2B0BD7CCE420DBD281BA1CC82EE0B233820EB5CFE505B7201903ABB12959B251A5A8525B2515F57ACDE30905E70C2A375D5C0EC10A5EA6E264206395BF163969632398FA4A88D359FEA21D9"

    commonSecret — hex string of length 64, example: "9CEE28E284487EEB8FA6CE7C101C1184BB368F0CCAD057C9D89F7EC3307E72BA"

    serialNumber — numeric string of length 24, example: "50439480243390112681323"

    *Note 1:* Use here activation data tuple  (authenticationPassword, commonSecret) that is correct for your card, i.e. corresponds to your serialNumber.

    *Note 2:* If the key for your card already exists in keystore it will not throw a error. It will just delete and recreate the key for you.

    *Response:*

    {"message":"done","status":"ok"}

- **getCurrentSerialNumber()**

    Get serial number of currently active key (card). In fact this is a serialNumber of the card with which your app communicated last time.

    *Exemplary response:*

    {"message":"504394802433901126813236","status":"ok"}

- **getAllSerialNumbers()**

    Get the list of card serial numbers for which we have keys in Android keystore.

    *Exemplary response:*

    {"serial_number_field":["504394802433901126813236", "455324585319848551839771"],"status":"ok"}

- **isKeyForHmacExist(String serialNumber)**

    Check if key for given serialNumber exists in Android keystore.

    *Arguments requirements:*

    serialNumber — numeric string of length 24, example: "50439480243390112681323"

    *Exemplary response:*

    {"message":"true","status":"ok"}

- **deleteKeyForHmac(String serialNumber)**

    Delete key for given serialNumber from Android keystore.

    *Arguments requirements:*

    serialNumber — numeric string of length 24, example: "50439480243390112681323"

    *Response:*

    {"message":"done","status":"ok"}

### CardActivationApi functions

When user gets NFC TON Labs security card  at the first time, the applet on the card is in a special state. It waits for user authentication. And the main functionality of applet is blocked for now. At this point you may call all functions from previous subsections. 

And also some special functions are available in CardActivationApi. They are necessary to complete card activation (see Card activation section). 

- **turnOnWallet(String newPin, String password, String commonSecret, String initialVector)**

    This function makes TON Labs wallet applet activation. After its succesfull call applet will be in working personalized state (so getTonAppletState() will return {"message":"TonWalletApplet is personalized.","status":"ok"}).

    *Arguments requirements:*

    newPin — numeric string of length 4, example: '7777'

     password — hex string of length 256, example: "4A0FD62FFC3249A45ED369BD9B9CB340829179E94B8BE546FB19A1BC67C9411BC5DC85B5E38F96689B921A64DEF1A3B6F4D2F5C7D2B0BD7CCE420DBD281BA1CC82EE0B233820EB5CFE505B7201903ABB12959B251A5A8525B2515F57ACDE30905E70C2A375D5C0EC10A5EA6E264206395BF163969632398FA4A88D359FEA21D9"

    commonSecret — hex string of length 64, example: "9CEE28E284487EEB8FA6CE7C101C1184BB368F0CCAD057C9D89F7EC3307E72BA"

    initialVector — hex string of length 32, example: "E439F75C6FC516F1C4725E825164216C"

    Note: Use here activation data tuple  (authenticationPassword, commonSecret, initialVector) that is correct for your card, i.e. corresponds to your serialNumber.

    *Response:*

    {"message":"TonWalletApplet is personalized.","status":"ok"}

- **getHashOfEncryptedCommonSecret()**

    Return SHA256 hash of encrypted common secret.

    *Exemplary response:*

    {"message":"EFBF24AC1563B34ADB0FFE0B0A53659E72E26765704C109C95346EEAA1D4BEAF","status":"ok"}

- **getHashOfEncryptedPassword()**

    Return SHA256 hash of encrypted password.

    *Exemplary responses:*

    {"message":"26D4B03C0C0E168DC33E48BBCEB457C21364658C9D487341827BBFFB4D8B38F3","status":"ok"}

### CardCryptoApi functions

Here there are functions related to ed25519 signature.

- **getPublicKeyForDefaultPath()**

    Return public key for HD path m/44'/396'/0'/0'/0'

    *Exemplary response:*

    {"message":"B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A","status":"ok"}

- **verifyPin(String pin)**

    Make pin verification.

    *Arguments requirements:*

    pin — numeric string of length 4, example: '5555'

    *Response:*

    {"message":"done","status":"ok"}

- **signForDefaultHdPath(String dataForSigning)**

    Make  data signing by key for HD path m/44'/396'/0'/0'/0'. Prior to call this function you must call verifyPin.

    *Arguments requirements:*

    data — hex string of even length ≥ 2 and ≤ 378.

    *Exemplary response:*

    {"message":"2D6A2749DD5AF5BB356220BFA06A0C624D5814438F37983322BBAD762EFB4759CFA927E6735B7CD556196894F3CE077ADDD6B49447B8B325ADC494B82DC8B605","status":"ok"}

- **sign(String dataForSigning, String index)**

    Make data signing by key for HD path m/44'/396'/0'/0'/index'. Prior to call this function you must call verifyPin.

    *Arguments requirements:*

    index — numeric string of length > 0 and ≤ 10.

    data — hex string of even length ≥ 2 and ≤ 356.

    *Exemplary response:*

    {"message":"13FB836213B12BBD41209273F81BCDCF7C226947B18128F73E9A6E96C84B30C3288E51C622C045488981B6544D02D0940DE54D68A0A78BC2A5F9523B8757B904","status":"ok"}

- **getPublicKey(String index)**

    Return public key for HD path m/44'/396'/0'/0'/index'.

    *Arguments requirements:*

    index — numeric string of length > 0 and ≤ 10.

    *Exemplary response:*

    {"message":"B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A","status":"ok"}

- **verifyPinAndSignForDefaultHdPath(String dataForSigning, String pin)**

    Make  pin verification data signing by key for HD path m/44'/396'/0'/0'/0'. Prior to call this function you must call verifyPin.

    *Arguments requirements:*

    pin — numeric string of length 4, example: '5555'

    data — hex string of even length ≥ 2 and ≤ 378.

    *Exemplary response:*

    {"message":"2D6A2749DD5AF5BB356220BFA06A0C624D5814438F37983322BBAD762EFB4759CFA927E6735B7CD556196894F3CE077ADDD6B49447B8B325ADC494B82DC8B605","status":"ok"}

- **verifyPinAndSign(String dataForSigning, String index, String pin)**

    Make pin verification and data signing by key for HD path m/44'/396'/0'/0'/index'.

    *Arguments requirements:*

    pin — numeric string of length 4, example: '5555'

    index — numeric string of length > 0 and ≤ 10.

    data — hex string of even length ≥ 2 and ≤ 356.

    *Exemplary response:*

    {"message":"13FB836213B12BBD41209273F81BCDCF7C226947B18128F73E9A6E96C84B30C3288E51C622C045488981B6544D02D0940DE54D68A0A78BC2A5F9523B8757B904","status":"ok"}

### RecoveryDataApi functions

- **getRecoveryDataLen()**

    Read actual recovery data length.

    *Exemplary response:* 

    {"message":"7","status":"ok"}

- **getRecoveryDataHash()**

    Read recovery data SHA256 hash.

    *Exemplary response:* 

    {"message":"B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A","status":"ok"}

- **getRecoveryData()**

    Read  recovery data from TON Wallet applet.

    *Exemplary response:* 

    {"message":"00112233445566","status":"ok"}

- **addRecoveryData(String recoveryData)**

    Save recovery data into applet. 

    *Arguments requirements:*

    recoveryData — hex string of even length ≥ 2 and ≤ 4096.

    *Response:*

    {"message":"done","status":"ok"}

- **isRecoveryDataSet()**

    Return 'true'/'false' if recovery data exists/does not exist.

    *Response:*

    1) If we added recovery data, then: {"message":"true","status":"ok"}

    2) If we did not add recovery data, then: {"message":"false","status":"ok"}

- **resetRecoveryData()**

    Clear recovery data.

    *Response:*

    {"message":"done","status":"ok"}

### CardKeyChainApi functions

- **resetKeyChain()**

    Clear keychain, i.e. remove all stored keys.

    *Response:*

    {"message":"done","status":"ok"}

- **getKeyChainDataAboutAllKeys()**

    Return list of pairs (keyHmac, keyLength)  in json format.

    *Exemplary response:*

    {"keysData":[{"hmac":"D7E0DFB66A2F72AAD7D66D897C805D307EE1F1CB8077D3B8CF1A942D6A5AC2FF","length":"6"},{"hmac":"D31D1D600F8E5B5951275B9C6DED079011FD852ABB62C14A2EECA2E6924452C0","length":"3"}],"status":"ok"}

- **getKeyChainInfo()**

    Return json characterizing the state of keychain. 

    *Exemplary response:*

    {"numberOfKeys":0,"occupiedSize":0,"freeSize":32767,"status":"ok"}

- **getNumberOfKeys()**

    Return number of keys in card keychain.

    *Exemplary response:*

    {"message":"1","status":"ok"}

- **getOccupiedStorageSize()**

    Return the volume of occupied size in card keychain (in bytes).

    *Exemplary response:*

    {"message":"0","status":"ok"}

- **getFreeStorageSize()**

    Return the volume of free size in card keychain (in bytes).

    *Exemplary response:*

    {"message":"32767","status":"ok"}

- **getKeyFromKeyChain(String keyHmac)**

    Read key from card keychain based on its hmac.

    *Arguments requirements:*

    keyHmac — hex string of length 64.

    *Exemplary response:*

    {"message":"001122334455","status":"ok"}

- **addKeyIntoKeyChain(String newKey)**

    Save new key into card keychain.

    *Arguments requirements:*

    neyKey — hex string of even length ≥ 2 and ≤ 16384.

    *Response:*

    {"message":"EFBF24AC1563B34ADB0FFE0B0A53659E72E26765704C109C95346EEAA1D4BEAF","status":"ok"}

    where "message" contains hmac of newKey.

- **deleteKeyFromKeyChain(String keyHmac)**

    Delete key from card keychain based on its hmac.

    *Arguments requirements:*

    keyHmac — hex string of length 64.

    *Exemplary response:*

    {"message":"5","status":"ok"}

    where "message" field contains the number of remaining keys

- **finishDeleteKeyFromKeyChainAfterInterruption()**

    Finish the process of deleting key from card keychain. It may be necessary if previous DELETE operation was occassionally interrupted (like card disconnection).

    *Exemplary response:*

    {"message":"5","status":"ok"}

    where "message" field contains the number of remaining keys

- **changeKeyInKeyChain(String newKey, String oldKeyHmac)**

    Replace existing key by new key. The length of new key must be equal to length of old key.

    *Arguments requirements:*

    newKey — hex string of even length ≥ 2 and ≤ 16384. 

    oldKeyHmac — hex string of length 64.

    *Response:*

    {"message":"EFBF24AC1563B34ADB0FFE0B0A53659E72E26765704C109C95346EEAA1D4BEAF","status":"ok"}

    where "message" contains hmac of newKey.

- **getIndexAndLenOfKeyInKeyChain(String keyHmac)**

    Read index (inside internal applet storage) and length of key by its hmac.

    *Arguments requirements:*

    keyHmac — hex string of length 64.

    *Exemplary response:*

    {"message":"{\"index\":1,\"length\":3}","status":"ok"}

- **checkAvailableVolForNewKey(Short keySize)**

    Check if there is enough free volume in card keychain to add new key of length = keySize. If there is no enough space then it throws an exception

    *Arguments requirements:*

    keySize — numeric string representing short value > 0 and ≤ 8192.

    *Response:*

    {"message":"done","status":"ok"}

- **checkKeyHmacConsistency(String keyHmac)**

    Checks if card's keychain stores a key with such keyHmac and if this hmac really corresponds to the key.

    *Response:*

    {"message":"done","status":"ok"}

- **getHmac(String index)**

    Get hmac of key in card keychain by its index. 

    *Arguments requirements:*

    index — digital string storing an integer ≥ 0 and ≤1023.

    *Exemplary response:*

    {"message":"EFBF24AC1563B34ADB0FFE0B0A53659E72E26765704C109C95346EEAA1D4BEAF","status":"ok"}

- **getDeleteKeyRecordNumOfPackets()**

    Returns the number of keys records packets that must be deleted to finish deleting of key.

    *Exemplary response:*

    {"message":"2","status":"ok"}

- **getDeleteKeyChunkNumOfPackets()**

    Returns the number of keys chunks packets that must be deleted to finish deleting of key.

    *Exemplary response:*

    {"message":"5","status":"ok"}

