-- | Interact with the wallet over CIP-30 interface
-- description: <https://cips.cardano.org/cips/cip30/>
--
-- Code works by inspection of cardano object which should be
-- injected by the wallet to the window.
module Cardano.Wallet
  ( Api
  , Bytes
  , Cbor
  , Cip30DataSignature
  , Paginate
  , WalletName(..)
  , enable
  , isEnabled
  , isWalletAvailable
  , getBalance
  , getChangeAddress
  , getCollateral
  , getNetworkId
  , getRewardAddresses
  , getUnusedAddresses
  , getUsedAddresses
  , getUtxos
  , signTx
  , signData
  , submitTx
  , availableWallets
  , gero
  , nami
  , flint
  , eternl
  ) where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe, fromMaybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.Array (filterA)

type Bytes = String
type Cbor = String
type NetworkId = Int

type Paginate =
  { limit :: Int
  , page :: Int
  }

foreign import data Api :: Type

type Cip30DataSignature =
  { key :: Cbor
  , signature :: Cbor
  }

-- | Wrapper for wallet names. see nami, flint, etc for examples.
newtype WalletName = WalletName String

-- | Enables wallet and reads Cip30 wallet API if wallet is available
enable :: WalletName -> Aff Api
enable (WalletName name) = toAffE (_getWalletApi name)

getBalance :: Api -> Aff Cbor
getBalance api = toAffE (_getBalance api)

getChangeAddress :: Api -> Aff Cbor
getChangeAddress api = toAffE (_getChangeAddress api)

getCollateral :: Api -> Maybe Cbor -> Aff (Maybe Cbor)
getCollateral api mParams =
  Nullable.toMaybe <$> toAffE (_getCollateral api (Nullable.toNullable mParams))

getNetworkId :: Api -> Aff NetworkId
getNetworkId api = toAffE (_getNetworkId api)

getRewardAddresses :: Api -> Aff (Array Cbor)
getRewardAddresses api = toAffE (_getRewardAddresses api)

getUnusedAddresses :: Api -> Aff (Array Cbor)
getUnusedAddresses api = toAffE (_getUnusedAddresses api)

getUsedAddresses :: Api -> Paginate -> Aff (Array Cbor)
getUsedAddresses api paginate = toAffE (_getUsedAddresses api paginate)

getUtxos :: Api -> Maybe Paginate -> Aff (Array Cbor)
getUtxos api mPaginate =
  fromMaybe [] <<< Nullable.toMaybe
    <$> toAffE (_getUtxos api (Nullable.toNullable mPaginate))

signTx :: Api -> Cbor -> Boolean -> Aff Cbor
signTx api tx isPartialSign = toAffE (_signTx api tx isPartialSign)

signData :: Api -> Cbor -> Bytes -> Aff Cip30DataSignature
signData api addr payload = toAffE (_signData api addr payload)

submitTx :: Api -> Cbor -> Aff String
submitTx api tx = toAffE (_submitTx api tx)

-- | Checks weather wallet is enabled.
-- Enabled means that user has given permission to our code to interact
-- with wallet over Cip30
isEnabled :: WalletName -> Aff Boolean
isEnabled = toAffE <<< _isEnabled

------------------------------------------------------------------------------------
-- common wallet names

-- | Reads all wallets that are available in the browser.
-- It uses @allWallets@ under the hood and checks whether
-- field that corresponds to wallet name available on cardano object
availableWallets :: Effect (Array WalletName)
availableWallets = filterA isWalletAvailable allWallets

-- | Get all available wallets.
-- If you are missing your wallet it's easy to extend it
-- by wrapping name tag to @WalletName@ newtype
allWallets :: Array WalletName
allWallets = [ nami, eternl, flint, gero ]

-- | Eternl wallet name
eternl :: WalletName
eternl = WalletName "eternl"

-- | Nami wallet name
nami :: WalletName
nami = WalletName "nami"

-- | Flint wallet name
flint :: WalletName
flint = WalletName "flint"

-- | Gero wallet name
gero :: WalletName
gero = WalletName "gero"

------------------------------------------------------------------------------------
-- FFI

foreign import _getBalance :: Api -> Effect (Promise Cbor)
foreign import _getChangeAddress :: Api -> Effect (Promise Cbor)
foreign import _getCollateral :: Api -> Nullable Cbor -> Effect (Promise (Nullable Cbor))
foreign import _getNetworkId :: Api -> Effect (Promise NetworkId)
foreign import _getRewardAddresses :: Api -> Effect (Promise (Array Cbor))
foreign import _getUnusedAddresses :: Api -> Effect (Promise (Array Cbor))
foreign import _getUsedAddresses :: Api -> Paginate -> Effect (Promise (Array Cbor))
foreign import _getUtxos :: Api -> Nullable Paginate -> Effect (Promise (Nullable (Array Cbor)))
foreign import _signTx :: Api -> Cbor -> Boolean -> Effect (Promise Cbor)
foreign import _signData :: Api -> Cbor -> Bytes -> Effect (Promise Cip30DataSignature)
foreign import _isEnabled :: WalletName -> Effect (Promise Boolean)
foreign import _submitTx :: Api -> Cbor -> Effect (Promise String)
foreign import _getWalletApi :: String -> Effect (Promise Api)
foreign import isWalletAvailable :: WalletName -> Effect Boolean

