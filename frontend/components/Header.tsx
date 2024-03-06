"use client";
// RainbowKit
import { ConnectButton } from "@rainbow-me/rainbowkit";
// ChakraUi
import { Flex, Text } from "@chakra-ui/react";
const Header = () => {
  return (
    <Flex
        justifyContent="space-between"
        alignItems="center"
        p="2rem"
    >
        <Text fontWeight="bold" fontSize="2xl">Logo</Text>
        <ConnectButton />
    </Flex>
  );
};

export default Header;
