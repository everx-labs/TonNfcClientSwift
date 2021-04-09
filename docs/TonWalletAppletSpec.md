This specification describes all TON Wallet applet modes and APDU commands available in each mode. It provides working examples of APDU commands scripts.

TON Wallet applet may be in one of the following states (modes):

- Personalization (APP_INSTALLED = 0x07);
- Waiting for authorization (APP_WAITE_AUTHORIZATION_MODE = 0x27);
- Main working mode (APP_PERSONALIZED = 0x17);
- Blocked mode (APP_BLOCKED_MODE = 0x47);
- Delete key from keychain mode (APP_DELETE_KEY_FROM_KEYCHAIN_MODE = (byte) 0x37).

## APDU notations

We are using the following notation:

CLA = APDU command class

INS = APDU command type

P1= first param of APDU

P2= second param of APDU

LC = length of input data for APDU command

LE = length of response data array for APDU command.

| means concatenation.

Each APDU command field (CLA, INS, P1, P2, Lc and Le)  has a size = 1 byte except of Data.

APDU command may have one of the following format:

CLA | INS | P1 | P2 

CLA | INS | P1 | P2 | LC | Data

CLA | INS | P1 | P2 | LC | Data | LE

CLA | INS | P1 | P2 | LE

APDU command to select TON Wallet applet.

- **SELECT_TON_WALLET_APPLET**
   
   ***APDU input params:***

   CLA: 0x00

   INS:0xA4

   P1: 0x04

   P2:0x00
   
   LC: 0x0D
   
   Data: 0x31 0x31 0x32 0x32 0x33 0x33 0x34 0x34 0x35 0x35 0x36 0x36
   
   LE:  0x00


## APP_INSTALLED state/Personalization

After applet loading and installation on the card it will be in mode APP_INSTALLED. It will wait for personalization. Personalization will be done at factory. The following APDU commands will be available.

**Note**: After personalization is done applet state is switched into APP_WAITE_AUTHORIZATION_MODE. And this transition is irreversible. So the end user will not ever get the card with applet in this state.

- **SET_SERIAL_NUMBER**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x96

    P1: 0x00

    P2: 0x00

    LC: 0x18

    Data: Bytes of serial number

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — Length of APDU Data field ≠ 24.

    A002 — Each input byte of SN must contain value ≥ 0 and ≤ 9.

- **SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x91

    P1: 0x00

    P2: 0x00

    LC: 0x80

    Data: Bytes of encrypted activation password

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — Length of APDU Data field ≠ 128.

- **SET_ENCRYPTED_COMMON_SECRET**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x94

    P1: 0x00

    P2: 0x00

    LC: 0x20

    Data: Bytes of encrypted common secret

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — Length of APDU Data field ≠ 32.

- **GET_HASH_OF_ENCRYPTED_PASSWORD**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x93

    P1: 0x00

    P2: 0x00

    LE: 0x20

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 32.

    ***APDU response data:*** 

    32 bytes of SHA256(encrypted activation password)

- **GET_HASH_OF_COMMON_SECRET**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x95

    P1: 0x00

    P2: 0x00

    LE: 0x20

    ***APDU response status msg:***

    9000 — success

    ***APDU response data:*** 

    32 bytes of SHA256(common secret)

- **FINISH_PERS**

    This command finishes personalization and changes the state of applet. APP_WAITE_AUTHORIZATION_MODE state will be switched on .

    *Precondition:*  SET_PASSWORD_FOR_CARD_AUTHENTICATION and SET_COMMON_SECRE**T** should be called before, otherwise exception will be thrown.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x90

    P1: 0x00

    P2: 0x00

    ***APDU response status msg:***

    9000 — success

    *Protocols violation errors:*

    4F01 — personalization is not finished: encrypted activation password or common secret were not set successfully by corresponding APDU commands.

- **GET_APP_INFO**

    This command returns applet state.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xC1

    P1: 0x00

    P2: 0x00

    LE: 0x01

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 1.

    ***APDU response data:*** 

    1 byte (Applet state = 0x07, 0x17, 0x27, 0x37 or 0x47)

- **INS_GET_SERIAL_NUMBER**

    This command returns card serial number bytes.

    *APDU input params:*

    CLA: 0xB0

    INS: 0x80

    P1: 0xC2

    P2: 0x00

    LE: 0x18

    *APDU response status msg:*

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 24.

    *Protocols violation errors:*

    A001 — Serial number is not set.

    *APDU response data:* 

    24 bytes digital byte array containing serial number
    
 - **GET_HASH_OF_ENCRYPTED_COMMON_SECRET**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x95

    P1: 0x00

    P2: 0x00

    LE: 0x20

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 32.

    ***APDU response data:*** 

    32 bytes of SHA256(common secret)
    
## APP_WAITE_AUTHORIZATION_MODE state/Applet authorization

After finishing the production applet will be in APP_WAITE_AUTHORIZATION_MODE. After getting the device the end user should complete the procedure of two-factor authorization to make applet working. For this he must know unencrypted activation password.

The following APDU commands will be available here.   

- **VERIFY_PASSWORD**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0x92

    P1: 0x00

    P2: 0x00

    LC: 0x90

    Data: 128 bytes of unencrypted activation password | 16 bytes of IV for AES128 CBC

    ***APDU response status msg:***

    9000 — success, in this case applet state  APP_PERSONALIZED is set up and key for HMAC signature is produced based on common secret and sha256(unencrypted activation password ).

    *Incorrect APDU data errors:*

    6700 (Wrong length) — Length of input APDU Data field  ≠ 144.

    *Unauthorized access errors*

    5f00 — Incorrect password for card authentication.

    5f01 — Incorrect password, card is locked. This error is thrown after 20 successive fails to verify password. Before throwing this error applet state  APP_BLOCKED_MODE is set up.
    
- **GET_HASH_OF_ENCRYPTED_PASSWORD**
- **GET_HASH_OF_ENCRYPTED_COMMON_SECRET**
- **INS_GET_SERIAL_NUMBER**
- **GET_APP_INFO**

***Examplary APDU script to authorize the applet:***

**a)** GET_HASH_OF_ENCRYPTED_PASSWORD: B0 93 00 00 20

**b)** GET_HASH_OF_ENCRYPTED_COMMON_SECRET: B0 95 00 00 20

**c)** GET_SERIAL_NUMBER : B0 C2 00 00 18

**d)** VERIFY_PASSWORD: B0 92 00 00 90 6B4EBE836292B967E3C05F3F73E5255821BD6314683A728FFCE55D3F048A60D561128D097D8066621DEDB8EFB73822868825620B729AA7D9705359E606A4652FB96D556D94FCEE7F86D2F87FE0F92FB2EF30BF7A2E5D6D3A8A771F13D07C1CA05410148751EC8767B9797E675D0BA6F4D285076AD6C3CAD211847D20B439776DEA26E0EBA3D343FC4866E69584E16FC5

**Note:**  Responses of a) — c) should be verified by the host.

## APP_PERSONALIZED state/ Working applet

At this state the main applet functionality will be available:

- ed25519 signature
- Operations with security card keychain
- Recovery service

The following APDU commands will be available here. 

- **GET_SAULT**

    The command outputs random 32-bytes sault produced by card. This sault must be used  by the host to generate HMAC. In the end of its work it calls generateNewSault. So each call of GET_SAULT should produce new random looking sault.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xBD

    P1: 0x00

    P2: 0x00

    LE: 0x20

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE  ≠ 32.

    ***APDU response data:*** 

    32 bytes of random sault generated by card
    
- **VERIFY_PIN**

    This function verifies ascii encoded PIN bytes sent in the data field. After 10 fails of PIN verification internal seed will be blocked. Keys produced from it will not be available for signing transactions. And then RESET WALLET and GENERATE SEED APDU commands of CoinManager must be called. It will regenerate seed and reset PIN.
    The default card PIN is 5555 now. This version of applet was written for NFC card. It uses special mode PIN_MODE_FROM_API for entering PIN. PIN  bytes are  given to applet as plain text. If PIN code = 5555 plain PIN bytes array must look like {0x35, 0x35 0x35, 0x35}.

    *Precondition:*  GET_SAULT should be called before to get new sault from card.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xA2

    P1: 0x00

    P2: 0x00

    LC: 0x44

    Data: 4 bytes of PIN | 32 bytes of sault | 32 bytes of mac

    ***Note:*** mac = HMACSHA256(PIN | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC  ≠ 68.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    6F07 — Incorrect PIN

    6F08 — Incorrect PIN, PIN is expired. This error is thrown after 10 successive fails to verify PIN.  After that internal seed will be blocked. Keys produced from it will not be available for signing transactions.

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

- **GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH**

    This function retrieves ED25519 public key from CoinManager for fixed bip44 HD path
    m/44'/396'/0'/0'/0'.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xA7

    P1: 0x00

    P2: 0x00

    LE: 0x20

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 32.

    *Internal* *CoinManager errors:*

    6F03 — CoinManager.getCoinPubData function can not output public key // we do expect this exception to happen if CoinManager is ok

    ***APDU response data:*** 

    32 bytes of ED25519 public key

- **GET_PUBLIC_KEY**

    This function retrieves ED25519 public key from CoinManager for bip44 HD path
    m/44'/396'/0'/0'/ind'. There is 0 <= ind <= 2^31 - 1. ind must be represented as decimal number and each decimal place should be transformed into Ascii encoding.

    Example: ind = 171 ⇒ {0x31, 0x37, 0x31}

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xA0

    P1: 0x00

    P2: 0x00

    LC: Number of decimal places in ind

    Data: Ascii encoding of ind decimal places

    LE: 0x20

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — Length of input APDU Data field > 10 OR

    *Incorrect APDU data errors:*

    6700 (Wrong length) — .LC > 10,  LE  ≠ 32

    *Internal* *CoinManager errors:*

    6F03 — CoinManager.getCoinPubData function can not output public key

    ***APDU response data:*** 

    32 bytes of ED25519 public key

- **SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH**

    This function signs the message from apdu buffer by ED25519 for default bip44 HD path
    m/44'/396'/0'/0'/0'.

    *Precondition:  1)* GET_SAULT should be called before to get new sault from card. 2) VERIFY_PIN should be called before.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xA5

    P1: 0x00

    P2: 0x00

    LC: APDU data length

    Data: messageLength (2bytes)| message | sault (32 bytes) | mac (32 bytes)

    LE: 0x40

    ***Note:*** mac = HMACSHA256(messageLength | message | sault)

    **Example of Data:** 00 04 01 01 01 01 | sault | mac

    ***APDU response status msg:***

    9000 — success

    *Internal* *CoinManager errors (Protocl violation,  Unauthorized access):*

    6F04 — CoinManager.signCoinDataED25519 function can not output signature, it must be thrown only if VERIFY_PIN is not called before.

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ (66 + messageLength) OR messageLength ≤ 0 OR messageLength > 189 OR LE ≠ 64.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    64 bytes of ED25519 signature

- **SIGN_SHORT_MESSAGE**

    This function signs the message from apdu buffer by ED25519 for default bip44 HD path
    m/44'/396'/0'/0'/ind'. There is 0 <= ind <= 2^31 - 1. ind must be represented as decimal number and each decimal place should be transformed into Ascii encoding.

    Example: ind = 171 ⇒ {0x31, 0x37, 0x31}

    *Precondition:  1)* GET_SAULT should be called before to get new sault from card. 2) VERIFY_PIN should be called before.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xA3

    P1: 0x00

    P2: 0x00

    LC: APDU data length

    Data: messageLength (2bytes)| message | indLength (1 byte, > 0, <= 10) | ind | sault (32 bytes) | mac (32 bytes)

    LE: 0x40

    ***Note:*** mac = HMACSHA256(messageLength | message | indLength | ind | sault)

    **Example of Data:** 00 04 | 01 01 01 01 | 03 | 31 37 31 | sault | mac

    ***APDU response status msg:***

    9000 — success

    *Internal* *CoinManager errors:*

    6F04 — a) CoinManager.signCoinDataED25519 function can not output signature, it must be thrown only if VERIFY_PIN is not called before. b) hdIndex has incorrect format

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ (67 + messageLength + indLength) OR messageLength ≤ 0 OR messageLength > 178 OR indLength ≤ 0 OR indLength > 10 LE ≠ 64.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    64 bytes of ED25519 signature

- **ADD_RECOVERY_DATA_PART**

    This function receives encrypted byte array containing data for recovery service. Now it is multisignature wallet address, surf public key(32 bytes), card common secret (32 bytes) and authentication password (128 bytes) (and this stuff is wrapped in json). 

    Just in case in applet for now we reserved 2048 bytes for string recovery data. It is probably bigger volume than required just now.

    As usually the APDU command can be used to put no more than 256 bytes into applet at once. It is just a limitation of APDU protocol. 256 bytes is a max byte array length that we can send(request) into the card.

    So if recover data will extended then ADD_RECOVERY_DATA_PART should be called multiple times sequentially.   

    Last call of ADD_RECOVERY_DATA_PART must contain SHA256 hash of all recovery data. The card inside will compute hash of received data and it will compare te computed hash and hash received from the host. If they are identical then internal flag isRecoveryDataSet is set to true. Otherwise the card resets all internal buffers, sets  isRecoveryDataSet = false and thrwos exception.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xD1

    P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)

    P2: 0x00

    LC: If (P1 ≠ 0x02) Length of recovery data piece 

    else 0x20

    Data: If (P1 ≠ 0x02) recovery data piece

    else SHA256(recovery data)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 32 for P1=0x02

    OR LC is  so big that the total volume of data that we try to put into internal applet buffer > 1024 bytes (it may happen if we transmit several recovery data piece into applet). So check that the total transmitted volume ≤1024.

    *Integrity corruption* *****errors*

    6F0B — SHA256(recovery data) computed by the card ≠ SHA256(recovery data)  computed by host.

    *Protocols violation errors:*

    6F0C — Recovery data already exists

- **GET_RECOVERY_DATA_LEN**

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xD4

    P1: 0x00 

    P2: 0x00

    LE:  0x02

    ***APDU response data:*** 

    Real length of recovery data  saved in applet's internal buffer

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 2

- **GET_RECOVERY_DATA_PART**

    This function returns encrypted binary blob saved during registration in Recovery service. This APDU command shouldn't be protected with HMAC or PIN.

    If length of recovery data > 256 bytes then this apdu command must be called multiple times.

    Since as usually the APDU command can be used to transmit no more than 256 bytes from applet into host at once. It is just a limitation of APDU protocol. 256 bytes is a max byte array length that we can request from the card.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xD2

    P1: 0x00 

    P2: 0x00

    LC: 0x02

    Data: startPosition of recovery data piece in internal buffer

    LE: length of recovery data piece in internal buffer 

    ***APDU response data:*** 

    Recovery data piece read from internal buffer starting from index startPos and having length LE.

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 2

    6F0A — startPos < 0 || (startPos + le) > 1024

- **GET_RECOVERY_DATA_HASH**

    This function returns SHA256 hash of encrypted binary blob saved during registration in Recovery service. This is neccessary to control the integrity.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xD3

    P1: 0x00 

    P2: 0x00

    LE: 0x20

    ***APDU response data:*** 

    SHA256(recovery data)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 32

- **RESET_RECOVERY_DATA**

    This function reset recovery data, internal buffer is filled by zeros, internal variable realRecoveryDataLen is set to 0, internal flag  isRecoveryDataSet is set to false.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xD5

    P1: 0x00 

    P2: 0x00

    ***APDU response status msg:***

    9000 — success

- **IS_RECOVERY_DATA_SET**

    Returns 0x01 if recovery data is set, 0x00 if not

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xD6

    P1: 0x00 

    P2: 0x00

    LE: 0x01

    ***APDU response data:*** 

    Byte 0x01 if recovery data is set, 0x00 if not

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LE ≠ 1
    
- **RESET_KEYCHAIN**

    Clears all  internal buffers and counters. So after it keychain is clear. In the end it always switches applet state into APP_PERSONALIZED. 

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xBC

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

- **GET_NUMBER_OF_KEYS**

    Outputs the number of keys that are stored by KeyChain at the present moment.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB8

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing the number of keys

- **GET_OCCUPIED_STORAGE_SIZE**

    Outputs the volume of occupied size (in bytes) in KeyChain.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xBA

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing the occupied size in bytes

- **GET_FREE_STORAGE_SIZE**

    Outputs the volume of free size in keyStore.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB9

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing free size in bytes

- **CHECK_KEY_HMAC_CONSISTENCY**

    Gets mac of key and checks that *mac(key bytes in keyStore)* coincides with this mac.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB0

    P1: 0x00

    P2: 0x00

    LC: 0x60

    Data: keyMac (32 bytes) | sault (32 bytes) | mac (32 bytes)

    ***Note:*** mac = HMACSHA256(keyMac | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 96.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    *Not found resources errors:*

    7F00 — incorrect key index (key index not found)

    *Integrity corruption* *****errors*

    8F02 — Key bytes integrity corrupted, the final mac verification failed

- **GET_HMAC**

    Gets the index of key (≥ 0 and  < numberOfStoredKeys) and outputs its hmac. 

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xBB

    P1: 0x00

    P2: 0x00

    LC: 0x42

    Data: index of key (2 bytes) | sault (32 bytes) | mac (32 bytes)

    LE: 0x22

    ***Note:*** mac = HMACSHA256(index | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 66 OR LE ≠ 34.

    8F01 — Incorrect sault

    *Not found resources errors:*

    7F00 — incorrect key index (key index not found)

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    32-bytes hmac | key length (2 bytes)


- **GET_KEY_INDEX_IN_STORAGE_AND_LEN**

    Gets hmac of the key from host. It outputs its real index in keyOffsets array and key length. 

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB1

    P1: 0x00

    P2: 0x00

    LC: 0x60

    Data: hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)

    LE: 0x04

    ***Note:*** mac = HMACSHA256(hmac of key | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 96 OR LE ≠ 4.

    8F01 — Incorrect sault

    *Not found resources errors:*

    7F00 — incorrect key index (key index not found)

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    index (2 bytes) | key length (2 bytes)

- **GET_KEY_CHUNK**

    Gets from host  the real index of key in keyOffsets array and relative start position from which key bytes should be read (at first time startPos = 0). Applet calculates real offset inside keyStore based on its data and startPos and outputs key chunk. Max size of key chunk is 255 bytes. So if key size > 255 bytes GET_KEY_CHUNK will be called multiple times. After getting all data host should verify that hmac of received data is correct and we did not lose any packet.

    *Precondition:  1)* GET_SAULT should be called before to get new sault from card. 2)  call GET_KEY_INDEX_IN_STORAGE_AND_LEN

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB2

    P1: 0x00 

    P2: 0x00

    LC: 0x44

    Data: key  index (2 bytes) | startPos (2 bytes) | sault (32 bytes) | mac (32 bytes)

    LE: Key chunk length

    ***Note:*** mac = HMACSHA256(key  index | startPos | sault)

    ***Note:*** Now we use key chunk length ≤ 128, but it is not obligatory

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 68 

    8F01 — Incorrect sault

    7F01 — Incorrect key chunk start or len

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    *Not found resources errors:*

    7F00 — incorrect key index (key index not found)

- **CHECK_AVAILABLE_VOL_FOR_NEW_KEY**

    Gets from host the size of new key that user wants to add. It checks free space. And if it's enough it saves this value into internal applet variable. Otherwise it will throw an exception. This command always should be called before adding new key.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB3

    P1: 0x00

    P2: 0x00

    LC: 0x42

    Data: length of new key (2 bytes) | sault (32 bytes) | mac (32 bytes)

    ***Note:*** mac = HMACSHA256(length of new key | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 66

    8F01 — Incorrect sault

    *Not found resources errors:*

    7F03 — Not enough space for new key

    7F08 — The maximun number of keys (1023) was added to keychain already.

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

- **ADD_KEY_CHUNK**

    Gets keychunk from the host and adds it into the end of keyStore array. Max size of key chunk is 128 bytes. So if total key size > 128 bytes ADD_KEY_CHUNK will be called multiple times. After all key data is transmitted we call ADD_KEY_CHUNK once again, its input data is Hmac of the key. Applet checks that hmac of received sequence equals to this hmac got from host. So we did not lose any packet and key is not replaced by adversary. And also  ADD_KEY_CHUNK  checks that size of new key equals to size set previously by command CHECK_AVAILABLE_VOL_FOR_NEW_KEY. If verification is ok all ket data is added into keyMacs, keyOffsets and keyLebs buffers, keys counter is incremented  and since this moment the key is registered and can be requested from the card.

    *Precondition:  1)* GET_SAULT should be called before to get new sault from card. 2) call CHECK_AVAILABLE_VOL_FOR_NEW_KEY.

    Then ADD_KEY_CHUNK is called multiple times.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB4

    P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)

    P2: 0x00

    LC: 

    if (P1 = 0x00 OR  0x01): 0x01 +  length of key chunk + 0x40

    if (P1 = 0x02): 0x60

    Data: 

    if (P1 = 0x00 OR  0x01): length of key chunk (1 byte) | key chunk | sault (32 bytes) | mac (32 bytes)

    if (P1 = 0x02): hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)

    LE: if (P1 = 0x02): 0x02

    ***Note:*** 

    if (P1 = 0x00 OR  0x01):  mac = HMACSHA256(length of key chunk | key chunk | sault)

    if (P1 = 0x02):  mac = HMACSHA256(hmac of key | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — if (P1 = 0x00 OR  0x01): LC ≠ (1 + LenOfKeyChunk + 64) OR lenOfKeyChunk <= 0 OR lenOfKeyChunk > 189.

    if (P1 = 0x02): LC ≠ 96 OR LE ≠ 2

    8F01 — Incorrect sault

    7F02 — Incorrect key chunk length: lenOfKeyChunk is so big that the total expected size of new is exceeded or, there is no enough space in KeyChain 

    7F06 — key hmac already exitst in keychain, repeating key was transmitted

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    *Integrity corruption* *****errors*

    7F05 — Length of new key is not equal to the expected key length 

    (This error can happen not only because some data chunk was lost  during transmission, but also because of protocol violation)

    8F02 — Key bytes integrity corrupted, the final mac verification failed

    *Protocols violation errors:*

    7F04 — The size of new key is not set, host forgot to call CHECK_AVAILABLE_VOL_FOR_NEW_KEY.

    *Not found resources errors:*

    7F08 — The maximun number of keys (1023) was added to keychain already.

    ***APDU response data:*** 

    if (P1 = 0x02): fresh number of keys (2 bytes) 

- **INITIATE_DELETE_KEY**

    Gets from host  the real index of key in keyOffsets array  and stores this index into internal applet variable. Outputs length of key to be deleted. In the case of success in the end it changes the state of applet on APP_DELETE_KEY_FROM_KEYCHAIN_MODE. 

    *Precondition:*  1) GET_SAULT should be called before to get new sault from card. 2) call GET_KEY_INDEX_IN_STORAGE_AND_LEN to get key index.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB7

    P1: 0x00 

    P2: 0x00

    LC: 0x42

    Data: key  index (2 bytes) | sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(key  index | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 66 OR LE ≠ 2

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    *Not found resources errors:*

    7F00 — incorrect key index (key index not found)

- **INITIATE_CHANGE_OF_KEY**

    Gets from the host  the real index of key to be changed and stores this index into internal applet variable. 

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB5

    P1: 0x00

    P2: 0x00

    LC: 0x42

    Data: index of key (2 bytes) | sault (32 bytes) | mac (32 bytes)

    ***Note:*** mac = HMACSHA256(index of key | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 66

    8F01 — Incorrect sault

    *Not found resources errors:*

    7F00 — incorrect key index (key index not found)

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

- **CHANGE_KEY_CHUNK**

    Gets keychunk bytes from the host and puts it into keyStore array in place of old key bytes. Max size of key chunk is 128 bytes. So if total key size > 128 bytes CHANGE_KEY_CHUNK will be called multiple times.  We control that lengthes of old key and new key are the same. After all new key data is transmitted we call CHANGE_KEY_CHUNK once again, its input data is Hmac of new key and it is verified by applet. If it is ok then corresponding data about key  is changed in keyOffsets, keyMacs and keyLens buffers.

    *Precondition:  1)* GET_SAULT should be called before to get new sault from card. 2)call  GET_KEY_INDEX_IN_STORAGE_AND_LEN , INIATE_CHANGE_OF_KEY. 

    Then call CHANGE_KEY_CHUNK multiple times.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xB6

    P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)

    P2: 0x00

    LC: 

    if (P1 = 0x00 OR  0x01): 0x01 +  length of key chunk + 0x40

    if (P1 = 0x02): 0x60

    Data: 

    if (P1 = 0x00 OR  0x01): length of key chunk (1 byte) | key chunk | sault (32 bytes) | mac (32 bytes)

    if (P1 = 0x02): hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)

    LE: if (P1 = 0x02): 0x02

    ***Note:*** 

    if (P1 = 0x00 OR  0x01):  mac = HMACSHA256(length of key chunk | key chunk | sault)

    if (P1 = 0x02):  mac = HMACSHA256(hmac of key | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — if (P1 = 0x00 OR  0x01): LC ≠ (1 + LenOfKeyChunk + 64) OR lenOfKeyChunk <= 0 OR lenOfKeyChunk > 189.

    if (P1 = 0x02): LC ≠ 96 OR LE ≠ 2

    8F01 — Incorrect sault

    7F02 — Incorrect key chunk length: lenOfKeyChunk is so big that the total expected size of key to be changed is exceeded

    7F06 — key hmac already exitst in keychain, repeating key was transmitted

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    *Integrity corruption* *****errors*

    7F05 — Length of new key is not equal to the expected key length 

    (This error can happen not only because some data chunk was lost  during transmission, but also because of protocol violation)

    8F02 — Key bytes integrity corrupted, the final mac verification failed

    *Protocols violation errors:*

    7F07 — key index to change was not set

## **APP_DELETE_KEY_FROM_KEYCHAIN_MODE**

Here all commands from APP_PERSONALIZED state are available except of: CHECK_AVAILABLE_VOL_FOR_NEW_KEY,  ADD_KEY_CHUNK,  INITIATE_DELETE_KEY, INITIATE_CHANGE_OF_KEY, CHANGE_KEY_CHUNK .

We want to isolate delete operation as much as possible to control data integrity in keychain.

Aditional commands are available:

- **DELETE_KEY_CHUNK**

    Deletes the portion of key bytes in internal buffer. Max size of portion = 128 bytes. The command should be called (totalOccupied size - offsetOfNextKey) / 128  times + 1 times for tail having length  (totalOccupied size - offsetOfNextKey) % 128. The response contains status byte. If status == 0 then we should continue calling DELETE_LEY_CHUNK. Else if status == 1 then process is finished.

    Such splitting into multiple calls was implemented only because we wanted to use javacard transaction for deleting to control data integrity in keychain. But our device has small internal buffer for transactions and can not handle big transactions.

    *Precondition:*  1) GET_SAULT should be called before to get new sault from card.  2) INITIATE_DELETE_KEY should be called before to set the index of key to be deleted.

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xBE

    P1: 0x00 

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x01

    ***Note:*** mac = HMACSHA256(key  index | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 1

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

- **DELETE_KEY_RECORD**

    Processes the portion of elements in internal buffer storing record about keys. Max size of portion = 12. The command should be called (numberOfStoredKeys - indOfKeyToDelete - 1) / 12  times + 1 times for tail having length  (numberOfStoredKeys - indOfKeyToDelete - 1) % 12. The response contains status byte. If status == 0 then we should continue calling DELETE_LEY_RECORD. Else if status == 1 then process is finished.

    In the end when status is set to 1 and delete operation is finished applet state is changed on APP_PERSONALIZED. And again one may conduct new add, change or delete operation in keychain,

    Such splitting into multiple calls was implemented only because we wanted to use javacard transaction for deleting to control data integrity in keychain. But our device has small internal buffer for transactions and can not handle big transactions.

    *Precondition:*  1) GET_SAULT should be called before to get new sault from card.  2) DELETE_KEY _CHUNK should be called before to clear keyStore array (it should be called until it will return response byte = 1).

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xBF

    P1: 0x00 

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x01

    ***Note:*** mac = HMACSHA256(key  index | sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 1

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    *Protocol violation*

    7F09 — DELETE_KEY_CHUNK did not finish its work

- **GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS**

    Outputs total number of iterations that is necessary to remove key chunk from keychain.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xE1

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing total number of iterations that is necessary to remove key chunk from keychain

- **GET_DELETE_KEY_RECORD_NUM_OF_PACKETS**

    Outputs total number of iterations that is necessary to remove key record from keychain.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xE2

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing total number of iterations that is necessary to remove key record from keychain

- **GET_DELETE_KEY_CHUNK_COUNTER**

    Outputs number of passed iterations that have been already done to remove key chunk from keychain. This may be necessary to finish key deleting after interruption.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xE3

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing  number of passed iterations that have been already done to remove key chunk from keychain

- **GET_DELETE_KEY_RECORD_COUNTER**

    Outputs number of passed iterations that have been already done to remove key record from keychain. This may be necessary to finish key deleting after interruption.

    *Precondition:*  GET_SAULT should be called before to get new sault from card. 

    ***APDU input params:***

    CLA: 0xB0

    INS: 0xE4

    P1: 0x00

    P2: 0x00

    LC: 0x40

    Data: sault (32 bytes) | mac (32 bytes)

    LE: 0x02

    ***Note:*** mac = HMACSHA256(sault)

    ***APDU response status msg:***

    9000 — success

    *Incorrect APDU data errors:*

    6700 (Wrong length) — LC ≠ 64 OR LE ≠ 2.

    8F01 — Incorrect sault

    *Unauthorized access errors*

    8F03 — HMAC verification for APDU input data failed

    8F04 — HMAC verification for APDU input data failed, HMAC verification is expired. This error is thrown after no more than 20 successive fails to verify HMAC. Before throwing this error applet state APP_BLOCKED_MODE is switched on.

    ***APDU response data:*** 

    2 bytes storing  number of passed iterations that have been already done to remove key record from keychain
    
### APP_BLOCKED_MODE

Only two APDU commands will be available here. There is no way to change this state of applet. 

- **INS_GET_APP_INFO**
- **INS_GET_SERIAL_NUMBER**

## Diagram showing applet states transitions

<p align="center">
<img src="images/statesNew.jpg" width="1000">
</p>

## Auxiliary APDU commands of Coin Manager

This set of APDU commands is not a part of TON Wallet applet. So one must make the following SELECT operation before using them

- **SELECT_COIN_MANAGER (probably this is not correct title, but now we use it)**
   
   ***APDU input params:***

   CLA: 0x00

   INS: 0xA4

   P1: 0x04

   P2: 0x00

- **GET_SE_VERSION**
 
   Get SE (secure element) version.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x09
   
   LE: 0x00
   
- **GET_CSN_VERSION**
 
  Get CSN (Secure element ID).
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x01
   
   LE: 0x00   
   
- **GET_PIN_RTL**
 
   Get remaining retry times of PIN.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x02
   
   LE: 0x00
   
- **GET_PIN_TLT**
 
   Get retry maximum times of PIN.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x03
   
   LE: 0x00  
   
- **GET_DEVICE_LABEL**
 
   Get device label.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x04
   
   LE: 0x00

- **GET_ROOT_KEY_STATUS**
 
   Get device label.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x05
   
   LE: 0x00
   
- **GET_APPLET_LIST**
 
  Get application list. It returns list of applets AIDs that were installed onto card.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x06
   
   LE: 0x00  

- **SET_DEVICE_LABEL**
 
  Set the device label.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x26
   
   Data: 0xDF 0xFE 0x23 0x81 0x04 0x20 labelBytes (0x20 -- length of labelBytes)
   
   LE: 0x00  
   
- **GENERATE_SEED**
 
  Generate the seed for ed25519 with RNG.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x0B

   Data: 0xDF 0xFE 0x08 0x82 0x03 0x05 0x04 pinBytes (0x04 -- length of pinBytes, example: 0x35 0x35 0x35 0x35)
   
   LE: 0x00  
   
- **RESET_WALLET**
 
   Reset the wallet state to the initial state. After resetting the wallet, the default PIN value would be 5555. The remaining retry for the PIN will be reset to MAX (default   is 10). The seed for ed25519 will be erased. And after its calling any card operation (except of CoinManager stuff) will fail with 6F02 error. TON Labs wallet applet does not work without seed.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x82 0x05
   
   LE: 0x00
   
- **GET_AVAILABLE_MEMORY**
 
  Get application list.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x05
   
   Data: 0xDF 0xFF 0x02 0x81 0x46
   
   LE: 0x00 

- **CHANGE_PIN**
 
  Change device PIN.
   
   ***APDU input params:***

   CLA: 0x80

   INS: 0xCB

   P1: 0x80

   P2: 0x00
   
   LC: 0x0B

   Data: 0xDF 0xFE 0x0D 0x82 0x04 0x0A 0x04 oldPinBytes 0x04 newPinBytes (0x04 -- length of oldPinBytes and newPinBytes, example of newPinBytes: 0x36 0x36 0x36 0x36)
   
   LE: 0x00  


   

