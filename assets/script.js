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

  // Horizontal Drag to Scroll functionality
  let isDown = false;
  let startX;
  let scrollLeft;

  scrollArea.addEventListener('mousedown', (e) => {
    isDown = true;
    scrollArea.classList.add('active');
    startX = e.pageX - scrollArea.offsetLeft;
    scrollLeft = scrollArea.scrollLeft;
  });
  scrollArea.addEventListener('mouseleave', () => {
    isDown = false;
  });
  scrollArea.addEventListener('mouseup', () => {
    isDown = false;
  });
  scrollArea.addEventListener('mousemove', (e) => {
    if (!isDown) return;
    e.preventDefault();
    const x = e.pageX - scrollArea.offsetLeft;
    const walk = (x - startX) * 2; // scroll-fast
    scrollArea.scrollLeft = scrollLeft - walk;
  });
});
