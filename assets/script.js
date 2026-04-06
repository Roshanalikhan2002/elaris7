document.addEventListener('DOMContentLoaded', () => {
  const scrollArea = document.querySelector('.product-collection');
  const header = document.querySelector('.site-header');

  if (!scrollArea || !header) return;

  // Header Scroll Functionality (Rhode-style Reveal)
  let lastScrollY = window.scrollY;
  let scrollThreshold = 100;

  window.addEventListener('scroll', () => {
    let currentScrollY = window.scrollY;

    // Background toggle at top
    if (currentScrollY > 100) {
      header.classList.add('scrolled-bg');
    } else {
      header.classList.remove('scrolled-bg');
    }

    // Show/Hide logic
    if (currentScrollY > lastScrollY && currentScrollY > scrollThreshold) {
      // Scrolling DOWN
      header.classList.add('header-hidden');
    } else if (currentScrollY < lastScrollY) {
      // Scrolling UP
      header.classList.remove('header-hidden');
    }
    
    lastScrollY = currentScrollY;
  });

  // Mobile Menu Toggle
  const menuTrigger = document.getElementById('menu-open');
  const menuClose = document.getElementById('menu-close');
  const mobileMenu = document.getElementById('mobile-menu');

  if (menuTrigger && menuClose && mobileMenu) {
    menuTrigger.addEventListener('click', () => {
      mobileMenu.classList.add('open');
      document.body.style.overflow = 'hidden'; // prevent scroll behind
    });

    menuClose.addEventListener('click', () => {
      mobileMenu.classList.remove('open');
      document.body.style.overflow = '';
    });
  }

  // Horizontal Drag to Scroll functionality (with click protection)
  let isDown = false;
  let startX;
  let scrollLeft;
  let hasMoved = false;

  scrollArea.addEventListener('mousedown', (e) => {
    isDown = true;
    hasMoved = false;
    scrollArea.classList.add('active');
    startX = e.pageX - scrollArea.offsetLeft;
    scrollLeft = scrollArea.scrollLeft;
  });

  scrollArea.addEventListener('mouseleave', () => {
    isDown = false;
    scrollArea.classList.remove('active');
  });

  scrollArea.addEventListener('mouseup', (e) => {
    isDown = false;
    scrollArea.classList.remove('active');
  });

  scrollArea.addEventListener('mousemove', (e) => {
    if (!isDown) return;
    const x = e.pageX - scrollArea.offsetLeft;
    const walk = (x - startX) * 2;
    
    // If we move more than 5px, it's a drag, not a click
    if (Math.abs(x - startX) > 5) {
      hasMoved = true;
      e.preventDefault(); // prevent link clicking during drag
    }
    
    scrollArea.scrollLeft = scrollLeft - walk;
  });

  // Prevent link click if we were dragging
  scrollArea.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', (e) => {
      if (hasMoved) {
        e.preventDefault();
      }
    });
  });

  // Product Scroll Arrow Buttons
  const nextBtn = document.getElementById('scroll-next');
  const prevBtn = document.getElementById('scroll-prev');

  if (nextBtn && prevBtn && scrollArea) {
    nextBtn.addEventListener('click', () => {
      const cardWidth = scrollArea.querySelector('.card-rhode').offsetWidth;
      scrollArea.scrollBy({ left: cardWidth + 12, behavior: 'smooth' });
    });

    prevBtn.addEventListener('click', () => {
      const cardWidth = scrollArea.querySelector('.card-rhode').offsetWidth;
      scrollArea.scrollBy({ left: -(cardWidth + 12), behavior: 'smooth' });
    });
  }
});
