# MS Ignite Equinix Demo - Setup Instructions

## Critical Setup Requirements

When creating or using this Terraform demo project, ensure the following setup is complete:

### 1. Create terraform.tfvars with Dummy Data

Create a `terraform.tfvars` file with dummy data that will work with `terraform plan`. The dummy values should include:

- **Demo Azure subscription ID** in the correct GUID format (e.g., `12345678-1234-1234-1234-123456789abc`)
- **Demo Equinix Metal tokens and project IDs** in proper UUID format
- **Valid IP ranges** and configuration values (e.g., `192.168.1.0/30` for peering addresses)
- **All required variables populated** with appropriate default values

Example dummy values:
```hcl
azure_subscription_id = "12345678-1234-1234-1234-123456789abc"
metal_auth_token      = "dummy-metal-api-token-12345"
metal_project_id      = "12345678-90ab-cdef-1234-567890abcdef"
az_peering_primary_address   = "192.168.1.0/30"
az_peering_secondary_address = "192.168.2.0/30"
fabric_destination_metro_code = "SV"
```

### 2. Variables Declaration in variables.tf

**CRITICAL**: Make sure that the variables in `variables.tf` are:

- ✅ **Declared properly** with correct types (string, number, bool, list, map)
- ✅ **Match exactly** with the variable names used in `main.tf` and `outputs.tf`
- ✅ **Match exactly** with the values provided in `terraform.tfvars`
- ✅ Include appropriate descriptions for each variable
- ✅ Set sensible defaults where applicable (non-sensitive values)

**Every variable referenced in main.tf MUST be declared in variables.tf first.**

### 3. Validation Goal

The goal is for `terraform plan` to execute **with no errors** when done.

A user should be able to:
1. ✅ Clone the repository
2. ✅ Run `terraform init` successfully
3. ✅ Run `terraform plan` with no variable declaration errors
4. ✅ Later, copy their real values into `terraform.tfvars`
5. ✅ Execute with **no changes required** for any `.tf` files
6. ✅ Simply replace dummy credentials with actual Azure subscription IDs and Equinix credentials

### 4. Required File Structure

Ensure all files are present and correct:

```
.
├── main.tf                      # Provider and resource definitions
├── variables.tf                 # ALL variable declarations (must match main.tf references)
├── outputs.tf                   # Output definitions
├── terraform.tfvars             # Actual values with dummy data (DO NOT commit to git)
├── terraform.tfvars.example     # Template for users (safe to commit)
├── .gitignore                   # Must exclude terraform.tfvars
├── README.md                    # Main documentation
├── DEMO_GUIDE.md               # Step-by-step demo instructions
├── ARCHITECTURE.md             # Technical architecture details
└── prompts/                    # Copilot prompts for demo
```

### 5. Common Issues to Avoid

❌ **Don't:** Reference variables in `main.tf` without declaring them in `variables.tf`
❌ **Don't:** Provide values in `terraform.tfvars` for undeclared variables
❌ **Don't:** Use different variable names between files
❌ **Don't:** Commit `terraform.tfvars` with sensitive data to git

✅ **Do:** Declare all variables in `variables.tf` first
✅ **Do:** Ensure variable names match exactly across all files
✅ **Do:** Provide dummy data that allows `terraform plan` to succeed
✅ **Do:** Add `terraform.tfvars` to `.gitignore`

### 6. Testing Checklist

Before considering setup complete:

- [ ] `terraform init` runs without errors
- [ ] `terraform validate` passes
- [ ] `terraform plan` executes with no variable errors
- [ ] All variables in `main.tf` are declared in `variables.tf`
- [ ] All variables in `terraform.tfvars` are declared in `variables.tf`
- [ ] Dummy data is realistic enough for plan to succeed
- [ ] `.gitignore` excludes `terraform.tfvars`
- [ ] `terraform.tfvars.example` provides a template

### 7. For AI Assistants

When generating or updating this Terraform configuration:

1. **Always declare variables first** in `variables.tf` before using them in `main.tf`
2. **Ensure consistency** - variable names must match exactly across all files
3. **Provide complete dummy data** that allows validation without real credentials
4. **Test the configuration** with `terraform plan` before considering it complete
5. **Document all variables** with clear descriptions

---

## Quick Start After Setup

```bash
# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with your Azure subscription ID
# nano terraform.tfvars or code terraform.tfvars

# Initialize Terraform with provider upgrade
terraform init -upgrade

# Validate configuration
terraform validate

# Preview changes (should work with dummy data for subscription ID)
terraform plan

# When ready with real credentials and Equinix setup, apply
terraform apply
```
