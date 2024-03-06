"use client";
// ChakraUi
import { Flex, Text } from "@chakra-ui/react";
import Link from "next/link";
import { FaGithub } from "react-icons/fa";

const Footer = () => {
  return (
    <Flex p="2rem" alignItems="center" justifyContent="center">
      <Text fontSize="sm" fontWeight="bold">
        &copy; Marjorie NG. {new Date().getFullYear()}
      </Text>
      <Link
        href="https://github.com/your-github-username/your-repo"
        target="_blank"
        rel="noopener noreferrer"
      >
        <FaGithub size="1rem" style={{ marginLeft: "1rem" }} />
      </Link>
    </Flex>
  );
};

export default Footer;
