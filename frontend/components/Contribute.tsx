"use client";
// ChakraUi
import { Flex, Text, Input, Button, Heading, useToast } from "@chakra-ui/react";
// React
import { useState } from "react";

//Constants & Types
import { contracAdress, abi } from "../constants";

// Viem
import { parseEther } from "viem";

// Wagmi
import {
  writeContract,
  prepareTransactionRequest,
  waitForTransactionReceipt,
} from "@wagmi/core";

const Contribute = () => {
  const [amount, setAmount] = useState<string>("");
  const contribute = async () => {
    
  }
  return (
    <>
      <Heading size="lg" mt="2rem">
        Contribute
      </Heading>
      <Flex mt={"1rem"}>
        <Input
          size="lg"
          type="number"
          placeholder="Amount in ETH"
          value={amount}
          onChange={(e) => {
            console.log(e.target.value);
          }}
        ></Input>
        <Button
          colorScheme="purple"
          size="lg"
          ml="1rem"
          onClick={() => contribute()}
        >
          Contribute
        </Button>
      </Flex>
    </>
  );
};

export default Contribute;
