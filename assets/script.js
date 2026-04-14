document.addEventListener('DOMContentLoaded', () => {
  const scrollArea = document.getElementById('product-slider') || document.getElementById('product-collection-scroll') || document.querySelector('.product-collection');
  const header = document.querySelector('.site-header');

  // Removed early return to allow header function on all pages move move moved moves move move move move move move move move move move

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
  const menuTrigger = document.getElementById('menu-open') || document.getElementById('menu-toggle');
  const menuClose = document.getElementById('menu-close') || document.getElementById('menu-close-btn');
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

  if (scrollArea) {
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
  }

  // Product Scroll Arrow Buttons
  const nextBtn = document.getElementById('scroll-next') || document.getElementById('scroll-next-btn');
  const prevBtn = document.getElementById('scroll-prev') || document.getElementById('scroll-prev-btn');

  if (nextBtn && prevBtn && scrollArea) {
    nextBtn.addEventListener('click', () => {
      const card = scrollArea.querySelector('.card-rhode');
      if (card) {
        const cardWidth = card.offsetWidth;
        scrollArea.scrollBy({ left: cardWidth + 12, behavior: 'smooth' });
      }
    });

    prevBtn.addEventListener('click', () => {
      const card = scrollArea.querySelector('.card-rhode');
      if (card) {
        const cardWidth = card.offsetWidth;
        scrollArea.scrollBy({ left: -(cardWidth + 12), behavior: 'smooth' });
      }
    });
  }


  // --- AJAX CART FUNCTIONALITY ---

  const cartButtons = document.querySelectorAll('.buy-button, .buy-button-hover');
  const cartCountElements = document.querySelectorAll('.cart-count, #cart-count, .cart-link-desktop');

  async function updateCartCount() {
    try {
      const response = await fetch('/cart.js');
      const cart = await response.json();
      cartCountElements.forEach(el => {
        el.textContent = `(${cart.item_count})`;
        // Also update any plain text if needed
        if (el.tagName === 'A' || el.classList.contains('cart-link-desktop')) {
           el.innerHTML = `CART (${cart.item_count})`;
        }
      });
    } catch (e) { console.error('Error updating cart count:', e); }
  }

  async function addItemsToCart(items) {
    console.log('Adding to cart:', items);
    
    // Using simple object for single item or FormData for multiple
    let bodyData;
    let headers = {};

    if (items.length === 1) {
      bodyData = JSON.stringify({
        id: items[0].id,
        quantity: items[0].quantity
      });
      headers['Content-Type'] = 'application/json';
    } else {
      bodyData = JSON.stringify({ items: items });
      headers['Content-Type'] = 'application/json';
    }

    try {
      const response = await fetch('/cart/add.js', {
        method: 'POST',
        headers: headers,
        body: bodyData
      });
      const data = await response.json();
      
      if (response.ok) {
        await updateCartCount();
        window.location.href = '/cart';
      } else {
        const errorText = data.description || data.message || 'Could not add to cart';
        console.error('Shopify Cart Error Detailed:', data);
        alert(`Shopping Bag Error: ${errorText}\n\n(Status: ${data.status || response.status})`);
      }
    } catch (e) { 
      console.error('Cart add fetch error:', e);
      alert('Network error or checkout is currently unavailable. Please refresh and try again.');
    }
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

  // (Product Page "ADD TO BAG" logic is handled by inline scripts in each template for BOGO accuracy)


  // Handle "Quick Add" buttons (Split Promos / Grid Overlays)
  document.addEventListener('click', async (e) => {
    const quickBtn = e.target.closest('.quick-add-btn');
    if (quickBtn) {
      e.preventDefault();
      e.stopPropagation();
      const variantId = quickBtn.getAttribute('data-variant-id');
      if (!variantId) return;

      const originalText = quickBtn.innerHTML;
      quickBtn.innerHTML = 'ADDING...';
      
      try {
        await addItemsToCart([{ id: variantId, quantity: 1 }]);
      } catch (err) {
        console.error(err);
        quickBtn.innerHTML = 'ERROR';
        setTimeout(() => { quickBtn.innerHTML = originalText; }, 2000);
      }
    }
  });
  // --- MASTER FILTERING FUNCTION ---
  function applyFilter(targetCat, scrollReset = true) {
    if (!targetCat) return;
    const sanitize = (str) => str.toString().trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
    const cleanTarget = sanitize(targetCat);

    console.log('Applying filter for:', cleanTarget);

    // 1. Sync active state across all matching filters
    document.querySelectorAll('.cat-link, .mega-cat-item').forEach(l => {
        const lCat = sanitize(l.getAttribute('data-category') || l.textContent.trim());
        if (lCat === cleanTarget) {
            l.classList.add('active');
        } else {
            l.classList.remove('active');
        }
    });

    // 2. Filter Homepage Cards and Mobile Menu Rows
    const filterableItems = document.querySelectorAll('.card-rhode, .menu-product-row');
    filterableItems.forEach(item => {
      const itemCatStr = (item.getAttribute('data-category') || '').toLowerCase();
      let matches = false;
      
      if (cleanTarget === 'featured') {
        const itemTitle = (item.querySelector('.card-name, .mini-title')?.textContent || '').toLowerCase();
        matches = !itemCatStr.includes('set') && !itemCatStr.includes('bundle') && 
                  !itemTitle.includes('oil to foam') && 
                  !itemTitle.includes('skin refining') && 
                  !itemTitle.includes('hair regrow');
      } else if (cleanTarget === 'set' || cleanTarget === 'sets' || cleanTarget === 'bundles') {
        matches = itemCatStr.includes('set') || itemCatStr.includes('bundle');
      } else {
        const itemTitle = (item.querySelector('.card-name, .mini-title')?.textContent || '').toLowerCase();
        const tags = itemCatStr.split(/\s+/);
        
        // 1. Direct tag match
        matches = tags.some(tag => tag === cleanTarget || tag.includes(cleanTarget));

        // 2. Title-based Keyword matching (Highly Reliable)
        if (cleanTarget.includes('glass')) {
           if (itemTitle.includes('centella') || itemTitle.includes('night cream') || itemTitle.includes('sunscreen') || itemTitle.includes('cleanser') || itemTitle.includes('toner') || itemTitle.includes('moisturizer') || itemTitle.includes('face wash')) {
              if (!itemTitle.includes('tranexamic') && !itemTitle.includes('gel') && !itemTitle.includes('renewal')) matches = true;
           }
        }
        if (cleanTarget.includes('brightening')) {
           const isExcluded = itemTitle.includes('skin refining') || itemTitle.includes('anti frizz') || itemTitle.includes('centella');
           if (!isExcluded) {
              if (itemTitle.includes('tranexamic') || itemTitle.includes('glutathione') || itemTitle.includes('toner') || itemTitle.includes('serum') || itemTitle.includes('brightening') || itemTitle.includes('renewal')) {
                 matches = true;
              }
           }
        }
        if (cleanTarget.includes('acne')) {
           if (itemTitle.includes('acne')) matches = true;
        }
        if (cleanTarget.includes('hair')) {
           if (itemTitle.includes('hair') || itemTitle.includes('keratin') || itemTitle.includes('mist')) matches = true;
        }
      }


      if (matches) {
        item.style.setProperty('display', 'flex', 'important');
      } else {
        item.style.setProperty('display', 'none', 'important');
      }
    });

    // 3. Optional Scroll Reset
    if (scrollReset) {
      if (scrollArea) scrollArea.scrollLeft = 0;
      const menuScroll = document.querySelector('.menu-scroll-area');
      if (menuScroll) menuScroll.scrollTop = 0;
    }
  }

  // Click Handler for Filters
  document.addEventListener('click', (e) => {
    const link = e.target.closest('.cat-link, .mega-cat-item');
    if (!link) return;

    const category = link.getAttribute('data-category') || link.textContent.trim().toLowerCase().replace(/\s+/g, '-');
    if (!category || category === '#') return;

    // Only prevent default if it's acting as a filter button
    if (link.getAttribute('href') === 'javascript:void(0)' || !link.getAttribute('href')) {
       e.preventDefault();
       applyFilter(category, true);
    }
  });

  // Initial Sync
  setTimeout(() => {
    const activeTab = document.querySelector('.cat-link.active, .mega-cat-item.active');
    if (activeTab) {
       const initialCat = activeTab.getAttribute('data-category') || activeTab.textContent.trim();
       applyFilter(initialCat, false);
    }
  }, 100);


  // --- BACK BUTTON RESET ---
  // Ensuring the "Add to Bag" button resets when navigating back
  window.addEventListener('pageshow', () => {
    const addBtns = document.querySelectorAll('.add-to-cart-btn');
    addBtns.forEach(btn => {
      if (btn.innerHTML.includes('ADDING') || btn.innerHTML.includes('Adding')) {
        window.location.reload();
      }
    });
  });

});
