// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IBtcMirror.sol"; // Assuming IBtcMirror is the interface for the Bitcoin mirror contract

contract BBTCToken is ERC20, Ownable {
    // Event emitted when BBTC tokens are minted
    event Minted(address indexed to, uint256 amount);

    IBtcMirror public btcMirror; // Reference to the Bitcoin mirror contract

    constructor(address _btcMirror) ERC20("Burned Bitcoin", "BBTC") Ownable(msg.sender) {
        btcMirror = IBtcMirror(_btcMirror);
    }

    /**
     * @notice Confirms a Bitcoin burning transaction and mints BBTC tokens.
     * @param blockHeight The height of the Bitcoin block that confirms the burn.
     * @param blockHeaders The block headers that prove the burn.
     * @param to The address to mint BBTC tokens to.
     * @param amount The amount of BBTC tokens to mint.
     */
    function confirmBurnAndMint(
        uint256 blockHeight,
        bytes calldata blockHeaders,
        address to,
        uint256 amount
    ) external onlyOwner {
        // Submit the block headers to the Bitcoin mirror contract
        btcMirror.submit(blockHeight, blockHeaders);

        // Mint BBTC tokens to the specified address
        _mint(to, amount);
        emit Minted(to, amount);
    }

    /**
     * @notice Burns BBTC tokens from the caller's account.
     * @param amount The amount of BBTC tokens to burn.
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}