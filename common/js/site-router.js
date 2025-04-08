/**
 * Site Router - Handles redirects based on URL patterns
 * 
 * This allows hosting multiple sites under a single domain
 * with path-based routing.
 */
(function() {
    // Configuration for different sites
    const siteConfig = {
        // Path prefix to site folder mapping
        "costa-adeje": "sites/costa-adeje/index.html",
        // Add more sites here as needed:
        // "another-site": "sites/another-site/index.html",
    };

    // Default site to show if no path matches
    const defaultSite = "costa-adeje";

    function routeToSite() {
        // Get the current path without domain and strip leading slash
        const path = window.location.pathname.replace(/^\/+/, '');
        
        // Extract the first path segment
        const pathSegment = path.split('/')[0];
        
        if (pathSegment && siteConfig[pathSegment]) {
            // If path matches a configured site, load it
            window.location.href = '/' + siteConfig[pathSegment];
        } else if (path === '' || path === 'index.html') {
            // If on root, redirect to default site
            window.location.href = '/' + siteConfig[defaultSite];
        }
        // Otherwise, let the request proceed as normal
    }

    // Run the router when the page loads
    window.addEventListener('DOMContentLoaded', routeToSite);
})();