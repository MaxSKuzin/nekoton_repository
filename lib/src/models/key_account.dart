import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:nekoton_repository/nekoton_repository.dart';

/// Wrapper class around nekoton's account with additional logic.
@immutable
class KeyAccount extends Equatable {
  const KeyAccount({
    required this.account,
    required this.isExternal,
    required this.isHidden,
    required this.publicKey,
  });

  /// Nekoton's account
  final AssetsList account;

  /// Key for which this account specified.
  /// For external accounts this value can be different from account.publicKey
  /// but for internal usages this key is same as for key this account stores in
  final PublicKey publicKey;

  /// Flag that allows identify if this account is external.
  final bool isExternal;

  /// Flag that allows identify if this account is hidden.
  final bool isHidden;

  /// Proxy getter of name of account
  String get name => account.name;

  /// Proxy getter of address of account
  Address get address => account.address;

  /// Proxy getter of workchain of account
  int get workchain => account.workchain;

  /// Proxy getter of additional assets of account
  Map<String, AdditionalAssets> get additionalAssets =>
      account.additionalAssets;

  /// Show this account in wallet page.
  Future<void> show() => GetIt.instance<NekotonRepository>()
      .storageRepository
      .showAccounts([account.address]);

  /// Hide this account from wallet page.
  /// In profile page is still will be visible.
  Future<void> hide() => GetIt.instance<NekotonRepository>()
      .storageRepository
      .hideAccounts([account.address]);

  /// Add token to this account
  Future<void> addTokenWallet(Address rootTokenContract) =>
      GetIt.instance<AccountRepository>().addTokenWallet(
        address: account.address,
        rootTokenContract: rootTokenContract,
      );

  /// Remove token from this account
  Future<void> removeTokenWallet(Address rootTokenContract) =>
      GetIt.instance<AccountRepository>().removeTokenWallet(
        address: account.address,
        rootTokenContract: rootTokenContract,
      );

  /// Change name of this account to [newName].
  Future<void> rename(String newName) => GetIt.instance<AccountRepository>()
      .renameAccount(account.address, newName);

  /// Remove this account from storage.
  /// This works fine for local and external accounts.
  Future<void> remove() =>
      GetIt.instance<AccountRepository>().removeAccounts([this]);

  @override
  List<Object?> get props => [account, isExternal, isHidden];
}
