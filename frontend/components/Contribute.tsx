"use client";

// ChakraUI
import { Flex, Input, Button, Heading, useToast } from "@chakra-ui/react";

// React
import { useState } from "react";

// Constants and Types
import { contractAdress, abi } from "../constants/index";
import { LayoutProps } from "../types/index";

// Viem
import { parseEther } from "viem";

// Wagmi
import {
  prepareWriteContract,
  writeContract,
  waitForTransaction,
} from "@wagmi/core";

const Contribute = () => {
  const toast = useToast();
  const [amount, setAmount] = useState<string>("");

  const contribute = async () => {
    // Prepare la transaction 
    try {
      let money = parseEther(amount);
      const { request } = await prepareWriteContract({
        address: contractAdress,
        abi: abi,
        functionName: "contribute",
        value: money,
      });

      // Execute la transaction
      const { hash } = await writeContract(request);
      const data = await waitForTransaction({
        hash: hash,
      });
      console.log(data);
      toast({
        title: "Congratulations",
        description: "Your contribution has been added.",
        status: "success",
        duration: 4000,
        isClosable: true,
      });
    } catch (e) {
      toast({
        title: "Error",
        description: "An error occured",
        status: "error",
        duration: 4000,
        isClosable: true,
      });
    }
  };

  return (
    <>
      <Heading mt="2rem">Contribute</Heading>
      <Flex mt="1rem">
        <Input
          placeholder="Your amount in ETH"
          size="lg"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
        <Button colorScheme="purple" size="lg" onClick={() => contribute()}>
          Contribute
        </Button>
      </Flex>
    </>
  );
};

export default Contribute;
