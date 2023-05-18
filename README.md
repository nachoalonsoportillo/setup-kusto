# setup-kusto

[![Tests](https://github.com/philip-gai/setup-kusto/actions/workflows/tests.yaml/badge.svg)](https://github.com/philip-gai/setup-kusto/actions/workflows/tests.yaml)

Set up your GitHub Actions workflow with a specific version of the Kusto CLI.

By default this action will install Kusto CLI version 11.3.1 which requires Dotnet 6. As of 2023-05-18, Dotnet 6 is installed by default on all of the latest GitHub-hosted runners, so you should not need to do any other manual setup.

For older versions of the Kusto CLI that do not target Dotnet 6, you will have to make sure you setup the required version of Dotnet yourself. For example, for Kusto CLI version 6.0.1, you will need to add the following to your workflow:

  ```yaml
      - uses: actions/setup-dotnet@v3.0.3
        with:
          dotnet-version: "2.1.x"
      - uses: philip-gai/setup-kusto
        with:
          kusto-version: "6.0.1"
          target-version: netcoreapp2.1
  ```

Once the Kusto CLI is installed, you can use it in your workflow like so:

  ```yaml
      - run: dotnet "${{ env.KUSTO_CLI_PATH }}" -execute:"#help"
        shell: bash
  ```
