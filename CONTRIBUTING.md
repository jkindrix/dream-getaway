# Contributing to Yes I Bought A Domain For This

Thank you for considering contributing to this project! Your help is essential for keeping it robust and community-driven.

This document outlines the process for contributing to the multi-site platform and the standards we maintain.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/yesiboughtadomainforthis.git`
3. Create a branch: `git checkout -b feature/your-feature-name`

## Development Process

### Local Setup

1. Navigate to the repository root
2. No build process is required - simply open `index.html` in a browser

### Directory Structure

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
├── scripts/              # Utility scripts
├── .github/              # GitHub configuration
└── [config files]        # Configuration files
```

### Coding Standards

We adhere to strict coding standards:

#### HTML
- Validate against HTML5 standards
- Use semantic HTML elements
- Include proper ARIA attributes for accessibility
- Implement proper document structure with appropriate heading levels

#### CSS
- Follow BEM (Block, Element, Modifier) naming convention
- Maintain proper specificity
- Use CSS variables for theming
- Implement media queries for responsive design

#### JavaScript
- Follow ESLint rules defined in `.eslintrc`
- Use ES6+ features with appropriate fallbacks
- Maintain functional programming patterns where appropriate
- Document complex functions with JSDoc comments

#### General
- Maintain 100/100 Lighthouse scores for:
  - Performance
  - Accessibility
  - Best Practices
  - SEO

### Pull Request Process

1. Update documentation as needed
2. Follow the commit message format: `type(scope): description`
   - Types: feat, fix, docs, style, refactor, test, chore
   - Example: `feat(router): add support for query parameters`
3. Create a pull request with a clear title and description
4. Wait for CI checks to pass
5. Address any feedback from maintainers

### Testing

Before submitting a pull request, ensure:

1. HTML is valid
2. CSS passes stylelint checks
3. JavaScript passes ESLint checks
4. The site works across major browsers (Chrome, Firefox, Safari, Edge)
5. The site is responsive on mobile devices
6. No console errors appear in the browser

## Adding a New Site

To add a new site to the platform:

1. Duplicate the `sites/template` directory
2. Update the site content
3. Add the site to the router configuration in `common/js/site-router.js`
4. Update the site card on the main landing page
5. Add the site to `sitemap.xml`

## Documentation

Update documentation for any changes, including:

- README.md for user-facing documentation
- Inline code comments for implementation details
- JSDoc for JavaScript functions

## Licensing

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).

## Questions?

If you have questions or need clarification, feel free to open an issue for discussion.

Thank you for contributing!