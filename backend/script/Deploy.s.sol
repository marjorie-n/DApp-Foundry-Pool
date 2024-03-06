// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "forge-std/Script.sol";
import {Pool} from "../src/Pool.sol";

contract MyScript is Script {
    function run() external {
        // Récupère la clé privée du deployeur.
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey); // Commence à diffuser les transactions avec une clé privée.
        uint256 end = 4 weeks;
        uint256 goal = 10 ether;

        // Deployer la pool.
        Pool pool = new Pool(end, goal);

        // Arreter la diffusion.
        vm.stopBroadcast();
    }
}
