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

  // --- AJAX CART FUNCTIONALITY ---

  const cartButtons = document.querySelectorAll('.buy-button, .buy-button-hover');
  const cartCountElements = document.querySelectorAll('.cart-count, #cart-count');

  async function updateCartCount() {
    try {
      const response = await fetch('/cart.js');
      const cart = await response.json();
      cartCountElements.forEach(el => {
        el.textContent = `(${cart.item_count})`;
        // Also update any plain text if needed
        if (el.tagName === 'A' || el.parentElement.classList.contains('cart-link')) {
           el.innerHTML = `CART (${cart.item_count})`;
        }
      });
    } catch (e) { console.error('Error updating cart count:', e); }
  }

  async function addItemsToCart(items) {
    try {
      const response = await fetch('/cart/add.js', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ items })
      });
      if (response.ok) {
        await updateCartCount();
        // Optional: Show a "Thank you" or go to cart
        window.location.href = '/cart'; 
      } else {
        alert('Could not add to cart. Please try again.');
      }
    } catch (e) { console.error('Cart add error:', e); }
  }

  // Handle Global "BUY" clicks (from Grids/Carousels)
  document.addEventListener('click', async (e) => {
    const buyBtn = e.target.closest('.buy-button-hover');
    if (buyBtn) {
      e.preventDefault();
      e.stopPropagation();
      const handle = buyBtn.getAttribute('data-handle');
      if (!handle) return;

      buyBtn.textContent = 'ADDING...';
      try {
        const productRes = await fetch(`/products/${handle}.js`);
        const productData = await productRes.json();
        const variantId = productData.variants[0].id;
        await addItemsToCart([{ id: variantId, quantity: 1 }]);
      } catch (err) {
        console.error(err);
        buyBtn.textContent = 'ERROR';
      }
    }
  });

  // Handle Product Page "ADD TO BAG" (with BOGO)
  const mainBuyBtn = document.querySelector('.buy-button');
  if (mainBuyBtn) {
    mainBuyBtn.addEventListener('click', async (e) => {
      e.preventDefault();
      const variantId = mainBuyBtn.getAttribute('data-variant-id');
      const giftRadio = document.querySelector('input[name="free_gift"]:checked');
      
      mainBuyBtn.textContent = 'ADDING TO BAG...';

      let items = [{ id: variantId, quantity: 1 }];

      if (giftRadio) {
        const giftHandle = giftRadio.getAttribute('data-gift-handle');
        try {
          const giftRes = await fetch(`/products/${giftHandle}.js`);
          const giftData = await giftRes.json();
          items.push({ id: giftData.variants[0].id, quantity: 1 });
        } catch (err) { console.error('Gift add error:', err); }
      }

      await addItemsToCart(items);
    });
  }
});
