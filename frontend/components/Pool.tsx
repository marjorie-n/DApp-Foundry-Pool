"use client";
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
      {isConnected
        ? `Connected: ${address}`
        : (
          <Alert status="warning">
            <AlertIcon />
            Please connect your wallet
          </Alert>
        )}
    </>
  );
};

export default Pool;
