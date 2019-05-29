pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;
    using SafeMath for uint;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;
    
    mapping(address=>bool) private authorizedCallers;                             // Blocks all state changes throughout the contract if false

    struct Airline{
        bool exists;
        bool registered;
        bool funded;
        bytes32[] flightKeys;
        Votes votes;
        uint numberOfInsurance;
    }
 
    struct Votes{
        uint votersCount;
        mapping(address => bool) voters;
    }

    struct Insurance {
        address buyer;
        address airline;
        uint value;
        uint ticketNumber;
        InsuranceState state;
    }

    enum InsuranceState {
        NotExist,
        WaitingForBuyer,
        Bought,
        Passed,
        Expired
    }

    mapping(bytes32 => Insurance) private insurances;
    mapping(bytes32 => bytes32[]) private flightInsuranceKeys;
    mapping(address => bytes32[]) private passengerInsuranceKeys;

    uint private airlinesCount = 0;
    uint private registeredAirlinesCount = 0;
    uint private fundedAirlinesCount = 0;


    mapping(address => Airline) private airlines;
    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    event AirlineExist(address airlineAddress, bool exist);
    event AirlineRegistered(address airlineAddress, bool exist, bool registered);
    event AirlineFunded(address airlineAddress, bool exist, bool registered, bool funded, uint fundedCount);
    event AirlineVoted(address votingAirlineAddress, address votedAirlineAddress, uint startingVotesCount, uint endingVotesCount);
    event GetVotesCalled(uint votesCount);
    event AuthorizedCallerCheck(address caller);
    event AuthorizeCaller(address caller);
    event InsurancePaid(uint amount, address to);
    event InsuranceStateValue(InsuranceState state);

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                    address airlineAddress
                                )
                                public
    {
        contractOwner = msg.sender;
        //init airline
        airlines[airlineAddress] = Airline({
            exists:true,
            registered:true,
            funded: false,
            flightKeys: new bytes32[](0),
            votes: Votes(0),
            numberOfInsurance:0
        });

        airlinesCount = airlinesCount.add(1);
        registeredAirlinesCount = registeredAirlinesCount.add(1);

        emit AirlineExist(airlineAddress,  airlines[airlineAddress].exists);
        emit AirlineRegistered( airlineAddress,  airlines[airlineAddress].exists, airlines[airlineAddress].registered);
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational()
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

     /**
    * @dev Modifier that requires the airline address to be presend in airlines array
    */
    modifier requireAirLineExist(address airlineAddress)
    {
        require(airlines[airlineAddress].exists, "Airline does not exist in requireAirLineExist");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the airline address to be registered in airlines array
    */
    modifier requireAirLineRegistered(address airlineAddress)
    {
        require(airlines[airlineAddress].exists, "Airline does not exist in requireAirLineRegistered");
        require(airlines[airlineAddress].registered, "Airline is not registered in requireAirLineRegistered");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the airline address to be funded in airlines array
    */
    modifier requireAirLineFunded(address airlineAddress)
    {
        require(airlines[airlineAddress].exists, "Airline does not exist in requireAirLineFunded");
        require(airlines[airlineAddress].registered, "Airline is not registered in requireAirLineFunded");
        require(airlines[airlineAddress].funded, "Airline is not funded in requireAirLineFunded");

        _;  // All modifiers require an "_" which indicates where the function body will be added
    }


    modifier requireAuthorizedCaller(address contractAddress)
    {
        // require(authorizedCallers[contractAddress] == true, "Not Authorized Caller");
        emit AuthorizedCallerCheck(contractAddress);
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */
    function isOperational()
                            public
                            view
                            returns(bool)
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */
    function setOperatingStatus
                            (
                                bool mode
                            )
                            external
                            requireContractOwner
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */
    function registerAirline
                            (
                            )
                            external
                            pure
    {
        
    }


   /**
    * @dev Buy insurance for a flight
    *
    */
    function buy
                            (
                            )
                            external
                            payable
    {

    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                )
                                external
                                pure
    {
    }

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                            )
                            external
                            pure
    {
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */
    function fund
                            (
                            )
                            public
                            payable
    {
    }

    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32)
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function()
                            external
                            payable
    {
        fund();
    }


}

