"use client";
// frontend/components/Pool.tsx
import Contribute  from "./Contribute";
import { useState, useEffect } from "react";
// Wagmi
import { useAccount } from "wagmi";
// ChakraUi
import { Alert, AlertIcon } from "@chakra-ui/react";

useState;
const Pool = () => {
  const { address, isConnected } = useAccount();
  return (
    <>
      {isConnected ? (
        <Contribute />
      ) : (
        <Alert status="warning">
          <AlertIcon />
          Please connect your wallet
        </Alert>
      )}
    </>
  );
};

export default Pool;
