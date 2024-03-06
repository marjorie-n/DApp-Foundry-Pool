"use client";
//Components
import Header from "./Header";
import Footer from "./Footer";

// ChakraUi
import { Flex } from "@chakra-ui/react";
//Types
import { LayoutProps } from "../types/index";

export const Layout = ({ children }: LayoutProps) => {
  return (
    <Flex
      direction="column"
      minH="100vh"
      justifyContent="space-between"
      alignItems="center"
    >
      <Header />
      <Flex direction="column" p="2rem" alignItems="center" width="100%">
        {children}
      </Flex>
      <Footer />
    </Flex>
  );
};

export default Layout;
