// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

/// @title Pool
/// @author Marjorie

import "@openzeppelin/contracts/access/Ownable.sol";
//Définir les différentes erreurs (meillleure optimisation des frais de gaz)
error CollectIsFinished();
error GoalAlreadyReached();
error CollectNotFinished();
error FailedToSendEther();
error NoContribution();
error NotEnoughFunds();

contract Pool is Ownable {
    uint256 public end; //définir fin de la cagnotte
    uint256 public goal; //définir but de la cagnotte
    uint256 public totalCollected; //somme collectée

    mapping(address => uint256) public contributions; //somme collectée par contributeur
    event Contribute(address indexed contributor, uint256 amount); //evenement de contribution -indexed signifie que l'adresse facilement reconnue parmi les contributeurs.

    //le constructor est appélé uniquement lorsque l'on déploie le contrat la 1ère fois.
    //la personne qui déploie le contrat est le propriétaire.
    constructor(uint256 _duration, uint256 _goal) Ownable(msg.sender) {
        end = block.timestamp + _duration; //la date de fin est le timestamp actuel + la duree de la cagnotte
        goal = _goal; //la cagnotte est devenue _goal
    }

    // fonction de contribution qui permet à un contributeur de contribuer d'un montant.
    // external signifie que la fonction est accessible depuis l'extérieur et non depuis l'intérface du contrat.
    // payable est une notion de transfert d'argent.
    /// @notice Allows to contribute to the pool
    function contribute() external payable {
        // si l'user envoit de largent après le temps de la cagnotte alors revert.
        if (block.timestamp >= end) {
            revert CollectIsFinished(); //moins de gaz
        }
        if (msg.value == 0) {
            revert NotEnoughFunds();
        }
        contributions[msg.sender] += msg.value; //mettre à jour la contribution par contributeur
        totalCollected += msg.value; //mettre à jour la somme collectée
        emit Contribute(msg.sender, msg.value); // envoyer un evenement de contribution vers le front.
    }

    /// @notice Allows the owner to withdraw the gains of the pool
    function withdraw() external onlyOwner {
        if (block.timestamp < end || totalCollected < goal) {
            revert CollectNotFinished();
        }
        (bool sent, ) = msg.sender.call{value: address(this).balance}(""); //envoyer l'argent au propriétaire
        if (!sent) {
            revert FailedToSendEther(); //
        }
    }

    // fonction de remboursement
    ///@notice Allows the user to get his money back
    function refund() external {
        if (block.timestamp < end) {
            revert CollectNotFinished();
        }
        if (totalCollected >= goal) {
            revert GoalAlreadyReached();
        }
        if (contributions[msg.sender] == 0) {
            revert NoContribution();
        }
        //récuperer le montant donné par user qui fait refund
        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0; // mettre à jour les contributions de user
        totalCollected -= amount; // remboursement de la somme collectée
        (bool sent, ) = msg.sender.call{value: amount}(""); // on envoie à user le montant placé dans la cagnotte
        if (!sent) {
            revert FailedToSendEther();
        }
    }
}
