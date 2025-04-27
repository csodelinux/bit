function openTab(event, tabId) {
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.classList.remove('active');
    });
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => {
        button.classList.remove('active');
    });
    document.getElementById(tabId).classList.add('active');
    event.currentTarget.classList.add('active');
}

function copyToClipboard(buttonElement) {
    const preElement = buttonElement.parentElement.querySelector('pre');
    
    const textarea = document.createElement('textarea');
    textarea.value = preElement.textContent;
    document.body.appendChild(textarea);
    
    textarea.select();
    document.execCommand('copy');
    
    document.body.removeChild(textarea);
    
    const originalIcon = buttonElement.innerHTML;
    buttonElement.innerHTML = '<i class="fas fa-check"></i>';
    
    setTimeout(() => {
        buttonElement.innerHTML = originalIcon;
    }, 1500);
}

function arrangeExamplesVertically() {
    const examplesContainer = document.querySelector('.examples-container');
    
    if (examplesContainer) {
        examplesContainer.classList.add('vertical-layout');
        
        const examples = examplesContainer.querySelectorAll('.example');
        
        examples.forEach(example => {
            example.style.width = '100%';
            example.style.marginBottom = '20px';
        });
    }
}

document.addEventListener('DOMContentLoaded', function() {
    arrangeExamplesVertically();
    
    const navLinks = document.querySelectorAll('nav a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80, // Offset for header
                    behavior: 'smooth'
                });
            }
        });
    });
    
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
    
    const activeTabs = document.querySelectorAll('.tab-button.active');
    if (activeTabs.length === 0) {
        const firstTab = document.querySelector('.tab-button');
        if (firstTab) {
            firstTab.click();
        }
    }
});

document.addEventListener('DOMContentLoaded', function() {
    function isInViewport(element) {
        const rect = element.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }
    
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
    
    handleScrollAnimations();
    
    window.addEventListener('scroll', handleScrollAnimations);
});

document.addEventListener('DOMContentLoaded', function() {
    const sections = document.querySelectorAll('section[id]');
    
    function highlightNavOnScroll() {
        let scrollPosition = window.scrollY;
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            const sectionHeight = section.offsetHeight;
            const sectionId = section.getAttribute('id');
            
            if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                document.querySelectorAll('nav a').forEach(navItem => {
                    navItem.classList.remove('active');
                });
                
                const correspondingNavItem = document.querySelector(`nav a[href="#${sectionId}"]`);
                if (correspondingNavItem) {
                    correspondingNavItem.classList.add('active');
                }
            }
        });
    }
    
    window.addEventListener('scroll', highlightNavOnScroll);
});

document.addEventListener('DOMContentLoaded', function() {
    const prefersDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    const savedDarkMode = localStorage.getItem('darkMode');
    
    const darkModeToggle = document.createElement('button');
    darkModeToggle.className = 'dark-mode-toggle';
    darkModeToggle.innerHTML = '<i class="fas fa-moon"></i>';
    document.body.appendChild(darkModeToggle);
    
    if (savedDarkMode === 'true' || (savedDarkMode === null && prefersDarkMode)) {
        document.body.classList.add('dark-mode');
        darkModeToggle.innerHTML = '<i class="fas fa-sun"></i>';
    }
    
    darkModeToggle.addEventListener('click', function() {
        document.body.classList.toggle('dark-mode');
        
        const isDarkMode = document.body.classList.contains('dark-mode');
        localStorage.setItem('darkMode', isDarkMode);
        
        if (isDarkMode) {
            this.innerHTML = '<i class="fas fa-sun"></i>';
        } else {
            this.innerHTML = '<i class="fas fa-moon"></i>';
        }
    });
    
    const backToTopButton = document.createElement('button');
    backToTopButton.className = 'back-to-top';
    backToTopButton.innerHTML = '<i class="fas fa-arrow-up"></i>';
    document.body.appendChild(backToTopButton);
    
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            backToTopButton.classList.add('visible');
        } else {
            backToTopButton.classList.remove('visible');
        }
    });
    
    backToTopButton.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
});
