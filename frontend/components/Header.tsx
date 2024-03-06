"use client";
// RainbowKit
import { ConnectButton } from "@rainbow-me/rainbowkit";
// ChakraUi
import { Flex, Text } from "@chakra-ui/react";
const Header = () => {
  return (
    <Flex
      p="2rem"
      justifyContent="space-between"
      alignItems="center"
      width="100vh"
    >
      <Text as="b">Logo</Text>
      <ConnectButton />
    </Flex>
  );
};

export default Header;
