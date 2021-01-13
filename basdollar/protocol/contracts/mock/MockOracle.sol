/*
    Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import '@pancakeswap/v2-core/contracts/interfaces/IPancakeswapPair.sol';
import "../oracle/Oracle.sol";
import "../external/Decimal.sol";

contract MockOracle is Oracle {
    Decimal.D256 private _latestPrice;
    bool private _latestValid;
    address private _busd;

    constructor (address pair, address dollar, address busd) Oracle(dollar) public {
        _pair = IPancakeswapPair(pair);
        _index = 0;
        _busd = busd;
    }

    function busd() internal view returns (address) {
        return _busd;
    }

    function capture() public returns (Decimal.D256 memory, bool) {
        (_latestPrice, _latestValid) = super.capture();
        return (_latestPrice, _latestValid);
    }

    function latestPrice() external view returns (Decimal.D256 memory) {
        return _latestPrice;
    }

    function latestValid() external view returns (bool) {
        return _latestValid;
    }

    function isInitialized() external view returns (bool) {
        return _initialized;
    }

    function cumulative() external view returns (uint256) {
        return _cumulative;
    }

    function timestamp() external view returns (uint256) {
        return _timestamp;
    }

    function reserve() external view returns (uint256) {
        return _reserve;
    }
}
