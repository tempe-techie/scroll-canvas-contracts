// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ScrollBadgeAccessControl } from
    "../extensions/ScrollBadgeAccessControl.sol";
import { ScrollBadgeCustomPayload } from
    "../extensions/ScrollBadgeCustomPayload.sol";
import { ScrollBadgeDefaultURI } from "../extensions/ScrollBadgeDefaultURI.sol";
import { ScrollBadgeEligibilityCheck } from
    "../extensions/ScrollBadgeEligibilityCheck.sol";
import { ScrollBadgeNoExpiry } from "../extensions/ScrollBadgeNoExpiry.sol";
import { ScrollBadgeSelfAttest } from "../extensions/ScrollBadgeSelfAttest.sol";
import { ScrollBadgeSingleton } from "../extensions/ScrollBadgeSingleton.sol";
import { ScrollBadge } from "../ScrollBadge.sol";
import { Unauthorized } from "../../Errors.sol";

function decodePayloadData(bytes memory data) pure returns (uint8) {
    return abi.decode(data, (uint8));
}

interface IActivityPoints {
    function getPoints(address user_) external view returns (uint256);
}

/// @title ScrollBadgeLevelsScrolly
/// @notice A badge that represents the Scrolly user's level.
contract ScrollBadgeLevelsScrolly is
    ScrollBadgeAccessControl,
    ScrollBadgeDefaultURI,
    ScrollBadgeEligibilityCheck,
    ScrollBadgeNoExpiry,
    ScrollBadgeSingleton,
    ScrollBadgeSelfAttest
{
    uint256 public immutable MINIMUM_POINTS_ELIGIBILITY = 1 ether;
    uint256 public immutable MINIMUM_POINTS_LEVEL_0 = 333 ether;
    uint256 public immutable MINIMUM_POINTS_LEVEL_1 = 777 ether;
    uint256 public immutable MINIMUM_POINTS_LEVEL_2 = 1337 ether;
    uint256 public immutable MINIMUM_POINTS_LEVEL_3 = 2442 ether;
    uint256 public immutable MINIMUM_POINTS_LEVEL_4 = 4200 ether;
    // uint256 immutable public MINIMUM_POINTS_LEVEL_5 = inf;

    address private apAddress; // activity points contract address
    string public baseBadgeURI;

    constructor(
        address resolver_,
        address activityPoints_,
        string memory _defaultBadgeURI, // IPFS, HTTP, or data URL
        string memory _baseBadgeURI // IPFS, HTTP, or data URL to add level to get image
    )
        ScrollBadge(resolver_)
        ScrollBadgeDefaultURI(_defaultBadgeURI)
    {
        apAddress = activityPoints_;
        baseBadgeURI = _baseBadgeURI;
    }

    /// @inheritdoc ScrollBadge
    function onIssueBadge(Attestation calldata attestation)
        internal
        override(
            ScrollBadge,
            ScrollBadgeAccessControl,
            ScrollBadgeNoExpiry,
            ScrollBadgeSingleton,
            ScrollBadgeSelfAttest
        )
        returns (bool)
    {
        if (!isEligible(attestation.recipient)) {
            revert Unauthorized();
        }

        return super.onIssueBadge(attestation);
    }

    /// @inheritdoc ScrollBadge
    function onRevokeBadge(Attestation calldata attestation)
        internal
        override(
            ScrollBadge,
            ScrollBadgeAccessControl,
            ScrollBadgeNoExpiry,
            ScrollBadgeSingleton,
            ScrollBadgeSelfAttest
        )
        returns (bool)
    {
        return super.onRevokeBadge(attestation);
    }

    /// @inheritdoc ScrollBadgeDefaultURI
    function getBadgeTokenURI(bytes32 uid) internal view override returns (string memory) {
        // We get current user level from latest attestation (using provided badge logic)
        uint8 level = getCurrentLevel(uid);

        string memory name = string(abi.encode("Scrolly Level #", Strings.toString(level)));
        string memory description = getLevelDescription(level);
        string memory image = string(abi.encode(baseBadgeURI, "/", Strings.toString(level), ".png"));
        string memory tokenUriJson = Base64.encode(
            abi.encodePacked(
                '{"name":"',
                name,
                '", "description":"',
                description,
                ', "image": "',
                image,
                ', "level": "',
                level,
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", tokenUriJson));
    }

    function getCurrentLevel(bytes32 uid) public view returns (uint8) {
        Attestation memory badge = getAndValidateBadge(uid);
        return getLevel(badge.recipient);
    }

    function isEligible(address recipient) public view override returns (bool) {
        return (IActivityPoints(apAddress).getPoints(recipient) >= MINIMUM_POINTS_ELIGIBILITY);
    }

    function getPoints(address recipient) public view returns (uint256) {
        return IActivityPoints(apAddress).getPoints(recipient);
    }

    function getLevel(address recipient) public view returns (uint8) {
        return determineBadgeLevel(IActivityPoints(apAddress).getPoints(recipient));
    }

    function determineBadgeLevel(uint256 points) public pure returns (uint8) {
        if (points <= MINIMUM_POINTS_LEVEL_0) {
            return 0; // Scrolly Baby
        } else if (points <= MINIMUM_POINTS_LEVEL_1) {
            return 1; // Scrolly Novice
        } else if (points <= MINIMUM_POINTS_LEVEL_2) {
            return 2; // Scrolly Explorer
        } else if (points <= MINIMUM_POINTS_LEVEL_3) {
            return 3; // Master Mapper
        } else if (points <= MINIMUM_POINTS_LEVEL_4) {
            return 4; // Carto Maestro
        } else {
            return 5; // Grand Cartographer of Scrolly
        }
    }

    function getLevelDescription(uint8 level) public pure returns (string memory) {
        if (level == 0) {
            return "Scrolly Baby";
        } else if (level == 1) {
            return "Scrolly Novice";
        } else if (level == 2) {
            return "Scrolly Explorer";
        } else if (level == 3) {
            return "Master Mapper";
        } else if (level == 4) {
            return "Carto Maestro";
        } else {
            return "Grand Cartographer of Scrolly";
        }
    }
}