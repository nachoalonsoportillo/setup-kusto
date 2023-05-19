# setup-kusto

[![Tests](https://github.com/philip-gai/setup-kusto/actions/workflows/tests.yaml/badge.svg)](https://github.com/philip-gai/setup-kusto/actions/workflows/tests.yaml)

Set up your GitHub Actions workflow with a specific version of the Kusto CLI.

## Usage

By default this action will install Kusto CLI version 11.3.1 which requires Dotnet 6. As of 2023-05-18, Dotnet 6 is installed by default on all of the latest GitHub-hosted runners, so you should not need to do any other manual setup.

The recommended approach is to use the [`philip-gai/kusto-script`](https://github.com/philip-gai/kusto-script) action with this action in order to setup and run queries and scripts against your Kusto cluster. Here's a full workflow example:

  ```yaml
      steps:
        - uses: actions/checkout@v3.5.2 # If running a Kusto script
        - uses: Azure/login@v1 # Use OIDC if possible
          with:
            client-id: ${{ env.AZURE_CLIENT_ID }} # Value from Azure AAD
            tenant-id: ${{ env.AZURE_TENANT_ID }} # Value from Azure AAD
            allow-no-subscriptions: true
        - uses: philip-gai/setup-kusto@v1
        - name: Run inline query
          uses: philip-gai/kusto-script@v1
          with:
            kusto-uri: ${{ env.KUSTO_URI }} # Example: https://mycluster.kusto.windows.net or https://mycluster.kusto.windows.net/MyDatabase
            kusto-query: ".show databases"
        - name: Run Kusto script
          uses: philip-gai/kusto-script@v1
          with:
            kusto-uri: ${{ env.KUSTO_URI }} # Example: https://mycluster.kusto.windows.net or https://mycluster.kusto.windows.net/MyDatabase
            kusto-script: "path/to/script.kql" # Relative to the repository root
  ```

For older versions of the Kusto CLI that do not target Dotnet 6, you will have to make sure you setup the required version of Dotnet yourself. For example, for Kusto CLI version 6.0.1, you will need to add the following to your workflow:

  ```yaml
      - uses: actions/setup-dotnet@v3.0.3
        with:
          dotnet-version: "2.1.x"
      - uses: philip-gai/setup-kusto@v1
        with:
          kusto-version: "6.0.1"
          target-version: netcoreapp2.1
  ```

Once the Kusto CLI is installed, you can also use the Kusto CLI directly in your workflow like so:

  ```yaml
      - run: dotnet "${{ env.KUSTO_CLI_PATH }}" -execute:"#help"
        shell: bash
  ```
