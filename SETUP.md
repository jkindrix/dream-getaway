# Multi-Site Platform Setup Guide

This document outlines the full process of setting up the multi-site platform for `yesiboughtadomainforthis.com`. The commands below show the exact steps taken to create the repository structure and configure GitHub Pages.

## Initial Repository Setup

```bash
# Initialize git repository
git init

# Create basic file structure
mkdir -p css js components
```

## Creating the Original Website

```bash
# Create CSS files
cat > css/reset.css << 'EOF'
/* Reset and base styles */
html {
    overflow-x: initial !important;
    /* ... more CSS content ... */
}
EOF

# Create JS files
cat > js/outline.js << 'EOF'
(function () { 
    /* ... JavaScript content ... */
})();
EOF

# Create index.html
cat > index.html << 'EOF'
<!doctype html>
<html>
    <!-- ... HTML content ... -->
</html>
EOF

# Initial commit
git add .
git commit -m "Initial commit with modular website structure"
```

## Creating and Connecting to GitHub

```bash
# Create GitHub repository
gh repo create dream-getaway --public --source=. --remote=origin

# Push to GitHub
git push -u origin main

# Rename repository to match domain
gh repo rename yesiboughtadomainforthis --yes
```

## Restructuring for Multi-Site Platform

```bash
# Create directory structure for multiple sites
mkdir -p sites/costa-adeje common/{css,js}

# Move existing site to costa-adeje folder
mv css components js sites/costa-adeje/
mv index.html sites/costa-adeje/

# Create site router for navigation between sites
cat > common/js/site-router.js << 'EOF'
/**
 * Site Router - Handles redirects based on URL patterns
 */
(function() {
    // Configuration for different sites
    const siteConfig = {
        "costa-adeje": "sites/costa-adeje/index.html",
    };
    // Default site to show if no path matches
    const defaultSite = "costa-adeje";
    
    /* ... more JavaScript content ... */
})();
EOF

# Create main CSS
cat > common/css/main.css << 'EOF'
/* Main styles for the multi-site root page */
:root {
    --bg-color: #191919;
    /* ... more CSS content ... */
}
EOF

# Create main index page
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
    <!-- ... HTML content ... -->
</html>
EOF

# Create site template
mkdir -p sites/template/css
cat > sites/template/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
    <!-- ... HTML content ... -->
</html>
EOF

cat > sites/template/css/styles.css << 'EOF'
/* Basic styles for new site template */
:root {
    /* ... CSS content ... */
}
EOF

# Create 404 page
cat > 404.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
    <!-- ... HTML content ... -->
</html>
EOF

# Commit restructured repository
git add .
git commit -m "feat: restructure repo for multi-site hosting"
git push
```

## Configuring GitHub Pages via API

Since GitHub CLI doesn't have native commands for GitHub Pages, we use the `gh api` command to interact with GitHub's REST API endpoints for Pages configuration.

### Creating the GitHub Pages Site

```bash
# Create the GitHub Pages site with main branch as source
echo '{"source": {"branch": "main"}}' | gh api --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  /repos/jkindrix/yesiboughtadomainforthis/pages --input -
```

This command makes a POST request to the `/repos/{owner}/{repo}/pages` endpoint to enable GitHub Pages for the repository. The JSON payload specifies that the source branch is `main`.

### Setting a Custom Domain

```bash
# Set custom domain
echo '{"cname": "yesiboughtadomainforthis.com"}' | gh api --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  /repos/jkindrix/yesiboughtadomainforthis/pages --input -
```

This command makes a PUT request to update the Pages configuration with your custom domain. The `cname` field specifies the domain name to use.

### Checking GitHub Pages Status

```bash
# Check GitHub Pages status
gh api /repos/jkindrix/yesiboughtadomainforthis/pages
```

This command makes a GET request to retrieve the current GitHub Pages configuration and build status.

### Understanding the API Response

The response includes:
- `status`: The current build status (e.g., "building")
- `cname`: Your custom domain
- `source`: The branch and path being used as the source
- `https_enforced`: Whether HTTPS enforcement is enabled

## DNS Configuration (To Be Done With Your Domain Registrar)

You need to configure your domain's DNS settings:

1. Add A records pointing to GitHub Pages IP addresses:
   ```
   185.199.108.153
   185.199.109.153
   185.199.110.153
   185.199.111.153
   ```

2. Or add a CNAME record:
   - Name: www
   - Value: jkindrix.github.io

## Enabling HTTPS (After DNS Verification)

After DNS verification is complete (typically 24 hours):

```bash
# Enable HTTPS enforcement
echo '{"https_enforced": true}' | gh api --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  /repos/jkindrix/yesiboughtadomainforthis/pages --input -
```

This command makes a PUT request to update the GitHub Pages configuration with HTTPS enforcement enabled. GitHub will first validate that it has successfully provisioned an SSL certificate for your domain before this setting can be applied.

### Troubleshooting HTTPS Enforcement

If you get an error like `"The certificate does not exist yet"`, it means:
1. DNS verification is still pending
2. GitHub hasn't yet provisioned an SSL certificate for your domain
3. You need to wait longer (typically up to 24 hours) before retrying

You can check the verification status with:

```bash
# Check GitHub Pages health
gh api /repos/jkindrix/yesiboughtadomainforthis/pages/health
```

## Adding New Sites

To add a new site to the platform:

1. Duplicate the template folder:
   ```bash
   cp -r sites/template sites/new-site-name
   ```

2. Update the router configuration in `common/js/site-router.js`:
   ```javascript
   const siteConfig = {
       "costa-adeje": "sites/costa-adeje/index.html",
       "new-site-name": "sites/new-site-name/index.html",
   };
   ```

3. Add a card to the main landing page in `index.html`

4. Commit and push your changes:
   ```bash
   git add .
   git commit -m "feat: add new site"
   git push
   ```