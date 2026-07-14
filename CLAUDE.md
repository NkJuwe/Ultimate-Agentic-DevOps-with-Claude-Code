# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

## Architecture

- Pure HTML5 and CSS3
- No JavaScript
- No build step
- No framework

## Commands

- terraform init
- terraform plan
- terraform apply

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

### Option 1: Nginx on Ubuntu VM (DMI Standard)
```bash
# SSH into Ubuntu VM
ssh user@your-vm-ip

# Install Nginx
sudo apt update && sudo apt install nginx -y

# Copy site files
sudo cp -r /path/to/project/* /var/www/html/

# Start Nginx
sudo systemctl start nginx
```

Access via `http://<vm-public-ip>`

### Option 2: Docker
```bash
# Build and run
docker build -t portfolio . -f- <<EOF
FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
EOF

docker run -d -p 80:80 portfolio
```

### Option 3: Local Preview
Open `index.html` directly in a browser (works fine for static HTML/CSS).

## Development Notes

- **No build process** — edit HTML/CSS directly, changes are instant
- **External dependencies**: Font Awesome icons via CDN, external course images from Udemy
- **Mobile-first responsive** — test at different viewport sizes
- **No JavaScript frameworks** — vanilla JavaScript for hamburger menu and scroll navigation
- **All links are external** except internal anchor links (`#sections`)

## Git & Branching

Standard workflow:
1. Edit files (HTML, CSS, images)
2. Test locally in browser
3. Commit changes with clear message (e.g., "Update courses section with new Udemy links")
4. Push to main (or feature branch if coordinating with others)

**Important**: Before deploying to production, ensure the footer ownership proof is added (DMI requirement).
