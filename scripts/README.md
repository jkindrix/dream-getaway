# DNS and GitHub Pages Setup Scripts

This directory contains scripts to verify DNS configuration for GitHub Pages and enable HTTPS.

## Scripts Overview

- **check-dns-status.sh**: Verifies that DNS records are correctly configured and propagated
- **enable-https.sh**: Enables HTTPS enforcement on GitHub Pages once the domain is verified

## Check DNS Status

This script checks if your DNS records are correctly configured for GitHub Pages:

```bash
./check-dns-status.sh
```

**Before running**: Edit the script and replace the `DOMAIN` variable at the top with your domain name.

## Enable HTTPS

This script enables HTTPS enforcement for your GitHub Pages site once the domain is verified and the certificate is provisioned:

```bash
./enable-https.sh
```

**Before running**: Edit the script and replace the repository owner and name variables:

```bash
GITHUB_REPO_OWNER="jkindrix"
GITHUB_REPO_NAME="yesiboughtadomainforthis"
```

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- `dig` command for DNS queries
- `curl` for HTTP requests
- Bash shell

## Workflow

1. Run `setup-namecheap-dns.sh` to configure DNS records
2. Wait for DNS propagation (can take up to 48 hours)
3. Use `check-dns-status.sh` to verify DNS configuration
4. After verification is complete, run `enable-https.sh` to enable HTTPS

## Troubleshooting

If you encounter issues:

1. Verify your Namecheap API credentials and whitelisted IP
2. Check DNS propagation using online tools like dnschecker.org
3. Ensure your GitHub repository has GitHub Pages enabled
4. Check that your custom domain is properly set in repository settings