# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website designed for DMI (DevOps Micro Internship) students. Supports two deployment strategies:
- **Simple**: Nginx on Ubuntu VM (learning-focused)
- **Production**: AWS S3 + CloudFront via Terraform (CDN, auto-scaling, IaC)

## Prerequisites

### For Nginx (Path A)
- SSH access to an Ubuntu VM
- `sudo` privileges for package installation
- Basic Linux/Nginx knowledge

### For AWS/Terraform (Path B)
- AWS account with valid credentials
- AWS CLI installed and configured: `aws configure`
- Terraform >= 1.5 installed
- IAM permissions for S3, CloudFront, CloudFront OAC

### For MCP Integration
- Node.js and npm (for GitHub MCP server used by `.mcp.json`)
- GitHub account and token (optional, only if using GitHub features via MCP)

## Architecture

### Frontend
- Pure HTML5 and CSS3
- No JavaScript (except vanilla for menu and scroll navigation)
- No build step
- No framework
- Mobile-first responsive design

### MCP Integration

The project includes a `.mcp.json` file that configures the Model Context Protocol (MCP) for GitHub integration:
- **GitHub MCP Server**: Provides access to GitHub APIs for issue tracking, PR management, and repository data
- **Purpose**: Enables Claude to read issues, comments, and repository context during development
- **Setup**: Requires Node.js/npm and a GitHub token (optional, only if accessing private repos or high API limits)

This is configured but optional — the project works fine without MCP if you don't need GitHub integration.

### Infrastructure (Choose One)
- **Simple**: Nginx on Ubuntu VM (single-server static hosting)
- **Production**: AWS S3 + CloudFront via Terraform (CDN-backed, auto-scaling, infrastructure-as-code)
  - S3: Private bucket, accessed only through CloudFront
  - CloudFront: Global CDN distribution, automatic HTTPS, caching optimized
  - Terraform: Infrastructure defined in code, version-controlled, repeatable deployments

## Commands

### Terraform Workflow
```bash
cd terraform
terraform init              # Initialize Terraform (first time only)
terraform plan             # Review changes before applying
terraform apply            # Apply infrastructure changes
```

### Custom Claude Skills
These skills are available in this project for common tasks:
- `/scaffold-terraform [aws-region] [project-name]` — Generate complete Terraform config for S3 + CloudFront (use if regenerating infrastructure)
- `/tf-plan` — Run `terraform plan` and analyze risks before applying
- `/tf-apply` — Apply Terraform changes with safety checks
- `/deploy` — Sync site files to S3 bucket and invalidate CloudFront cache (run after `terraform apply` or after updating content)

## Claude Skills & Agents

### Available Agents
When writing or auditing Terraform code, these specialized agents are available:
- **tf-writer** — Generates production-quality Terraform code for AWS infrastructure
- **security-auditor** — Audits Terraform for security issues (run proactively after generating Terraform files)
- **cost-optimizer** — Analyzes infrastructure for cost optimization opportunities

### Project Tools Directory
The `.claude/` directory contains:
- `.claude/skills/` — Custom reusable skills for Terraform, deployment, and scaffolding
- `.claude/agents/` — Specialized agent definitions for infrastructure work
- `.claude/agent-memory/` — Persistent memory from prior security and cost audits

## Conventions

- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety

Never put secrets in this file. No API keys, passwords, or AWS credentials.

## Project Structure

- **index.html** — Main portfolio landing page with hero, about, services, courses, books, contact sections
- **privacy.html** — Privacy policy page
- **terms.html** — Terms of service page
- **style.css** — All styling; uses CSS variables for colors, responsive design with media queries
- **images/** — Logo, profile photo, course thumbnails, book covers

## Customization Points

### Adding Your Ownership Proof (DMI Requirement)
Edit the footer in `index.html` (line 604) to add deployment details:
```html
<p><strong>Deployed by:</strong> Your Name | Group X | Week 1 | Date</p>
```
This must be visible in browser screenshots for DMI submission.

### Modifying Content
- **Hero/About**: Edit `index.html` lines 57-122 (change title, description, signature image)
- **Services**: Lines 126-226 (edit service cards)
- **Courses**: Lines 229-339 (update course links and thumbnails)
- **Books**: Lines 340-405 (update book details and Amazon links)
- **Contact**: Lines 485-546 (change email, phone, location)
- **Social links**: Lines 565-573 in footer

### Styling
- Color scheme controlled by CSS in `style.css`
- Responsive breakpoints for mobile (hamburger menu activates ~768px)
- Font Awesome 6.5.0 icons embedded via CDN

### Hero Section Design Requirements

- The hero section must use a dark gradient background.
- Primary gradient color: `#1a1a2e`
- Secondary gradient color: `#16213e`
- Maintain these colors as the source of truth for the hero section design.
- Do not replace the gradient background with a background image unless explicitly requested.

## Deployment

Choose your deployment path based on your needs:

### Path A: Simple Nginx on Ubuntu VM (DMI Standard)
**Best for**: DMI students, simple hosting, learning Linux/Nginx

1. SSH into Ubuntu VM and install Nginx:
```bash
ssh user@your-vm-ip
sudo apt update && sudo apt install nginx -y
```

2. Copy site files to Nginx:
```bash
sudo cp -r /path/to/project/* /var/www/html/
sudo systemctl start nginx
```

3. Access via browser: `http://<vm-public-ip>`

4. **Before submission**: Add ownership proof to footer (see CLAUDE.md > Customization Points)

### Path B: AWS S3 + CloudFront via Terraform (Production)
**Best for**: Production hosting, CDN distribution, infrastructure-as-code

**Prerequisites**: AWS credentials configured (`aws configure`)

**Steps**:

1. Initialize and review infrastructure:
```bash
cd terraform
terraform init
terraform plan
```

2. Deploy infrastructure (creates S3 bucket + CloudFront distribution):
```bash
terraform apply
```

3. Sync site files to S3 and invalidate cache:
```bash
/deploy                    # Or manually: cd terraform && terraform output -json
```

4. Get CloudFront URL from Terraform outputs:
```bash
terraform output cloudfront_domain_name
```

**Terraform Variables** (in `terraform/variables.tf`):
- `region` (default: `ap-south-1`) — AWS region for S3 and CloudFront
- `project_name` (default: `portfolio-site`) — Bucket name prefix
- `environment` (default: `production`) — Environment tag
- `domain_name` (optional) — Custom domain (requires DNS/ACM setup)

**Infrastructure Details**:
- S3 bucket: Private, all public access blocked, CloudFront-only access via Origin Access Control (OAC)
- CloudFront: Default certificate (CloudFront domain), caching optimized, 404→index.html redirect
- Security: Bucket policy restricts access to CloudFront distribution only

### Path C: Local Preview
Open `index.html` directly in a browser (no build/deploy needed, works for quick testing)

## Testing Before Deployment

Always validate locally before deploying:

1. **Open in browser**: Open `index.html` directly in a browser to verify:
   - All content displays correctly
   - Images load (check the images directory has all required files)
   - Links work (external links to courses, books, contact)
   - Hamburger menu works on mobile (tests JavaScript)

2. **Responsive design testing**: Test at these key breakpoints:
   - Desktop: 1200px+ (full layout)
   - Tablet: 900px (menu transitions)
   - Mobile: 768px and below (hamburger menu active)
   - Test at actual device sizes or use browser DevTools

3. **Verify content**: 
   - Ownership proof is visible in footer (DMI requirement)
   - No broken images or 404s in console
   - All social links point to correct profiles

4. **Accessibility check**:
   - Zoom to 200% and verify layout doesn't break
   - Test keyboard navigation (Tab through elements)
   - Check color contrast for readability

## Development Workflow

### Common Tasks

**Edit portfolio content**:
1. Update `index.html`, `privacy.html`, or `style.css`
2. Open `index.html` in browser to preview changes
3. Test responsive design at 900px, 768px, and 600px breakpoints
4. Commit changes with descriptive message

**Deploy content changes** (if using AWS Path B):
1. Make content edits
2. Run `/deploy` to sync files to S3 and invalidate CloudFront cache
3. Changes live within ~5 minutes (CloudFront propagation)

**Update infrastructure** (if using AWS Path B):
1. Edit `terraform/*.tf` files
2. Run `/tf-plan` to review changes
3. Review output for risks or breaking changes
4. Run `/tf-apply` to apply changes
5. Run `/deploy` to sync any content updates

**Audit infrastructure security**:
1. After running `/tf-apply`, ask the security-auditor agent to review Terraform files
2. Fix any identified issues
3. Re-run `/tf-plan` and `/tf-apply`

## Development Notes

- **No build process** — edit HTML/CSS directly, changes are instant
- **External dependencies**: Font Awesome icons via CDN, external course images from Udemy
- **Mobile-first responsive** — test at different viewport sizes
- **No JavaScript frameworks** — vanilla JavaScript for hamburger menu and scroll navigation
- **All links are external** except internal anchor links (`#sections`)
- **Terraform state** — stored locally in `terraform/.terraform/`; for team collaboration, use remote state (S3 backend)

## Terraform State Management

**Local state (current)**: Stored in `terraform/.terraform/terraform.tfstate` — fine for single-user or learning environments.

**Remote state (recommended for teams)**: 
- Uncomment the `backend "s3"` block in `terraform/backend.tf` after creating a state bucket
- Follow the 6-step setup documented in that file
- This prevents state conflicts when multiple people run `terraform apply`
- **Critical**: Do NOT commit `terraform.tfstate` to git (it contains sensitive data)

**State best practices**:
- Never manually edit state files
- Always run `terraform plan` before `terraform apply`
- Use `terraform state lock` if available for your backend (S3 + DynamoDB)

## Git & Branching

Standard workflow:
1. Edit files (HTML, CSS, images)
2. Test locally in browser
3. Commit changes with clear message (e.g., "Update courses section with new Udemy links")
4. Push to main (or feature branch if coordinating with others)

**Important**: Before deploying to production, ensure the footer ownership proof is added (DMI requirement).

**Git safety**:
- `.terraform/` and `.terraform.lock.hcl` are in `.gitignore` (commit state management separately)
- `terraform.tfstate*` should never be committed — use remote state for collaboration

## Troubleshooting

### Terraform Issues

**"Error: Invalid legacy provider address"**
- Run `terraform init` to download correct provider versions
- Check `terraform/providers.tf` for required version constraints

**"Error: Access Denied" when applying**
- Verify AWS credentials: `aws sts get-caller-identity`
- Check IAM permissions for S3, CloudFront, and related services
- Ensure AWS region matches `terraform/variables.tf` region setting

**"Error: InvalidUserID.Malformed" for bucket policy**
- CloudFront OAC setup issue — run `terraform destroy` and `terraform apply` again
- May occur on first deployment if CloudFront ARN not yet available

**CloudFront shows 403 Forbidden**
- Verify S3 bucket exists and has content (check S3 console)
- Wait 5-10 minutes for CloudFront cache invalidation to propagate
- Check CloudFront Origin Access Control configuration in AWS console

### Deployment Issues (Nginx Path A)

**"Permission denied" when copying files**
- Use `sudo` prefix: `sudo cp -r /path/to/project/* /var/www/html/`
- Verify you have sudo access: `sudo -v`

**Nginx not starting**
- Check syntax: `sudo nginx -t`
- Check logs: `sudo journalctl -u nginx`
- Verify port 80 is available: `sudo netstat -tuln | grep :80`

**Website shows 404 on refresh**
- For Nginx: Add `try_files $uri $uri/ /index.html;` to nginx.conf (CloudFront already has this configured)

### Local Testing Issues

**Images not loading when opening index.html directly**
- Browser security blocks relative file paths — use a local server instead
- Python: `python -m http.server 8000` then visit `http://localhost:8000`
- Node: `npx http-server` 
- Or deploy and test via CloudFront/Nginx

**Ownership proof not showing in footer**
- Verify edit was saved to `index.html` around line 604
- Check browser DevTools to confirm footer element contains text
- No caching issues locally, but CloudFront may cache old version (run `/deploy` to invalidate)

### Common Gotchas

- **Terraform plan shows changes every time**: Likely an issue with AWS account ID or region mismatch. Run `terraform init` again.
- **CloudFront shows old content after updates**: CloudFront caches aggressively. Run `/deploy` to invalidate cache, or wait 24 hours (TTL varies by object type).
- **404 errors on portfolio pages**: This is expected — pages are single-page portfolio, not a multi-page site. Use anchor links or refresh workaround.
