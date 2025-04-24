# Fern MCP

To use Fern's MCP server, you need to install a small piece of software on your computer.

This enables Claude Desktop to authorise your Fern account and connect to our MCP server.

Once you have run the script, open Claude Desktop and ask it to use the Fern tools.

## OSX Users

Open terminal app and run the following command:

```
curl -fsSL https://github.com/meetfern/fern-mcp/raw/main/bin/bootstrap.sh | bash
```

## Windows Users

Open PowerShell and run the following command:

```
iwr https://github.com/meetfern/fern-mcp/raw/main/bin/install.ps1 -UseBasicParsing | iex
```
