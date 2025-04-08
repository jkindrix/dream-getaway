document.addEventListener('DOMContentLoaded', function() {
    // Load outline content
    fetch('components/outline.html')
        .then(response => response.text())
        .then(html => {
            document.getElementById('outline-content').innerHTML = html;
        });
        
    // Load content sections
    const contentSections = [
        'components/main-content.html',
        'components/cost-breakdown.html',
        'components/ownership-details.html',
        'components/costs-and-risks.html',
        'components/comparison-and-conclusion.html'
    ];
    
    const contentContainer = document.getElementById('write');
    
    Promise.all(contentSections.map(url => 
        fetch(url)
            .then(response => response.text())
    ))
    .then(sections => {
        contentContainer.innerHTML = sections.join('');
    })
    .catch(error => {
        console.error('Error loading content sections:', error);
    });
});