In the case of any error functions of TonNfcClientSwift library throws an exception. The exception usually contains inside a error message wrapped into json of special format. You can get this json into your callback. There is a full list of json error messages that the library can potentially throw into the caller.

## CARD_ERRORS

Here there are errors produced by NFC card (TON Labs wallet applet itself). So Swift code just catches it and puts error message into callback. Below there are exemplary jsons. Their fields have the following meanings:

+ *code* — error status word (SW) produced by the card (applet)

+ *cardInstruction* — title of APDU command that failed

+ *errorTypeId* — id of error type ( it will always be zero here)

+ *errorType* — description of error type 

+ *message* — contains error message corresponding to code thrown by the card.

+ *apdu* — full text of failed APDU command in hex format

In below list field "cardInstruction" always equals to  GET_APP_INFO (just as example). But really in this field you may meet any other card instruction (APDU).

```json
{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6C00",
"message": "Correct Expected Length (Le).",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6100",
"message": "Response bytes remaining.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6E00",
"message": "CLA value not supported.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6D00",
"message": "INS value not supported.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F00",
"message": "Command aborted, No precise diagnosis.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F00",
"message": "Incorrect key index.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6A80",
"message": "Wrong data.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6700",
"message": "Wrong length.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "4F00",
"message": "Internal buffer is null or too small.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "5F00",
"message": "Incorrect password for card authentication.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6A81",
"message": "Function not supported.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6881",
"message": "Card does not support the operation on the speciﬁed logical channel.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "4F01",
"message": "Personalization is not finished.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "5F01",
"message": "Incorrect password, card is locked.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F01",
"message": "Set coin type failed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F01",
"message": "Incorrect key chunk start or length.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6A82",
"message": "File not found.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6882",
"message": "Card does not support secure messaging.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6982",
"message": "Security condition not satisﬁed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "4F02",
"message": "Internal error: incorrect offset.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F02",
"message": "Set curve failed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F02",
"message": "Incorrect key chunk length.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6983",
"message": "File invalid.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6883",
"message": "Record not found.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "4F03",
"message": "Internal error: incorrect payload value.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F03",
"message": "Get coin pub data failed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F03",
"message": "Not enough space.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6884",
"message": "Command chaining not supported.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6984",
"message": "Data invalid.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6A84",
"message": "Not enough memory space in the ﬁle.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F04",
"message": "Sign data failed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F04",
"message": "Key size unknown.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6985",
"message": "Conditions of use not satisﬁed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F05",
"message": "Key length incorrect.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6986",
"message": "Command not allowed (no current EF).",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6A86",
"message": "Incorrect parameters (P1,P2).",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F06",
"message": "Hmac exists already.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F07",
"message": "Incorrect PIN (from Ton wallet applet).",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F07",
"message": "Incorrect key index to change.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F08",
"message": "PIN tries expired.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F08",
"message": "Max number of keys (1023) is exceeded.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "7F09",
"message": "Delete key chunk is not finished.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F09",
"message": "Too big length of recovery data",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F0A",
"message": "Incorrect start or length of recovery data piece in internal buffer",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F0B",
"message": "Hash of recovery data is incorrect",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F0C",
"message": "Recovery data already exists",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F0D",
"message": "Recovery data does not exist",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6999",
"message": "Applet select failed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "8F04",
"message": "Apdu Hmac verification tries expired.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}
{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "9B03",
"message": "Load seed error.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "8F03",
"message": "Incorrect apdu hmac.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6F0D",
"message": "Recovery data does not exist",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "6999",
"message": "Applet select failed.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "8F04",
"message": "Apdu Hmac verification tries expired.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "9B03",
"message": "Load seed error.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}
{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "8F03",
"message": "Incorrect apdu hmac.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}

{
"errorType": "Applet fail: card operation error",
"errorTypeId": "0",
"code": "A001",
"message": "Serial number does not exist. You must set it.",
"cardInstruction": "GET_APP_INFO",
"apdu": "B0 C1 00 00 ",
"status": "fail"
}
```

## SWIFT_INTERNAL_ERRORS

Here there are some internal errors that may happen inside Swift code. It means that something wrong happened in library and there is a bug in a library. Please report to the team if you would meet it. Normally they must not be met.

```
//List will be added later
```
## NFC_INTERRUPTION_ERRORS

```json
{
  "code": "20000",
  "errorType": "Native code fail: NFC connection interruption",
  "errorTypeId": "2",
  "message": "Nfc connection was interrupted by user.",
  "status": "fail"
}
```

## IOS_NFC_ERRORS

Here there is a list of any troubles with NFC hardware and connection.

```
{ 
"errorType": "iOS code fail: NFC error", 
"errorTypeId": "21", 
"code": "210000", 
"message": "NFC session is not established (session is empty).", 
"status": "fail" 
}

{ 
"errorType": "iOS code fail: NFC error", 
"errorTypeId": "21", 
"code": "210001", 
"message": "NFC Tag is not detected.", 
"status": "fail" }

{ 
"errorType": "iOS code fail: NFC error", 
"errorTypeId": "21", 
"code": "210002", 
"message": "Can not establish connection with NFC Tag, more details:", 
"status": "fail" 
}
```
## INPUT_DATA_FORMAT_ERRORS

Any trouble with input data passing into TonNfcClientSwift API functions. For example, encryptedPassword argument for turnOnWallet function must be a hex string of length 256 (and inside it is transformed into byte array of length 128). If you would send string of another length you will get error.

```
{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30000", 
"message": "Activation password is a hex string of length 256.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30001", 
"message": "Common secret is a hex string of length 64.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30002", 
"message": "Initial vector is a hex string of length 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30003", 
"message": "Activation password is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30004", 
"message": "Common secret is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30005", 
"message": "Initial vector is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30006", 
"message": "Pin must be a numeric string of length 4.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30007", 
"message": "Pin is not a valid numeric string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30008", 
"message": "Data for signing is not a valid hex .", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30009", 
"message": "Data for signing must be a nonempty hex string of even length > 0 and <= 378.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30010", 
"message": "Data for signing must be a nonempty hex string of even length > 0 and <= 356.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30011", 
"message": "Recovery data is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30012", 
"message": "Recovery data is a hex string of length > 0 and <= 4096.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30013", 
"message": "Hd index must be a numeric string of length > 0 and <= 10.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30014", 
"message": "Hd index is not a valid numeric string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30015", 
"message": "Device label must be a hex string of length 64.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30016", 
"message": "Device label is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30017", 
"message": "Key hmac is a hex string of length 64.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30018", 
"message": "Key hmac is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30019", 
"message": "Key is not a valid hex string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30020", 
"message": "Key is a hex string of length > 0 and <= 16384.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30021", 
"message": "Key size must be > 0 and <= 8192.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30022", 
"message": "Length of new key must be equal to length of old key ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30023", 
"message": "Key index is a numeric string representing integer >= 0 and <= 1022.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30024", 
"message": "Key index is not a valid numeric string.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30025", 
"message": "Serial number is a numeric string of length 24.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect format of input data", 
"errorTypeId": "3", 
"code": "30026", 
"message": "Serial number is not a valid numeric string.", 
"status": "fail" 
}
```

## CARD_RESPONSE_DATA_ERRORS

This sublist of errors is about additional checking of data that comes into TonNfcClientSwift library from the card. We check all responses from card: i.e. their formats, lengthes, ranges in some cases. Normally errors of such type must not happen. Please report if you would get one of them.

```
{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40000", 
"message": "Sault response from card must have length 32. Current length is ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40001", 
"message": "Applet state response from card must have length 1. Current length is ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40002", 
"message": "Unknown applet state = ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card",
"errorTypeId": "4", 
"code": "40003", 
"message": "Recovery data hash must have length 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40004", 
"message": "Recovery data length byte array must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40005", 
"message": "Recovery data length must be > 0 and <= 2048.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40006", 
"message": "Response from IS_RECOVERY_DATA_SET card operation must have length 1.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40007", 
"message": "Recovery data portion must have length = ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40008", 
"message": "Hash of encrypted password must have length 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40009", 
"message": "Hash of encrypted common secret must have length 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40010", 
"message": "Card two-factor authentication failed: Hash of encrypted common secret is invalid.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40011", 
"message": "Card two-factor authentication failed: Hash of encrypted password is invalid.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40012", 
"message": "Signature must have length 64.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40013", 
"message": "Public key must have length 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40014", 
"message": "Response from GET_NUMBER_OF_KEYS card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40015", 
"message": "Number of keys in keychain must be >= 0 and <= 1023", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40016", 
"message": "Response from GET_OCCUPIED_SIZE card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40017", 
"message": "Response from GET_FREE_SIZE_RESPONSE card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40018", 
"message": "Occupied size in keychain can not be negative", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40019", 
"message": "Free size in keychain can not be negative", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40020", 
"message": "Response from GET_KEY_INDEX_IN_STORAGE_AND_LEN card operation must have length 4.", 
"status": 
"fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40021", 
"message": "Key index must be >= 0 and <= 1022.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40022", 
"message": "Key length (in keychain) must be > 0 and <= 8192.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40023", 
"message": "Response from DELETE_KEY_CHUNK card operation must have length 1.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40024", 
"message": "Response from DELETE_KEY_CHUNK card operation must have value 0 or 1.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40025", 
"message": "Response from DELETE_KEY_RECORD card operation must have length 1.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40026", 
"message": "Response from DELETE_KEY_RECORD card operation must have value 0 or 1.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40027", 
"message": "Response from GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40028", 
"message": "Response from GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS card operation can not be negative.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40029", 
"message": "Response from GET_DELETE_KEY_RECORD card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40030", 
"message": "Response from GET_DELETE_KEY_RECORD_NUM_OF_PACKETS card operation can not be negative.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40031", 
"message": "After ADD_KEY card operation number of keys must be increased by 1.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40032", 
"message": "After ADD_KEY card operation number of keys must not be changed.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40033", 
"message": "Response from SEND_CHUNK card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40034", 
"message": "Hash of key (from keychain) must have length 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40035", 
"message": "Response from INITIATE_DELETE_KEY card operation must have length 2.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40036", 
"message": "Key data portion must have length = ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40037", 
"message": "Serial number must have length 24.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40038", 
"message": "Response from GET_PIN_TLT (GET_PIN_RTL) must have length > 0.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40039", 
"message": "Response from GET_PIN_TLT (GET_PIN_RTL) must have value >= 0 and <= 10.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40040", 
"message": "Response from GET_ROOT_KEY_STATUS must have length > 0.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40041", 
"message": "Response from GET_DEVICE_LABEL must have length = 32.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40042", 
"message": "Response from GET_CSN_VERSION must have length > 0.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40043", 
"message": "Response from GET_SE_VERSION must have length > 0.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40044", 
"message": "Response from GET_AVAILABLE_MEMORY must have length > 0.", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: incorrect response from card", 
"errorTypeId": "4", 
"code": "40045", 
"message": "Response from GET_APPLET_LIST must have length > 0.", 
"status": "fail" 
}
```

## IMPROPER_APPLET_STATE_ERROR

Before sending some APDU command into applet Swift code usually checks applet state. If in current applet state this APDU is not supported, then Swift code throws a error and does not even try to send this APDU into applet (But If it would send it then card will produce _6D00_ error).

```
{ 
"errorType": "Native code fail: improper applet state", 
"errorTypeId": "5", 
"code": "50000", 
"message": "APDU command is not supported", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: improper applet state", 
"errorTypeId": "5", 
"code": "50001", 
"message": "Applet must be in mode that waits authentication. Now it is: ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: improper applet state", 
"errorTypeId": "5", 
"code": "50002", 
"message": "Applet must be in personalized mode. Now it is: ", 
"status": "fail" 
}

{ 
"errorType": "Native code fail: improper applet state", 
"errorTypeId": "5", 
"code": "50003", 
"message": "Applet must be in mode for deleting key. Now it is ", 
"status": "fail" 
}
```
## HMAC_KEY_ERROR

Here there is a list of possible errors that can happen during work with hmac keys living in iOS keychain.

```
{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60000", 
"message": "Key for hmac signing for specified serial number does not exist.", 
"status": "fail" 
}

{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60001", 
"message": "Current serial number is not set. Can not select key for hmac.", 
"status": "fail" 
}

{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60002", 
"message": "Unable to retrieve any key from keychain.", 
"status": "fail" 
}

{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60003", 
"message": "Unable to retrieve info about key from keychain.", 
"status": "fail" 
}

{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60004", 
"message": "Unable to save key into keychain.", 
"status": "fail" 
}

{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60005", 
"message": "Unable to delete key from keychain.", 
"status": "fail" 
}

{ 
"errorType": "Native code (iOS) fail: hmac key issue", 
"errorTypeId": "6", 
"code": "60006", 
"message": "Unable to update key in keychain.", 
"status": "fail" 
}
```
## WRONG_CARD_ERROR

```json
{
"errorType": "Native code fail: wrong card",
"errorTypeId": "7",
"code": "70000",
"message": "You try to use security card with incorrect serial number.",
"status": "fail"
}
```
