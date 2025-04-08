# Yes I Bought A Domain For This

A multi-site static web hosting platform under a single domain.

[![Deploy to GitHub Pages](https://github.com/jkindrix/yesiboughtadomainforthis/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/jkindrix/yesiboughtadomainforthis/actions/workflows/deploy-pages.yml)

## Overview

This repository hosts multiple static websites under the yesiboughtadomainforthis.com domain. Each site is contained in its own folder within the `sites` directory, allowing for independent development and maintenance.

## Live Site

Visit the live sites:
- [Homepage](https://yesiboughtadomainforthis.com)
- [Costa Adeje Property](https://yesiboughtadomainforthis.com/costa-adeje)

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
│   └── template/         # Template for additional sites
│
├── .github/workflows/    # GitHub Actions workflows
├── index.html            # Main landing page
├── 404.html              # Custom 404 page
├── CNAME                 # Domain configuration
├── robots.txt            # SEO configuration
├── sitemap.xml           # Site structure for crawlers
└── README.md             # This file
```

## Adding a New Site

1. Duplicate the `sites/template` folder and rename it to your site name
2. Update the router configuration in `common/js/site-router.js`
3. Add a card for your site on the main landing page
4. Update the sitemap.xml to include your new site

## Development

1. Clone the repository
2. Make changes to the relevant component files
3. Test locally by opening `index.html` in a browser

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch via GitHub Actions.

## Setup

For detailed setup instructions, see [SETUP.md](SETUP.md).

## Security

Please report any security issues to jkindrix@gmail.com.

## License

This project is licensed under the MIT License - see the LICENSE file for details.