Purescript interface to Cardano Wallets over Cip30
=========================================================

Implements FFI for purescript to the Cardano Cip-30 wallet interface.
See the [js](https://cips.cardano.org/cips/cip30/#apigetcollateralparamsamountcborcoinpromisetransactionunspentoutputnull) or [typescript](https://input-output-hk.github.io/cardano-js-sdk/modules/_cardano_sdk_cip30.html#SignTx) docs to match the functions:
With this library we can interact with cardano in browser wallets 
like Nami or Eternl if they support Cip30.

By Cip30 standard the `cardano` object is injected to the window.
Note that it takes some time to inject the object so it might be beneficial
to add 1 sec delay before your first function invocation to interact with the wallet.
Otherwise no cardano object will be available and code will end up with error.

Most likely that you will use this library in pair with CSL (cardano-serialisation-lib). Also you can checkout 
the [purescript-cardano-serialization-lib](https://github.com/anton-k/purescript-cardano-serialization-lib) which offers bindings to CSL in purescript.
Note that `Cbor`-strings of this library are `Hex`-encoded strings in terms of CSL.
So for example if function `signTx` takes `tx` argument as `Cbor`
we can get that from `CSL` tx by converting it to `Hex`-encoded string
with `to_hex` method. Also to get meaningful data from return type of Cip30
function we can use CSL's `from_hex` method.

This library is low-level implementation so the export types are kept
aligned with original implementation in Cip30. Use CSL converters like `to_hex`/`from_hex`
or `to_bytes`/`from_bytes` to match the types.

The only improvement on type level which was taken is to turn JS style promises
to the more convenient for Purescript `Aff`-type.


