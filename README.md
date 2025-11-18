# Hybrid Connectivity as Code: ExpressRoute + Equinix Fabric with Terraform and Copilot

## Overview

This demo showcases how to define hybrid network connectivity as code using Terraform, Microsoft ExpressRoute, and Equinix Fabric. We'll "vibe code" in VS Code with GitHub Copilot Agent Mode to build and adjust a repeatable pattern that connects Azure VNets to on-prem environments through Equinix.

## Demo Information

- **Event**: Microsoft Ignite 2025
- **Duration**: 15-30 minutes
- **Format**: Live coding demonstration with GitHub Copilot

## What You'll Learn

- How to treat hybrid connectivity as code instead of manual tickets
- Using Terraform to configure ExpressRoute + Equinix Fabric
- Leveraging GitHub Copilot Agent Mode for infrastructure as code
- Creating repeatable patterns for private connectivity

## Repository Structure

```
.
├── main.tf              # Core Terraform resources
├── variables.tf         # Configuration variables
├── outputs.tf           # Terraform outputs
├── prompts/             # Copilot prompts for the demo
├── README.md            # This file
├── DEMO_GUIDE.md        # Step-by-step demo walkthrough
└── ARCHITECTURE.md      # Architecture overview and patterns
```

## Quick Start

1. **Prerequisites**
   - Azure subscription
   - Equinix Fabric account
   - Terraform installed
   - VS Code with GitHub Copilot

2. **Setup**
   ```bash
   # Clone and navigate to the repository
   cd equinix-demo

   # Initialize Terraform
   terraform init

   # If there are compatibility errors:
   terraform init -upgrade

   # Review the plan
   terraform plan

   # Apply the configuration
   terraform apply
   ```

3. **Try the Copilot Demo**
   - Open VS Code
   - Load the Copilot prompt from `prompts/`
   - Follow the demo guide in `DEMO_GUIDE.md`

## Key Features

- **Infrastructure as Code**: All connectivity defined in Terraform
- **Repeatable Patterns**: Reuse across regions and environments
- **AI-Assisted Development**: Use Copilot to generate and refine configurations
- **Auditability**: Track all changes through version control
- **CI/CD Ready**: Integrate with pipelines and approval workflows

## Audience

This demo is designed for:
- Cloud architects
- Infrastructure engineers
- Network engineers
- DevOps professionals
- Anyone using or considering ExpressRoute and/or Equinix Fabric

## The Problem We're Solving

Traditional hybrid connectivity approaches suffer from:
- Manual tickets and spreadsheets
- One-off configurations that are hard to repeat
- Difficult auditing and compliance tracking
- Slow teardown and modification processes
- Disconnected tooling between cloud and on-prem teams

**Our Solution**: Treat network changes like code changes with Terraform and AI assistance.

## Architecture

The demo implements a pattern connecting:
- **Azure VNet** with ExpressRoute gateway
- **ExpressRoute circuit** as the connectivity contract
- **Equinix Fabric** L2 connection from metro to circuit

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture diagrams and explanations.

## Demo Walkthrough

For a complete step-by-step guide to running the demo, see [DEMO_GUIDE.md](DEMO_GUIDE.md).

## Extending the Pattern

This basic pattern can be extended to:
- Multiple VNets or ExpressRoute circuits
- Multiple regions with redundancy
- Complex hub-and-spoke topologies
- Integration with CI/CD pipelines
- Custom modules for your organization

## Resources

### Official Documentation
- [Azure ExpressRoute Documentation](https://docs.microsoft.com/azure/expressroute/) - Complete guide to Azure ExpressRoute setup and configuration
- [Equinix Fabric Documentation](https://docs.equinix.com/fabric/) - Equinix Fabric product documentation and API references

### Terraform Providers
- [Terraform azurerm Provider Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) - Official Terraform registry documentation for Azure resources
- [Terraform Equinix Provider Registry](https://registry.terraform.io/providers/equinix/equinix/latest) - Official Terraform registry documentation for Equinix resources

### Sample Code & Provider Source
- [Equinix Labs: Terraform Fabric Connection to Azure](https://github.com/equinix-labs/terraform-equinix-fabric-connection-azure) - Pre-built Terraform module for Azure ExpressRoute + Equinix Fabric connectivity patterns
- [Terraform Equinix Provider Source](https://github.com/equinix/terraform-provider-equinix) - Source code and examples for the Equinix Terraform provider
- [Terraform Azure Provider Source](https://github.com/hashicorp/terraform-provider-azurerm/tree/main) - Source code and examples for the Azure Terraform provider

## Get Involved

- Try this pattern in your sandbox subscription
- Customize for your specific metros and bandwidth requirements
- Share feedback and improvements

## Next Steps

1. Review the [architecture documentation](ARCHITECTURE.md)
2. Follow the [demo guide](DEMO_GUIDE.md)
3. Experiment with the Copilot prompts
4. Adapt the pattern for your organization's needs

---

**Questions?** Talk to us about:
- Migrating existing manual ExpressRoute configs into Terraform
- Adding more regions/topologies using Equinix Fabric
- Integrating with your existing infrastructure patterns
