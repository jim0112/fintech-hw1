// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import { ClassroomV2 } from "../../test/Classroom/Classroom.t.sol";

/* Problem 1 Interface & Contract */
contract StudentV1 {
    // Note: You can declare some state variable
    uint256 cnt = 0;
    function register() external returns (uint256) {
        // TODO: please add your implementaiton here
        if (cnt == 0){
            cnt += 1;
            return 1001;
        }
        return 123;
    }
}

/* Problem 2 Interface & Contract */
interface IClassroomV2 {
    function isEnrolled() external view returns (bool);
}

contract StudentV2 {
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
        if (!IClassroomV2(msg.sender).isEnrolled())
            return 1001;
        return 123;
    }
}

/* Problem 3 Interface & Contract */
contract StudentV3 {
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
        if (gasleft() > 7_000)
            return 1001;
        return 123;
    }
}
