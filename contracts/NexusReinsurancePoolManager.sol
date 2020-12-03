pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import { MainStorage } from  "./mainStorage/MainStorage.sol";

import { MCR } from "./nexus-mutual/modules/capital//MCR.sol";
import { Pool1 } from "./nexus-mutual/modules/capital//Pool1.sol";
import { Pool2 } from "./nexus-mutual/modules/capital//Pool2.sol";
import { PoolData } from "./nexus-mutual/modules/capital/PoolData.sol";
import { PoolData } from "./nexus-mutual/modules/capital/PoolData.sol";
import { NXMToken } from "./nexus-mutual/modules/token/NXMToken.sol";
import { PooledStaking } from "./nexus-mutual/modules/staking/PooledStaking.sol";
import { Claims } from "./nexus-mutual/modules/claims/Claims.sol";

import { WNXMToken } from "./WNXMToken.sol";
import { ReinsurancePoolFactory } from "./ReinsurancePoolFactory.sol";


/***
 * @notice - The interface between the reinsurance pool and Nexus Mutual.
 *         - Multi-sig governance that can only change items if passed by Nexus Mutual formal governance. 
 *
 * @dev - Note: integrate into full governance later.
 * @dev - TO DO: Define the precise claim triggers that will result in a reinsurance claim and for how much.
 *
 * @dev - Has the power to:
 *        ・Deploy new reinsurance pools with specific parameters
 *        ・Set reward rates per pool
 *        ・Send rewards to the reinsurance pools for distribution
 **/
contract NexusReinsurancePoolManager {
    MainStorage public mainStorage;
    MCR public mcr;
    Pool1 public pool1;
    Pool2 public pool2;
    PoolData public poolData;
    NXMToken public nxmToken;
    PooledStaking public pooledStaking;
    Claims public claims;
    WNXMToken public wNXMToken;
    ReinsurancePoolFactory public reinsurancePoolFactory;

    address MCR_ADDRESS;
    address NXM_TOKEN; 
    address POOLED_STAKING;
    address CLAIMS; 
    address WNXM_TOKEN;
    address REINSURANCE_POOL_FACTORY;

    constructor(MainStorage _mainStorage, MCR _mcr, Pool1 _pool1, Pool2 _pool2, PoolData _poolData, NXMToken _nxmToken, PooledStaking _pooledStaking, Claims _claims, WNXMToken _wNXMToken, ReinsurancePoolFactory _reinsurancePoolFactory) public {
        mainStorage = _mainStorage;
        mcr = _mcr;
        pool1 = _pool1;
        pool2 = _pool2;
        poolData = _poolData;
        nxmToken = _nxmToken;
        pooledStaking = _pooledStaking;
        claims = _claims;
        wNXMToken = _wNXMToken;
        reinsurancePoolFactory = _reinsurancePoolFactory;

        MCR_ADDRESS = address(_mcr);
        NXM_TOKEN = address(_nxmToken);
        POOLED_STAKING = address(_pooledStaking);
        CLAIMS = address(_claims);
        WNXM_TOKEN = address(_wNXMToken);
        REINSURANCE_POOL_FACTORY = address(_reinsurancePoolFactory);
    }


    ///------------------------------------------------------------
    /// Functions that new Nexus Reinsurance Pool creation
    ///------------------------------------------------------------

    /***
     * @notice - Create a new Nexus Reinsurance Pool
     **/
    function createNexusReinsurancePool() public returns (bool) {
        reinsurancePoolFactory.createNexusReinsurancePool();
    }


    ///------------------------------------------------------------
    /// Functions that are used when rewards
    ///------------------------------------------------------------

    /***
     * @notice - Receives NXM from Nexus Mutual Capital Pool and converts to wNXM
     *         - After that, loads up rewards
     **/
    function convertFromNXMToWNXM(address _nexusMutual, uint receivedNXMAmount) public returns (bool) {
        /// Receives NXM from Nexus Mutual
        nxmToken.transferFrom(_nexusMutual, address(this), receivedNXMAmount);
    
        /// Converts from NXM to wNXM
        _convertFromNXMToWNXM(receivedNXMAmount);

        /// Loads up rewards
    }

    /***
     * @notice - Sends wNXM rewards to the Reinsurance pools.
     **/
    function sendWNXMRewardToReinsurancePool(address reinsurancePool, uint rewardsAmount) public returns (bool) {
        wNXMToken.transfer(reinsurancePool, rewardsAmount);
    }    


    ///------------------------------------------------------------
    /// Functions that are used when claims
    ///------------------------------------------------------------

    /***
     * @notice - Receives LP tokens in the event of a claim
     **/
    function receiveLPToken() public returns (bool) {}
    

    /***
     * @notice - Converts (Redeem) LP tokens into underlying assets
     **/
    function convertLPTokenIntoUnderlyingAsset() public returns (bool) {}


    /***
     * @notice - Sends underlying assets into Nexus Mutual capital pool
     **/ 
    function sendUnderlyingAssetIntoNexusMutualCapitalPool() public returns (bool) {}



    ///------------------------------------------------------------
    /// Configuration related functions of Nexus Mutual
    ///------------------------------------------------------------

    /***
     * @notice - Set reward rates per pool
     **/ 
    function setRewardRate(uint8 reinsurancePoolId, uint8 rewardRate) public returns (bool) {
        mainStorage.saveRewardRate(reinsurancePoolId, rewardRate);
    }


    ///------------------------------------------------------------
    /// Internal functions
    ///------------------------------------------------------------
    
    function _convertFromNXMToWNXM(uint receivedNXMAmount) internal returns (bool) {
        /// Mint WNXM token (and send those tokens into this contract)
        wNXMToken.mint(address(this), receivedNXMAmount);
    }





    ///------------------------------------------------------------
    /// Getter functions
    ///------------------------------------------------------------
 


    ///------------------------------------------------------------
    /// Private functions
    ///------------------------------------------------------------


}
