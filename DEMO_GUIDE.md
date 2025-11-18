# Demo Guide: Live Coding with Copilot

This guide provides a step-by-step walkthrough for presenting the Ignite 2025 Equinix booth demo.

## Demo Duration Options

- **15-minute version**: Cover sections 1-3 with abbreviated live coding
- **30-minute version**: Full walkthrough with extended Q&A

## Pre-Demo Checklist

- [ ] VS Code open with the project loaded
- [ ] GitHub Copilot Agent Mode enabled
- [ ] Terminal ready for Terraform commands
- [ ] Slide deck loaded (if using)
- [ ] Demo environment authenticated (Azure + Equinix)
- [ ] Backup plan ready (pre-recorded plan output)

---

## Section 1: Introduction (1-2 minutes)

### Script

> "Hi, I'm [name] from [team]. In the next 15-20 minutes, we'll take something that usually requires tickets and manual change windows—ExpressRoute + Equinix Fabric connectivity—and treat it like code."
>
> "We'll use Terraform plus GitHub Copilot Agent Mode in VS Code, so you can see how natural-language prompts become repeatable hybrid connectivity."

### Key Points
- Hybrid connectivity is traditionally slow and manual
- We're making it repeatable and code-driven
- AI assists in generating and understanding the configuration

---

## Section 2: The Problem (2-3 minutes)

### Talking Points

**Current state of hybrid connectivity:**
- Manual tickets and spreadsheets
- One-off configurations
- Hard to repeat, audit, or tear down
- Cloud and on-prem teams using different tools

**The vision:**
> "We want network changes to look like code changes."

### Benefits of IaC Approach
- Version control and auditability
- Peer review via pull requests
- Automated testing and validation
- Repeatable across environments

---

## Section 3: Architecture Overview (2-3 minutes)

### Script

> "On the Azure side, we've got a VNet and an ExpressRoute gateway."
>
> "On the Equinix side, we have Fabric, which gives us L2 connectivity into that ExpressRoute circuit."
>
> "The Terraform code wires these together, capturing metro, bandwidth, redundancy as variables."

### Components to Highlight

1. **Azure Side**
   - Virtual Network (VNet)
   - ExpressRoute Gateway
   - ExpressRoute Circuit

2. **Equinix Side**
   - Fabric L2 Connection
   - Metro location
   - Bandwidth configuration

3. **The Contract**
   - ExpressRoute links both sides
   - Service key for authentication
   - VLAN tagging for isolation

### Visual Aid
Draw or show diagram with the three components and their relationships.

---

## Section 4: Show the Code (1-2 minutes)

### Script

> "Here's main.tf with our providers and core resources."
>
> "variables.tf captures our Ignite demo settings: region, metro, bandwidth, env name."
>
> "outputs.tf gives us a clean summary after we run Terraform."

### Files to Show

**main.tf**
- Provider configurations (azurerm + equinix)
- Resource definitions
- Comment on how resources link together

**variables.tf**
- Environment name
- Azure region
- Equinix metro
- Bandwidth settings
- Redundancy flags

**outputs.tf**
- ExpressRoute circuit ID
- Service key
- Connection status
- VNet information

---

## Section 5: Live "Vibe Coding" with Copilot (5-7 minutes)

This is the centerpiece of the demo. Be conversational and show how Copilot assists your workflow.

### Setup
1. Open VS Code
2. Ensure Copilot Agent Mode is active
3. Have the prompt file ready in `prompts/`

### Interaction 1: Add Redundancy

**What to do:**
```
Prompt: "Copilot, add a secondary Fabric connection when fabric_enable_redundancy 
is true, mirroring the primary connection."
```

**What to show:**
- Copilot generates the conditional resource
- The secondary connection mirrors configuration
- Variable controls the behavior

**Script:**
> "Watch how Copilot understands the pattern and creates a secondary connection with the same settings."

### Interaction 2: Add Documentation

**What to do:**
```
Prompt: "Copilot, add comments explaining how this Equinix connection attaches 
to an existing ExpressRoute circuit."
```

**What to show:**
- Copilot adds inline comments
- Explains the service key relationship
- Documents the connection flow

**Script:**
> "Good documentation is critical. Let's have Copilot explain what's happening for the next person who reads this code."

### Interaction 3: Modify Configuration

**What to do:**
```
Prompt: "Let's bump the bandwidth to 500 Mbps and switch the metro to DC."
```

**What to show:**
- Copilot updates the variable values
- May suggest related changes
- Maintains consistency across resources

**Script:**
> "Need to change the configuration? Just ask. Copilot updates the variables and keeps everything in sync."

### Tips for Live Coding
- **Keep it conversational**: Talk to Copilot like a colleague
- **Show mistakes**: If Copilot gets something wrong, correct it naturally
- **Explain the value**: Highlight how this speeds up development
- **Stay focused**: Don't get lost in edge cases

---

## Section 6: Terraform Plan (3-5 minutes)

### Script

> "You can see the plan includes our ExpressRoute circuit, VNet gateway, and Fabric connections."
>
> "This is the exact change set we could wire into a pipeline with approvals."

### What to Do

```bash
# Run terraform plan (may take a minute for gateway resources)
terraform plan
```

### What to Highlight

**In the plan output:**
- Resources to be created (green +)
- Resource dependencies
- Key attributes:
  - VNet address space
  - ExpressRoute circuit bandwidth
  - Fabric connection metro
  - Service key generation

**Operational benefits:**
- Exact preview of changes
- No surprises in production
- Easy to peer review
- Audit trail for compliance

### Alternative: Pre-recorded Plan

If running live `terraform plan` is risky or slow:
- Show a pre-recorded plan output
- Walk through the key sections
- Explain what would happen during apply

---

## Section 7: Extending the Pattern (2-3 minutes)

### Script

> "This is a foundational pattern. Let's talk about how you'd extend it."

### Extension Ideas

**Multiple VNets**
- Add more virtual networks
- Use the same ExpressRoute circuit
- Hub-and-spoke topology

**Multiple Regions**
- Deploy in secondary Azure regions
- Equinix metro for each region
- Global redundancy

**CI/CD Integration**
```
1. Developer updates variables.tf
2. Pull request created
3. Automated terraform plan
4. Peer review
5. Approved → pipeline runs apply
```

**Terraform Modules**
- Package this pattern as a module
- Reuse across your organization
- Version and distribute internally

### Resources to Mention
- Equinix Labs modules
- Azure reference architectures
- Terraform Registry

---

## Section 8: Wrap-Up & Call to Action (2-3 minutes)

### Key Takeaways

> "The takeaway: ExpressRoute + Equinix Fabric can be encoded as Terraform, co-authored with AI, and reused wherever you need private connectivity."

### Calls to Action

1. **Try it yourself**
   - Scan QR code for the repo
   - Use your own metros and bandwidth
   - Experiment in a sandbox subscription

2. **Talk to us about**
   - Migrating existing ExpressRoute configs
   - Multi-region topologies
   - Your hybrid network challenges

3. **Learn more**
   - Documentation links
   - Sample repositories
   - Community resources

### Closing Script

> "Scan the QR code, grab the sample, and try this pattern with your own metros and bandwidth. We're here to answer questions about your specific hybrid connectivity needs."

---

## Troubleshooting

### If Copilot Isn't Responding
- Check Agent Mode is enabled
- Restart VS Code
- Fall back to manual code edits with explanation

### If Terraform Plan Fails
- Show pre-recorded plan output
- Explain what the plan would show
- Focus on the workflow and benefits

### If Time Runs Short
- Skip the live coding refinements
- Show the final code
- Focus on architecture and benefits

### If Asked About Costs
- ExpressRoute: Based on bandwidth and data transfer
- Equinix Fabric: Based on connection speed and metro
- Recommend starting with lower bandwidth for testing

---

## Post-Demo Follow-Up

### For Interested Attendees
- Share repo link
- Exchange contact info
- Schedule follow-up calls
- Collect feedback

### Internal Notes
- What questions came up most?
- Where did people get excited?
- What should we emphasize next time?
- Technical issues encountered?

---

## Demo Variations

### 15-Minute Speed Run
1. Intro + Problem (2 min)
2. Architecture (2 min)
3. Quick code tour (1 min)
4. ONE Copilot interaction (4 min)
5. Show plan output (3 min)
6. Wrap-up (3 min)

### 30-Minute Deep Dive
- Use all sections at full length
- Add extra Copilot interactions
- Live Q&A during demo
- Show terraform apply (if safe)
- Discuss cost optimization

---

## Backup Plans

### Plan A: Full Live Demo
Everything works, live coding with Copilot, live terraform plan.

### Plan B: Hybrid
Pre-recorded plan output, but live Copilot coding.

### Plan C: Presentation Mode
Show completed code, walk through with explanations, focus on patterns and benefits.

---

**Remember**: The goal is to show how AI and IaC make hybrid connectivity approachable, repeatable, and maintainable. Have fun with it!
