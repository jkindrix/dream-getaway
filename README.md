# Yes I Bought A Domain For This

A multi-site static web hosting platform under a single domain.

## Overview

This repository hosts multiple static websites under the yesiboughtadomainforthis.com domain. Each site is contained in its own folder within the `sites` directory, allowing for independent development and maintenance.

## Structure

```
yesiboughtadomainforthis/
├── common/               # Shared resources across sites
│   ├── css/              # Common CSS
│   └── js/               # Common JavaScript (including router)
│
├── sites/                # Individual websites
│   ├── costa-adeje/      # Costa Adeje Property site
│   │   ├── components/   # HTML components
│   │   ├── css/          # Site-specific styles
│   │   ├── js/           # Site-specific scripts
│   │   └── index.html    # Entry point
│   │
│   └── [site-name]/      # Template for additional sites
│
├── index.html            # Main landing page
├── CNAME                 # Domain configuration
└── README.md             # This file
```

## Adding a New Site

1. Create a new folder in the `sites` directory
2. Add your site files (HTML, CSS, JS, etc.)
3. Update the router configuration in `common/js/site-router.js`
4. Add a card to the main landing page in `index.html`

## Available Sites

- [Costa Adeje Property](https://yesiboughtadomainforthis.com/costa-adeje) - A luxury property showcase

## Domain Setup

The repository is configured for GitHub Pages with a custom domain:

1. DNS Configuration:
   - Set up A records pointing to GitHub Pages IPs:
     - 185.199.108.153
     - 185.199.109.153
     - 185.199.110.153
     - 185.199.111.153
   - Or set up a CNAME record:
     - Name: @ or www
     - Value: jkindrix.github.io

2. GitHub Pages Configuration:
   - Repository Settings → Pages
   - Custom domain: yesiboughtadomainforthis.com
   - Source: Deploy from a branch (main)