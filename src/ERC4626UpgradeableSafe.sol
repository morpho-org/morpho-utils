// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {
    ERC4626Upgradeable,
    ERC20Upgradeable,
    IERC20MetadataUpgradeable
} from "openzeppelin-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";

/// @title ERC4626UpgradeableSafe.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice ERC4626 Tokenized Vault abstract upgradeable implementation tweaking OZ's implementation to make it safer at initialization.
abstract contract ERC4626UpgradeableSafe is ERC4626Upgradeable {
    /* CONSTRUCTOR */

    /// @dev The contract automatically disables initializers when deployed so that nobody can highjack the implementation contract.
    constructor() {
        _disableInitializers();
    }

    /* INITIALIZER */

    function __ERC4626UpgradeableSafe_init(IERC20MetadataUpgradeable asset, uint256 initialDeposit)
        internal
        onlyInitializing
    {
        __ERC4626_init_unchained(asset);
        __ERC4626UpgradeableSafe_init_unchained(initialDeposit);
    }

    function __ERC4626UpgradeableSafe_init_unchained(uint256 initialDeposit) internal onlyInitializing {
        // Sacrifice an initial seed of shares to ensure a healthy amount of precision in minting shares.
        // Set to 0 at your own risk.
        // Caller must have approved the asset to this contract's address.
        // See: https://github.com/Rari-Capital/solmate/issues/178
        if (initialDeposit > 0) deposit(initialDeposit, address(this));
    }

    /// @dev This empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    uint256[50] private __gap;
}
