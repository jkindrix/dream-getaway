# Yes I Bought A Domain For This

A modular website presenting a luxury property in Costa Adeje, Tenerife.

## GitHub Pages Setup

To enable GitHub Pages:

1. Go to the repository on GitHub: [github.com/jkindrix/yesiboughtadomainforthis](https://github.com/jkindrix/yesiboughtadomainforthis)
2. Go to Settings → Pages
3. Under "Build and deployment", select:
   - Source: "Deploy from a branch"
   - Branch: main
   - Folder: / (root)
4. In the "Custom domain" section, enter: yesiboughtadomainforthis.com
5. Click "Save"

After saving, GitHub will verify your domain. You'll need to configure your domain with your registrar:

1. Set up an A record pointing to GitHub Pages IPs:
   - 185.199.108.153
   - 185.199.109.153
   - 185.199.110.153
   - 185.199.111.153

2. Or set up a CNAME record:
   - Name: @ or www
   - Value: jkindrix.github.io/yesiboughtadomainforthis

## Structure

The site is organized with a modular approach:

- **CSS**: Separate stylesheets for different concerns
- **JS**: Modular JavaScript files
- **Components**: HTML sections loaded dynamically

## Development

1. Clone the repository
2. Open `index.html` in a browser
3. Make changes to the relevant component files

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch.

Visit the live site: [yesiboughtadomainforthis.com](https://yesiboughtadomainforthis.com)