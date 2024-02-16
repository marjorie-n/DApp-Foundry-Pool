// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import {Pool} from "../src/Pool.sol";

contract PoolTest is Test {
    address owner = makeAddr("User0");
    address addr1 = makeAddr("User1");
    address addr2 = makeAddr("User2");
    address addr3 = makeAddr("User3");

    uint256 duration = 4 weeks; //timestamp 4*7*24*3600
    uint256 goal = 10 ether;
    Pool pool;

    function setUp() public {
        vm.prank(owner); // permet d'être executer par le owner
        pool = new Pool(duration, goal);
    }

    function test_ContractDeployedWithSucess() public {
        address _owner = pool.owner();
        assertEq(_owner, owner);
        uint256 _end = pool.end();
        assertEq(block.timestamp + duration, _end);
        uint256 _goal = pool.goal();
        assertEq(goal, _goal);
    }

    //Contribute
    function test_RevertWhen_EndIsReached() public {
        vm.warp(pool.end() + 3600);
        bytes4 selector = bytes4(keccak256("CollectIsFinished()")); // avoir accès à la signature de la custum error.
        vm.expectRevert(abi.encodeWithSelector(selector)); // je m'attend a avoir une erreur

        vm.prank(addr1); // vérifier l'adresse de l'user
        vm.deal(addr1, 1 ether);
        pool.contribute{value: 1 ether}(); // j'envoie de l'argent au user
    }

    function test_RevertNotFunds() public {
        bytes4 selector = bytes4(keccak256("NotEnoughFunds()"));
        vm.expectRevert(abi.encodeWithSelector(selector));

        vm.prank(addr1);
        pool.contribute{value: 0}();
    }

    // Fusing the test
    function test_ExpectEmit_SuccessfullContribute(uint96 _amount) public {
        vm.assume(_amount > 0); // j'assume que l'amount est supérieur à 0
        vm.expectEmit(true, false, false, true); // teste les topics de event Contribute
        emit Pool.Contribute(address(addr1), _amount);

        vm.prank(addr1);
        vm.deal(addr1, _amount);
        pool.contribute{value: _amount}();
    }

    //Withdraw
    function test_RevertWhenNotIsOwner() public {
        bytes4 selector = bytes4(
            keccak256("OwnableUnauthorizedAccount(address)")
        );
        vm.expectRevert(abi.encodeWithSelector(selector, addr1));
        vm.prank(addr1);
        pool.withdraw();
    }

    // Test Retirer les fonds avant la fin de la cagnotte
    function test_RevertWhenEndIsNotReached() public {
        bytes4 selector = bytes4(keccak256("CollectNotFinished()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        vm.prank(owner);
        pool.withdraw();
    }

    // Test quand la cagnotte n'est pas terminée
    function test_RevertWhenGoalIsNotReached() public {
        vm.prank(addr1);
        vm.deal(addr1, 5 ether);
        pool.contribute{value: 5 ether};
        vm.warp(pool.end() + 3600);

        bytes4 selector = bytes4(keccak256("CollectNotFinished()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        vm.prank(owner);
        pool.withdraw();
    }

    // test le moment où l'envoi à l'owner ne fonctionne pas
    function test_RevertWhenWithdrawFailedToSendEther() public {
        // contrat de test devient le propriétaire du contrat pool
        pool = new Pool(duration, goal);
        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();
        vm.prank(addr2);
        vm.deal(addr2, 5 ether);
        pool.contribute{value: 5 ether}();

        vm.warp(pool.end() + 3600);
        bytes4 selector = bytes4(keccak256("FailedToSendEther()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        pool.withdraw();
    }

    // Test withdraw qui fonctionne
    function test_withdraw() public {
        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();
        vm.prank(addr2);
        vm.deal(addr2, 5 ether);
        pool.contribute{value: 5 ether}();

        vm.warp(pool.end() + 3600);
        vm.prank(owner);
        pool.withdraw();
    }

    // Test refund
    function test_RevertWhenCollectedNotFinidshed() public {
        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();
        vm.prank(addr2);
        vm.deal(addr2, 5 ether);
        pool.contribute{value: 5 ether}();

        bytes4 selector = bytes4(keccak256("CollectNotFinished()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        vm.prank(addr1);
        pool.refund();
    }

    function test_RevertWhenGoalAlreadyReached() public {
        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();
        vm.prank(addr2);
        vm.deal(addr2, 5 ether);
        pool.contribute{value: 5 ether}();

        vm.warp(pool.end() + 3600);
        bytes4 selector = bytes4(keccak256("GoalAlreadyReached()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        vm.prank(addr1);
        pool.refund();
    }

    function test_RevertWhenNoContribution() public {
        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();
        vm.prank(addr2);
        vm.deal(addr2, 1 ether);
        pool.contribute{value: 1 ether}();

        vm.warp(pool.end() + 3600);
        bytes4 selector = bytes4(keccak256("NoContribution()"));
        vm.expectRevert(abi.encodeWithSelector(selector));

        vm.prank(addr3);
        pool.refund();
    }

    //test si on a pratcipé avec un contrat sans receive et fallback
    function test_RevertWhenRfundFailedToSendEther() public {
        vm.deal(address(this), 2 ether);
        pool.contribute{value: 2 ether}();

        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();

        vm.warp(pool.end() + 3600);
        bytes4 selector = bytes4(keccak256("FailedToSendEther()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        pool.refund();
    }

    // test si le refund fonctionne
    function test_refund() public {
        vm.prank(addr1);
        vm.deal(addr1, 6 ether);
        pool.contribute{value: 6 ether}();
        vm.prank(addr2);
        vm.deal(addr2, 1 ether);
        pool.contribute{value: 1 ether}();

        vm.warp(pool.end() + 3600);
        uint256 balanceBeforeRefund = addr2.balance;
        vm.prank(addr2);
        pool.refund();

        uint256 balanceAfterRefund = addr2.balance;

        assertEq(balanceBeforeRefund + 1 ether, balanceAfterRefund);
    }
}
