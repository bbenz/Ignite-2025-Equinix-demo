You are a senior cloud network architect preparing a 15–30 minute booth demo for Microsoft Ignite 2025.

Audience:
- Technical Ignite attendees (architects, infra engineers, DevOps, network engineers).
- They know or are curious about Microsoft ExpressRoute and Equinix Fabric, but may not be Terraform experts.
- They care about hybrid connectivity patterns, repeatability, and real-world operational details.

Goal of this request:
1. Generate a SMALL, CLEAR Terraform example that shows how to:
   - Use the `azurerm` and `equinix` providers together.
   - Provision Azure infrastructure needed for ExpressRoute.
   - Provision Equinix Fabric L2 connectivity toward Azure.
   - Illustrate a realistic but demo-friendly hybrid connectivity pattern.
2. Generate a concise presentation outline (for a 15–30 minute Equinix booth demo at Microsoft Ignite 2025) that explains what the Terraform is doing and why it matters.

Use the following public projects as inspiration and source patterns (don’t copy them verbatim; simplify and adapt for a live demo):
- Equinix Labs module for Azure Fabric connections:
  - `equinix-labs/terraform-equinix-fabric-connection-azure`
- Equinix Terraform provider:
  - `equinix/terraform-provider-equinix`
- AzureRM Terraform provider:
  - `hashicorp/terraform-provider-azurerm`

ASSUMED DEMO SCENARIO (you can refine it, but keep it simple):
- We are an enterprise customer connecting workloads in an Azure VNet to on-premises environments via Microsoft ExpressRoute, using Equinix Fabric as the interconnection platform.
- The demo Terraform should:
  - Create (or assume) an Azure Resource Group, VNet, and subnet(s).
  - Configure ExpressRoute-facing resources on the Azure side (you can assume the circuit itself exists, or show how it would be referenced).
  - Use the Equinix provider to define a Fabric L2 connection targeting Azure (using patterns similar to the Equinix Labs Azure Fabric examples).
  - Show how parameters like location/metro, bandwidth, and redundancy are captured as variables.
- The emphasis is on “infrastructure as code for hybrid connectivity” rather than building full application workloads.

CONSTRAINTS AND STYLE:
- Target modern Terraform (Terraform 1.x) and recent `azurerm` and `equinix` providers.
- Use HCL, not JSON.
- Keep the example small enough that a presenter can walk through the key pieces in 5–10 minutes.
- Use clear comments that help a booth visitor understand:
  - which blocks represent Azure,
  - which blocks represent Equinix Fabric,
  - how they relate to ExpressRoute.
- Use placeholder values where appropriate (e.g., subscription ID, Equinix account info, ExpressRoute service key), but show realistic examples.
- Show a simple file layout:
  - `main.tf` with providers and main resources
  - `variables.tf` with key inputs (metros/locations, bandwidth, redundancy, subscription IDs, etc.)
  - `outputs.tf` with a few useful outputs (e.g., connection IDs, circuit names).
- Prefer readability over completeness: this is for a live booth demo, not production.

PART 1 – TERRAFORM CODE

1. Briefly describe the scenario in 2–3 sentences, in plain language, so it can be reused in slides.
2. Provide the Terraform code:
   - `providers` configuration for:
     - `azurerm` (e.g., using CLI or managed identity auth)
     - `equinix` (point out where API keys or tokens would be configured)
   - Core Azure resources (simplified):
     - Resource Group
     - VNet + subnet(s)
     - Any ExpressRoute-relevant resources you feel are appropriate to show in a demo (e.g., circuit reference, gateway, or peering configuration — you may assume an existing circuit if that keeps code shorter).
   - Core Equinix resources:
     - Equinix Fabric L2 connection resource(s) that model connectivity from Equinix to Azure (inspired by `terraform-equinix-fabric-connection-azure`).
     - Optionally, show how redundancy works (e.g., primary/secondary connection).
   - Use variables for:
     - Azure region, Equinix metro(s)
     - Bandwidth
     - Redundancy on/off
     - Environment naming (e.g., `env = "ignite-demo"`).
   - Include a few `outputs` that would be useful to show after `terraform apply` at the booth.

3. Make sure the code is syntactically valid HCL and looks like something that would run with minor adjustments to credentials and IDs.

PART 2 – IGNITE 2025 BOOTH DEMO OUTLINE (15–30 MINUTES)

Create a concise outline for a 15–30 minute booth demo using this Terraform scenario, tailored for Microsoft Ignite 2025 and Equinix:

1. Title and 1–2 sentence abstract
   - Emphasize hybrid connectivity, ExpressRoute, Equinix Fabric, and Terraform.
   - Example framing: “From manual network tickets to repeatable code.”

2. Audience and prerequisites
   - Who this is for (ExpressRoute / hybrid cloud / network curious).
   - What they should already roughly know (Azure, VNet, basic networking) and what you’ll explain from scratch (Terraform basics, Equinix provider concepts).

3. Demo flow (high-level agenda)
   - 3–5 high-level sections with approximate time boxes (for both 15 and 30 minute versions).
   - Example flow:
     - Problem / pattern: hybrid connectivity and why ExpressRoute + Equinix.
     - Architecture overview: Azure side, Equinix side, ExpressRoute in the middle.
     - Walkthrough of Terraform code (key files only).
     - `terraform plan/apply` or dry-run walkthrough (what would change).
     - Wrap-up: how to extend this to more complex topologies and automation.

4. Slide & talking points outline
   - List 6–8 slides with bullet-point talking points, for example:
     - Slide 1 – Problem statement: Why hybrid connectivity is still hard.
     - Slide 2 – Architecture diagram: Azure, ExpressRoute, Equinix Fabric.
     - Slide 3 – Terraform providers: `azurerm` + `equinix`, what each controls.
     - Slide 4 – Walkthrough of key Terraform snippets.
     - Slide 5 – Operational benefits: repeatability, drift detection, tear-down.
     - Slide 6 – Where to go next: docs, sample repos, IaC patterns.
   - For each slide, give:
     - 2–4 bullets of what to say.
     - Which snippet or concept from the Terraform code to highlight (if any).

5. Live demo script (short)
   - Provide a short, presenter-friendly script outline:
     - Key phrases to use when introducing the scenario.
     - What to type or show in the terminal/VS Code.
     - Where to pause for questions or to hand out QR codes/links.

6. Call to action
   - Suggest concrete CTAs for booth visitors:
     - Try a sample repo.
     - Explore Equinix Fabric + Azure docs.
     - Talk to Equinix + Microsoft architects about their own patterns.

Deliverables:
- A complete Terraform example (`main.tf`, `variables.tf`, `outputs.tf`) formatted in Markdown code blocks.
- A clear, numbered presentation outline that I can drop into PowerPoint for a 15–30 minute booth demo.
- Keep the tone professional, direct, and focused on practical value for Ignite attendees.
