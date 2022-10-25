"use strict";

export const _getWalletApi = walletName => () => 
  window.cardano[walletName].enable();

export const _isEnabled = walletName => () => 
  window.cardano[walletName].isEnabled();

export const _getApiVersion = walletName => () => 
  window.cardano[walletName].apiVersion;

export const _getName = walletName => () => 
  window.cardano[walletName].name;

export const _getIcon = walletName => () => 
  window.cardano[walletName].icon;

export const _getBalance = api => () => api.getBalance();
export const _getChangeAddress = api => () => api.getChangeAddress();
export const _getCollateral = api => params => () => api.getCollateral(params);
export const _getNetworkId = api => () => api.getNetworkId();
export const _getRewardAddresses = api => () => api.getRewardAddresses();
export const _getUnusedAddresses = api => () => api.getUnusedAddresses();
export const _getUsedAddresses = api => page => () => api.getUsedAddresses(page);
export const _signTx = api => tx => partial => () => api.signTx(tx, partial);
export const _signData = api => addr => payload => () => api.signData(addr, payload);
export const _getUtxos = api => paginate => () => api.getUtxos(paginate != null ? paginate : undefined);
export const _submitTx = api => tx => () => api.submitTx(tx.to_hex());

export const isWalletAvailable = walletName => () =>
   typeof window.cardano != "undefined" &&
   typeof window.cardano[walletName] != "undefined" &&
   typeof window.cardano[walletName].apiVersion != "undefined" &&
   typeof window.cardano[walletName].enable == "function";

export const allWalletTags = () =>
    typeof window.cardano != "undefined" ?
        Object.keys(window.cardano).filter(tag => typeof window.cardano[tag] == "object") : []
