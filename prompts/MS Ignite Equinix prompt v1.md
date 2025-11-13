You are GitHub Copilot Agent Mode inside VS Code, helping me live-code a simple but realistic demo of hybrid connectivity using Terraform with Azure and Equinix for Microsoft Ignite 2025.

Context:
- Target audience: Ignite attendees who know or are curious about Microsoft ExpressRoute and Equinix Fabric.
- Goal: Show how to define hybrid connectivity as code using Terraform, NOT to build a full production environment.
- We want something small enough to explain in 5–10 minutes of code walkthrough.

Scenario:
- I am an enterprise customer connecting Azure workloads to on-prem via Microsoft ExpressRoute, using Equinix Fabric as the interconnection platform.
- Terraform must use BOTH:
  - `hashicorp/azurerm` provider for Azure
  - `equinix/equinix` provider for Equinix Fabric
- The demo should:
  - Create an Azure Resource Group, VNet, and a subnet.
  - Assume an existing ExpressRoute circuit in Azure and reference it by a placeholder service key or ID.
  - Use the Equinix provider to define a Fabric L2 connection targeting Azure (inspired by `equinix-labs/terraform-equinix-fabric-connection-azure`), with variables for:
    - Azure region
    - Equinix metro
    - Bandwidth
    - Environment name (e.g., `ignite-demo`)
    - Optional redundancy flag

Constraints and style:
- Terraform 1.x, HCL syntax.
- Use a simple file layout:
  - `main.tf` for providers and core resources.
  - `variables.tf` for input variables.
  - `outputs.tf` for a few useful IDs / names.
- Add short, clear comments explaining:
  - Which pieces are Azure.
  - Which pieces are Equinix Fabric.
  - Where ExpressRoute fits into the picture.
- Use placeholder values for secrets / IDs (e.g., `"<your_subscription_id>"`, `"<your_equinix_client_id>"`).
- Prefer readability and demo clarity over production completeness.

Tasks:
1. Generate initial scaffold for `main.tf`, `variables.tf`, and `outputs.tf`.
2. Refine and simplify the code so it’s easy to talk through on stage in 5–10 minutes.
3. Suggest a few `terraform output` values that will look good in a terminal during a booth demo (connection IDs, names, metro, bandwidth, etc.).
4. As I ask follow-up questions, help me tweak variables, add comments, and adjust the architecture to keep it clear and “demoable”.

Start by creating the three files (`main.tf`, `variables.tf`, `outputs.tf`) and then we’ll iterate.
