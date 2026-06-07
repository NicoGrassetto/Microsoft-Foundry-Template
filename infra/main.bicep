// =============================================================================
//  Microsoft Foundry — main.bicep
// -----------------------------------------------------------------------------
//  WHAT THIS DEPLOYS
//    1. A Microsoft Foundry account  (Azure resource type:
//       Microsoft.CognitiveServices/accounts, kind "AIServices"). This is the
//       top-level container that exposes models and the Foundry/Agent APIs.
//    2. A default Foundry *project* (child resource). Projects are where your
//       agents, data, and connections live, and they are the unit used for
//       access control, data isolation, and cost tracking.
//
//  HOW TO READ THIS FILE (it is intentionally a teaching template)
//    • Lines WITHOUT "//" in front of them are ACTIVE — they are deployed.
//    • Lines that ARE commented out (start with "//") are NOT deployed. They are
//      every other option the resource supports, left here with an explanation
//      so you can switch them on later for a Pilot / production hardening pass.
//    • Every parameter, field, and resource has a plain-language comment above
//      it explaining what it does in a demo / PoC / Pilot context.
//
//  We picked settings that are simplest and safest for a demo / PoC. Anything
//  marked "Pilot/prod" is an opt-in you usually don't need just to show value.
// =============================================================================

// -----------------------------------------------------------------------------
//  TARGET SCOPE
//  Deploy these resources INTO an existing resource group (a folder that holds
//  related Azure resources). This is the normal choice for an app-centric
//  template; "azd up" creates/uses a resource group for you.
// -----------------------------------------------------------------------------
targetScope = 'resourceGroup'

// =============================================================================
//  PARAMETERS  (the values you supply at deploy time)
// =============================================================================

// The name of the Foundry account. It must be globally unique-ish because it
// becomes part of your endpoint URL (https://<name>.services.ai.azure.com).
// We give it NO default on purpose, so "azd up" PROMPTS you for it the first
// time and then remembers your answer for next time.
@minLength(2)
@maxLength(64)
@description('Name of the Microsoft Foundry account. Becomes part of the endpoint URL. You will be prompted for this on "azd up".')
param foundryAccountName string

// The Azure region the resources live in. Model availability differs per
// region, so pick one that offers the models you want. "azd up" sets this from
// the location you choose when you create the azd environment (AZURE_LOCATION).
@minLength(1)
@description('Azure region to deploy into, e.g. eastus2. Chosen during "azd up".')
param location string

// The name of the default project created inside the account. Defaults to
// "<account-name>-project" so it is always unique to this account. This is the
// project your app talks to when it does not name one explicitly.
// (No @maxLength here: the default is derived from the account name, which is
// already length-limited, and pinning a max would conflict with that worst case.)
@minLength(2)
@description('Name of the default Foundry project (where agents live). Defaults to "<account>-project".')
param defaultProjectName string = '${foundryAccountName}-project'

// ---- OPTIONAL parameters (not configured — uncomment to use) ----------------

// Tags are free-form key/value labels stamped on the resource. Great for
// grouping by environment or owner and for tracking cost in the Azure portal.
// @description('Resource tags for organization and cost tracking.')
// param tags object = {
//   env: 'demo'
//   owner: 'you@example.com'
// }

// Object (principal) ID of the user or service principal that should be allowed
// to call the account. Needed only if you enable the RBAC block near the bottom
// (because we turn API keys OFF, callers must be granted a role instead).
// @description('Object ID of the identity to grant data-plane access via RBAC. Leave empty to skip.')
// param callerObjectId string = ''

// =============================================================================
//  RESOURCE: Microsoft Foundry account
//  This is the core resource. "kind: AIServices" is what makes it a unified
//  Foundry/AI Services account that can host models AND Foundry projects/agents.
// =============================================================================
resource foundry 'Microsoft.CognitiveServices/accounts@2026-03-15-preview' = {
  // The account name (from the parameter above).
  name: foundryAccountName

  // The region (from the parameter above).
  location: location

  // The "kind" (type) of Cognitive Services account.
  //   'AIServices' = the unified Foundry experience (models + agents). Use this.
  // Other kinds exist for single services, e.g. 'OpenAI', 'SpeechServices',
  // 'ComputerVision', 'TextAnalytics' — not what we want for Foundry.
  kind: 'AIServices'

  // The SKU is the pricing/capacity tier.
  sku: {
    // 'S0' is the standard pay-as-you-go tier — the normal choice for Foundry.
    name: 'S0'

    // ---- Other SKU fields (not configured — usually unnecessary) ----
    // 'tier' is the broad band the SKU belongs to. It is implied by the name,
    // so you rarely set it by hand. Allowed: Free, Basic, Standard, Premium,
    // Enterprise.
    // tier: 'Standard'
    // 'capacity' = number of scale units, only for SKUs that scale out/in.
    // capacity: 1
    // 'family' / 'size' identify a hardware generation / sub-size for SKUs that
    // have several. Not used by 'S0'.
    // family: ''
    // size: ''
  }

  // A managed identity lets this resource authenticate to OTHER Azure services
  // (Storage, Key Vault, Search, …) WITHOUT storing secrets.
  identity: {
    // 'SystemAssigned' = Azure creates and manages one identity tied to this
    // resource's lifecycle. Simplest option, great for demos.
    // Other choices: 'UserAssigned' (bring an identity you can reuse across
    // resources), 'SystemAssigned, UserAssigned' (both), or 'None'.
    type: 'SystemAssigned'

    // Only needed when type includes 'UserAssigned': the identity resource IDs.
    // userAssignedIdentities: {
    //   '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<name>': {}
    // }
  }

  // Tags applied to the account (enable the 'tags' parameter above to use this).
  // tags: tags

  // The big bucket of behaviour settings for the account.
  properties: {
    // ---- ACTIVE settings (what we configured) -------------------------------

    // THE flag that makes this account a "Foundry" account: it allows Foundry
    // *projects* to be created as child resources (containers for agents, data,
    // access control, and cost). Required for any agent scenario.
    allowProjectManagement: true

    // Sets the subdomain on your endpoint, e.g. "<name>.services.ai.azure.com".
    // Required for Microsoft Entra ID (token) authentication, which we use.
    // Convention: match the account name.
    customSubDomainName: foundryAccountName

    // Which project is targeted when the app calls the endpoint without naming a
    // project. We point it at the default project we create below.
    defaultProject: defaultProjectName

    // The list of projects associated with this account. We list our default
    // project so the account and the project resource stay in sync.
    associatedProjects: [
      defaultProjectName
    ]

    // Whether the endpoint is reachable from the public internet.
    //   'Enabled'  = easiest for demos/PoCs (default here).
    //   'Disabled' = lock it down to private endpoints only (Pilot/prod).
    publicNetworkAccess: 'Enabled'

    // Turns OFF API-key (local) auth, forcing every caller to use Microsoft
    // Entra ID identity-based auth (DefaultAzureCredential in the Python code).
    // More secure — no secrets to leak. Consequence: the caller (you / CI / the
    // app's identity) must be granted an RBAC role on this account, e.g.
    // "Azure AI Developer" or "Cognitive Services User" (see the RBAC block at
    // the bottom). Set to false if you want quick key-based demos instead.
    disableLocalAuth: true

    // ---- NOT configured (left here so you can switch them on later) ---------

    // Smooths bursty traffic instead of hard-failing. NOTE: this account-level
    // flag does NOT govern Azure OpenAI model 429s — those are controlled by
    // each model deployment's TPM quota. It is rarely used; leave it off.
    // dynamicThrottlingEnabled: false

    // Allowlist of outbound domains (FQDNs) the resource may call. Used together
    // with egress restrictions in locked-down networks. Empty = no allowlist.
    // allowedFqdnList: [
    //   'example.com'
    // ]

    // Restricts OUTBOUND (egress) network access from the resource. Pilot/prod
    // hardening; leave off for demos.
    // restrictOutboundNetworkAccess: false

    // Disables server-side "stored completions" (saving chat completions for
    // later evaluation/distillation). Keep enabled (false) if you want to
    // experiment with eval/fine-tuning workflows.
    // storedCompletionsDisabled: false

    // Firewall rules: who can reach the account by network location.
    //   defaultAction 'Deny' + explicit allow rules = locked down (Pilot/prod).
    //   bypass 'AzureServices' lets trusted Azure services through.
    // networkAcls: {
    //   defaultAction: 'Deny'
    //   bypass: 'AzureServices'
    //   ipRules: [
    //     { value: '203.0.113.0/24' } // an allowed public IP range (CIDR)
    //   ]
    //   virtualNetworkRules: [
    //     {
    //       id: '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>'
    //       ignoreMissingVnetServiceEndpoint: false
    //     }
    //   ]
    // }

    // Injects the Agent service into YOUR virtual network subnet so agents run
    // with private networking. Advanced secure-agent scenario.
    // networkInjections: [
    //   {
    //     scenario: 'agent'            // 'agent' or 'none'
    //     subnetArmId: '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>'
    //     useMicrosoftManagedNetwork: false
    //   }
    // ]

    // Encryption at rest. By default Microsoft manages the keys. Switch to
    // customer-managed keys (CMK) stored in your Key Vault for compliance.
    // encryption: {
    //   keySource: 'Microsoft.KeyVault'  // or 'Microsoft.CognitiveServices' (default)
    //   keyVaultProperties: {
    //     keyName: '<key-name>'
    //     keyVaultUri: 'https://<your-vault>.vault.azure.net/'
    //     keyVersion: '<key-version>'
    //     identityClientId: '<client-id-of-identity-with-vault-access>'
    //   }
    // }

    // Controls whether/when the Foundry account auto-upgrades. Use to govern
    // upgrade timing in production.
    // foundryAutoUpgrade: {
    //   mode: 'Enabled'                 // 'Enabled' or 'Disabled'
    //   plannedByMicrosoft: true
    //   scheduledAt: ''                 // ISO-8601 time for a planned upgrade
    //   statusReason: ''
    // }

    // Responsible AI monitoring: streams RAI/content-safety signals to an Azure
    // Data Explorer (ADX) store you own. For monitoring content safety at scale.
    // raiMonitorConfig: {
    //   adxStorageResourceId: '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.Kusto/clusters/<cluster>/databases/<db>'
    //   identityClientId: '<client-id-of-identity-with-adx-access>'
    // }

    // Multi-region routing for higher availability / scale. Overkill for demos.
    // locations: {
    //   routingMethod: 'Performance'    // 'Performance' | 'Priority' | 'Weighted'
    //   regions: [
    //     { name: 'eastus2', value: 1, customsubdomain: '' }
    //     { name: 'westus3', value: 2, customsubdomain: '' }
    //   ]
    // }

    // Bring-your-own Azure Storage account(s) for data the service stores, so
    // you keep full control/visibility of that data.
    // userOwnedStorage: [
    //   {
    //     resourceId: '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/<name>'
    //     identityClientId: '<client-id-of-identity-with-storage-access>'
    //   }
    // ]

    // Link a user-owned Azure Machine Learning workspace (advanced ML scenarios).
    // amlWorkspace: {
    //   resourceId: '/subscriptions/<subId>/resourceGroups/<rg>/providers/Microsoft.MachineLearningServices/workspaces/<name>'
    //   identityClientId: '<client-id>'
    // }

    // Restores a soft-deleted account of the same name instead of creating new.
    // restore: false

    // Token used only when migrating an existing resource. Not for new deploys.
    // migrationToken: ''

    // Legacy settings for OLDER single-purpose services (Metrics Advisor,
    // QnAMaker, Personalizer, Bing). Not used by Foundry — listed for reference.
    // apiProperties: {
    //   aadClientId: ''
    //   aadTenantId: ''
    //   eventHubConnectionString: ''
    //   qnaAzureSearchEndpointId: ''
    //   qnaAzureSearchEndpointKey: ''
    //   qnaRuntimeEndpoint: ''
    //   statisticsEnabled: false
    //   storageAccountConnectionString: ''
    //   superUser: ''
    //   websiteName: ''
    // }
  }
}

// =============================================================================
//  RESOURCE: default Foundry project (child of the account)
//  Projects are where agents, files, and connections live. Creating one here
//  means the account's "defaultProject" pointer above actually exists.
// =============================================================================
resource project 'Microsoft.CognitiveServices/accounts/projects@2026-03-15-preview' = {
  // Attaches this project to the account above as its parent.
  parent: foundry

  // The project's name (also used in the project endpoint URL).
  name: defaultProjectName

  // Projects are regional; keep them in the same region as the account.
  location: location

  // Give the project its own system-managed identity. Useful later when the
  // project needs to authenticate to connected resources (Storage, Search, …).
  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    // Friendly name shown in the Foundry portal.
    displayName: defaultProjectName

    // A short human-readable description of what this project is for.
    description: 'Default project created by the Microsoft Foundry Starter Kit.'
  }
}

// =============================================================================
//  OPTIONAL RESOURCE: model deployment (NOT configured — uncomment to use)
// -----------------------------------------------------------------------------
//  Your agents need a model to run. The Python code's MODEL_NAME defaults to
//  "gpt-4.1", so deploying a model with that exact name makes the sample work
//  end-to-end. "GlobalStandard" routes to Microsoft-managed global capacity and
//  is the easiest SKU for demos. Raise 'capacity' (tokens-per-minute, in
//  thousands) if you hit 429 rate limits during a live demo.
// =============================================================================
// resource gptModel 'Microsoft.CognitiveServices/accounts/deployments@2026-03-15-preview' = {
//   parent: foundry
//   name: 'gpt-4.1'
//   sku: {
//     name: 'GlobalStandard'
//     capacity: 50
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-4.1'
//       version: '2025-04-14'
//     }
//   }
// }

// =============================================================================
//  OPTIONAL RESOURCE: RBAC role assignment (NOT configured — uncomment to use)
// -----------------------------------------------------------------------------
//  Because we set disableLocalAuth = true (no API keys), callers must be granted
//  a role to use the account. This grants "Azure AI Developer" to the principal
//  in the 'callerObjectId' parameter. Uncomment BOTH the 'callerObjectId'
//  parameter near the top AND this block to use it.
// =============================================================================
// // Built-in role definition ID for "Azure AI Developer".
// var azureAiDeveloperRoleId = '64702f94-c441-49e6-a78b-ef80e0188fee'
// resource caller_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(callerObjectId)) {
//   scope: foundry
//   // A stable, unique name for the assignment (deterministic GUID).
//   name: guid(foundry.id, callerObjectId, azureAiDeveloperRoleId)
//   properties: {
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', azureAiDeveloperRoleId)
//     principalId: callerObjectId
//     // 'User' for a person; use 'ServicePrincipal' for an app/CI identity.
//     principalType: 'User'
//   }
// }

// =============================================================================
//  OUTPUTS  (values printed after deploy; with azd they become environment
//  variables your app/.env can consume)
// =============================================================================

// The project endpoint your Python app expects (AZURE_AI_PROJECT_ENDPOINT).
// Built from the account subdomain + project name.
output AZURE_AI_PROJECT_ENDPOINT string = 'https://${foundryAccountName}.services.ai.azure.com/api/projects/${defaultProjectName}'

// The account name (azd remembers this so it does not re-prompt next time).
output AZURE_FOUNDRY_ACCOUNT_NAME string = foundry.name

// The raw account endpoint (handy for non-project calls / debugging).
output AZURE_FOUNDRY_ACCOUNT_ENDPOINT string = foundry.properties.endpoint

// The default project's name.
output AZURE_FOUNDRY_PROJECT_NAME string = project.name

// The account's system-assigned identity principal ID — use it when granting
// the account access to other resources (Storage, Key Vault, Search, …).
output AZURE_FOUNDRY_PRINCIPAL_ID string = foundry.identity.principalId
