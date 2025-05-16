document.addEventListener('DOMContentLoaded', function() {
    // Initialize Feather icons
    feather.replace();
    
    // Initialize slideshow
    initializeSlideshow();
    
    // Initialize tabs
    initializeTabs();
});

// Declare feather variable
const feather = window.feather;

function initializeSlideshow() {
    const slidesWrapper = document.querySelector('.slides-wrapper');
    const slides = document.querySelectorAll('.slide');
    const indicators = document.querySelectorAll('.indicator');
    const prevBtn = document.querySelector('.slideshow-nav.prev');
    const nextBtn = document.querySelector('.slideshow-nav.next');
    
    if (!slidesWrapper || slides.length === 0) return;
    
    let currentSlide = 0;
    const slideWidth = slides[0].offsetWidth;
    const totalSlides = slides.length;
    
    // Set initial position
    updateSlidePosition();
    
    // Add click handlers for navigation
    prevBtn?.addEventListener('click', () => {
        currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
        updateSlidePosition();
        updateIndicators();
    });
    
    nextBtn?.addEventListener('click', () => {
        currentSlide = (currentSlide + 1) % totalSlides;
        updateSlidePosition();
        updateIndicators();
    });
    
    // Add click handlers for indicators
    indicators.forEach((indicator, index) => {
        indicator.addEventListener('click', () => {
            currentSlide = index;
            updateSlidePosition();
            updateIndicators();
        });
    });
    
    // Auto-advance slides
    setInterval(() => {
        currentSlide = (currentSlide + 1) % totalSlides;
        updateSlidePosition();
        updateIndicators();
    }, 5000);
    
    function updateSlidePosition() {
        slidesWrapper.style.transform = `translateX(-${currentSlide * slideWidth}px)`;
    }
    
    function updateIndicators() {
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === currentSlide);
        });
    }
}

function initializeTabs() {
    const tabTriggers = document.querySelectorAll('.tab-trigger');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabTriggers.forEach(trigger => {
        trigger.addEventListener('click', () => {
            // Remove active class from all triggers and contents
            tabTriggers.forEach(t => t.classList.remove('active'));
            tabContents.forEach(c => c.classList.remove('active'));
            
            // Add active class to clicked trigger
            trigger.classList.add('active');
            
            // Show corresponding content
            const tabId = trigger.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');
        });
    });
}