# Manual DNS Configuration for GitHub Pages with Namecheap

Since API access is restricted, follow these steps to manually configure your Namecheap domain for GitHub Pages.

## Step 1: Login to Namecheap Dashboard

1. Go to [Namecheap.com](https://www.namecheap.com/) and log in to your account
2. Navigate to "Domain List" from the left sidebar
3. Find your domain (`yesiboughtadomainforthis.com`) and click "Manage"

## Step 2: Access Advanced DNS Settings

1. Once on the domain management page, click the "Advanced DNS" tab
2. Look for the "Host Records" section where you'll add your records

## Step 3: Add A Records for GitHub Pages

Add the following four A records:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| A Record | @ | 185.199.108.153 | 30 min |
| A Record | @ | 185.199.109.153 | 30 min |
| A Record | @ | 185.199.110.153 | 30 min |
| A Record | @ | 185.199.111.153 | 30 min |

The `@` symbol in the "Host" field represents the root domain.

## Step 4: Add CNAME Record for www Subdomain

Add a CNAME record for the www subdomain:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| CNAME Record | www | jkindrix.github.io | 30 min |

Replace `jkindrix` with your GitHub username.

## Step 5: (Optional) Add AAAA Records for IPv6

For IPv6 support, add these four AAAA records:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| AAAA Record | @ | 2606:50c0:8000::153 | 30 min |
| AAAA Record | @ | 2606:50c0:8001::153 | 30 min |
| AAAA Record | @ | 2606:50c0:8002::153 | 30 min |
| AAAA Record | @ | 2606:50c0:8003::153 | 30 min |

## Step 6: Save Changes

1. After adding all records, scroll down and click "Save Changes"
2. You'll see a confirmation message if everything was saved correctly

## Step 7: Wait for DNS Propagation

DNS changes typically take 30 minutes to 48 hours to propagate across the internet. Be patient during this time.

## Step 8: Verify DNS Configuration

Use our script to check if DNS is properly configured:

```bash
./scripts/check-dns-status.sh
```

Or use an online tool like [dnschecker.org](https://dnschecker.org/) to verify propagation.

## Step 9: Enable HTTPS in GitHub Repository

Once DNS propagation is complete:

1. Go to your GitHub repository: `https://github.com/jkindrix/yesiboughtadomainforthis`
2. Navigate to "Settings" → "Pages"
3. Under "Custom domain," your domain should be listed and verified
4. Check the "Enforce HTTPS" checkbox

If the "Enforce HTTPS" checkbox is grayed out, it means GitHub is still provisioning your SSL certificate. This can take up to 24 hours after DNS verification.

## Step 10: Test Your Site

After everything is set up, visit your site at:
- `https://yesiboughtadomainforthis.com`
- `https://www.yesiboughtadomainforthis.com`

Both should load your GitHub Pages site securely with HTTPS.

## Troubleshooting

### Domain Not Pointing to GitHub Pages
- Double-check all DNS records are entered correctly
- Verify there are no conflicting records
- Wait longer for DNS propagation (up to 48 hours)

### HTTPS Not Working
- Ensure your domain is verified in GitHub
- Wait for GitHub to provision the certificate (up to 24 hours)
- Check if there are any issues in the GitHub Pages settings