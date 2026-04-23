// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract IndianFolkPaintingMasterRegistry {

    struct FolkPaintingStyle {
        string region;              // Bihar, Maharashtra, Odisha, Andhra Pradesh, etc.
        string communityOrLineage;  // Mithila women, Warli tribes, Raghurajpur painters, etc.
        string styleName;           // Madhubani, Warli, Pattachitra, Gond, Kalamkari, etc.
        string pigments;            // natural dyes, rice paste, lampblack, mineral colors
        string techniques;          // line work, dot patterns, cloth preparation, mud walls, etc.
        string iconography;         // epics, rituals, deities, nature, tribal cosmology
        string uniqueness;          // distinctive cultural or technical features
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    struct StyleInput {
        string region;
        string communityOrLineage;
        string styleName;
        string pigments;
        string techniques;
        string iconography;
        string uniqueness;
    }

    FolkPaintingStyle[] public styles;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event StyleRecorded(
        uint256 indexed id,
        string styleName,
        string communityOrLineage,
        address indexed creator
    );

    event StyleVoted(
        uint256 indexed id,
        bool like,
        uint256 likes,
        uint256 dislikes
    );

    constructor() {
        styles.push(
            FolkPaintingStyle({
                region: "India",
                communityOrLineage: "ExampleCommunity",
                styleName: "Example Style (replace with real entries)",
                pigments: "example pigments",
                techniques: "example techniques",
                iconography: "example iconography",
                uniqueness: "example uniqueness",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordStyle(StyleInput calldata s) external {
        styles.push(
            FolkPaintingStyle({
                region: s.region,
                communityOrLineage: s.communityOrLineage,
                styleName: s.styleName,
                pigments: s.pigments,
                techniques: s.techniques,
                iconography: s.iconography,
                uniqueness: s.uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit StyleRecorded(
            styles.length - 1,
            s.styleName,
            s.communityOrLineage,
            msg.sender
        );
    }

    function voteStyle(uint256 id, bool like) external {
        require(id < styles.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        FolkPaintingStyle storage f = styles[id];

        if (like) {
            f.likes += 1;
        } else {
            f.dislikes += 1;
        }

        emit StyleVoted(id, like, f.likes, f.dislikes);
    }

    function totalStyles() external view returns (uint256) {
        return styles.length;
    }
}
