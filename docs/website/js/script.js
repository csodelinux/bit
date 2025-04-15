// Tab functionality for documentation
function openTab(event, tabId) {
    // Hide all tab content
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.classList.remove('active');
    });

    // Remove active class from all tab buttons
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => {
        button.classList.remove('active');
    });

    // Show the selected tab content and mark button as active
    document.getElementById(tabId).classList.add('active');
    event.currentTarget.classList.add('active');
}

// Copy to clipboard functionality
function copyToClipboard(buttonElement) {
    // Find the pre element that's a sibling of the button
    const preElement = buttonElement.parentElement.querySelector('pre');
    
    // Create a temporary textarea element to copy from
    const textarea = document.createElement('textarea');
    textarea.value = preElement.textContent;
    document.body.appendChild(textarea);
    
    // Select and copy the text
    textarea.select();
    document.execCommand('copy');
    
    // Remove the temporary textarea
    document.body.removeChild(textarea);
    
    // Show feedback by temporarily changing button icon
    const originalIcon = buttonElement.innerHTML;
    buttonElement.innerHTML = '<i class="fas fa-check"></i>';
    
    // Reset the button after a short delay
    setTimeout(() => {
        buttonElement.innerHTML = originalIcon;
    }, 1500);
}

// Arrange examples vertically
function arrangeExamplesVertically() {
    // Get the examples container
    const examplesContainer = document.querySelector('.examples-container');
    
    if (examplesContainer) {
        // Add a class to the container for vertical styling
        examplesContainer.classList.add('vertical-layout');
        
        // Get all example items
        const examples = examplesContainer.querySelectorAll('.example');
        
        // Apply styles to make them stack vertically
        examples.forEach(example => {
            example.style.width = '100%';
            example.style.marginBottom = '20px';
        });
    }
}

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    // Arrange examples vertically
    arrangeExamplesVertically();
    
    const navLinks = document.querySelectorAll('nav a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Get the target element's ID from the href attribute
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                // Smooth scroll to target
                window.scrollTo({
                    top: targetElement.offsetTop - 80, // Offset for header
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Handle initial tab state based on URL hash
    if (window.location.hash && window.location.hash.includes('documentation')) {
        const tabId = window.location.hash.split('-')[1];
        if (tabId && document.getElementById(tabId)) {
            const tabButton = document.querySelector(`.tab-button[onclick*="${tabId}"]`);
            if (tabButton) {
                const event = new Event('click');
                tabButton.dispatchEvent(event);
            }
        }
    }
    
    // Initialize any tabs if needed
    const activeTabs = document.querySelectorAll('.tab-button.active');
    if (activeTabs.length === 0) {
        const firstTab = document.querySelector('.tab-button');
        if (firstTab) {
            firstTab.click();
        }
    }
});

// Add animation to features section when scrolled into view
document.addEventListener('DOMContentLoaded', function() {
    // Function to check if element is in viewport
    function isInViewport(element) {
        const rect = element.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }
    
    // Function to handle scroll animations
    function handleScrollAnimations() {
        const features = document.querySelectorAll('.feature');
        
        features.forEach(feature => {
            if (isInViewport(feature) && !feature.classList.contains('animated')) {
                feature.classList.add('animated', 'fadeIn');
            }
        });
        
        const sections = document.querySelectorAll('.section');
        sections.forEach(section => {
            if (isInViewport(section) && !section.classList.contains('animated')) {
                section.classList.add('animated', 'fadeIn');
            }
        });
    }
    
    // Run once on load
    handleScrollAnimations();
    
    // Add scroll event listener
    window.addEventListener('scroll', handleScrollAnimations);
});

// Add active state to navigation based on scroll position
document.addEventListener('DOMContentLoaded', function() {
    const sections = document.querySelectorAll('section[id]');
    
    function highlightNavOnScroll() {
        let scrollPosition = window.scrollY;
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            const sectionHeight = section.offsetHeight;
            const sectionId = section.getAttribute('id');
            
            if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                // Remove active class from all nav items
                document.querySelectorAll('nav a').forEach(navItem => {
                    navItem.classList.remove('active');
                });
                
                // Add active class to current nav item
                const correspondingNavItem = document.querySelector(`nav a[href="#${sectionId}"]`);
                if (correspondingNavItem) {
                    correspondingNavItem.classList.add('active');
                }
            }
        });
    }
    
    window.addEventListener('scroll', highlightNavOnScroll);
});