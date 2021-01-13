/*
    Copyright 2021 BASD Devs, based on the works of the Empty Set Squad

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

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@pancakeswap/v2-core/contracts/interfaces/IPancakeswapPair.sol';
import '../external/PancakeswapLibrary.sol';
import "../Constants.sol";
import "./PoolGetters.sol";

contract Liquidity is PoolGetters {
    address private constant PANCAKESWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
        (address dollar, address busd) = (address(dollar()), busd());
        (uint reserveA, uint reserveB) = getReserves(dollar, busd);

        uint256 busdAmount = (reserveA == 0 && reserveB == 0) ?
             dollarAmount :
             PancakeswapLibrary.quote(dollarAmount, reserveA, reserveB);

        address pair = address(cakelp());
        IERC20(dollar).transfer(pair, dollarAmount);
        IERC20(busd).transferFrom(msg.sender, pair, busdAmount);
        return (busdAmount, IPancakeswapPair(pair).mint(address(this)));
    }

    // overridable for testing
    function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = PancakeswapLibrary.sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IPancakeswapPair(PancakeswapLibrary.pairFor(PANCAKESWAP_FACTORY, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }
}
