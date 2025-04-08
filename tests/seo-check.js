/**
 * Simple SEO validation script
 * 
 * This script would normally be run with a tool like Lighthouse,
 * but this is a placeholder for demonstration purposes.
 */

const fs = require('fs');
const path = require('path');

// Validate robots.txt
function validateRobotsTxt() {
  try {
    const robotsPath = path.join(__dirname, '..', 'robots.txt');
    const robotsContent = fs.readFileSync(robotsPath, 'utf8');
    
    console.log('✅ robots.txt exists');
    
    if (robotsContent.includes('Sitemap:')) {
      console.log('✅ robots.txt contains Sitemap reference');
    } else {
      console.log('❌ robots.txt is missing Sitemap reference');
    }
  } catch (error) {
    console.log('❌ robots.txt is missing');
  }
}

// Validate sitemap.xml
function validateSitemap() {
  try {
    const sitemapPath = path.join(__dirname, '..', 'sitemap.xml');
    const sitemapContent = fs.readFileSync(sitemapPath, 'utf8');
    
    console.log('✅ sitemap.xml exists');
    
    if (sitemapContent.includes('<urlset')) {
      console.log('✅ sitemap.xml has valid format');
    } else {
      console.log('❌ sitemap.xml format is invalid');
    }
  } catch (error) {
    console.log('❌ sitemap.xml is missing');
  }
}

// Validate main index.html
function validateMainIndexHtml() {
  try {
    const indexPath = path.join(__dirname, '..', 'index.html');
    const indexContent = fs.readFileSync(indexPath, 'utf8');
    
    console.log('✅ index.html exists');
    
    if (indexContent.includes('<title>')) {
      console.log('✅ index.html has title tag');
    } else {
      console.log('❌ index.html is missing title tag');
    }
    
    if (indexContent.includes('<meta name="viewport"')) {
      console.log('✅ index.html has viewport meta tag');
    } else {
      console.log('❌ index.html is missing viewport meta tag');
    }
  } catch (error) {
    console.log('❌ index.html is missing');
  }
}

// Run validations
validateRobotsTxt();
validateSitemap();
validateMainIndexHtml();

console.log('\nNote: This is a simple check. For thorough SEO testing, use Lighthouse or similar tools.');