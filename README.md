Purescript interface to Cardano Wallets over Cip30
=========================================================

Implements FFI for purescript to the Cardano XCip-30 wallet interface.
See the [js](https://cips.cardano.org/cips/cip30/#apigetcollateralparamsamountcborcoinpromisetransactionunspentoutputnull) or [typescript](https://input-output-hk.github.io/cardano-js-sdk/modules/_cardano_sdk_cip30.html#SignTx) docs to match the functions:
With this library we can interact with cardano in browser wallets 
like Nami or Eternl if they support Cip30.

By Cip30 standard the `cardano` object is injected to the window.
Note that it takes some time to inject the object so it might be beneficial
to add 1 sec delay before your first function invokation to interact with the wallet.
Otherwise no cardano object will be available and code will end up with error.

