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

  // Handle Product Page "ADD TO BAG" (Standard Add to Cart)
  const mainBuyBtn = document.querySelector('.add-to-cart-btn');
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
  // --- CATEGORY FILTERING (Event Delegation to handle Shopify navigation override) ---
  document.addEventListener('click', (e) => {
    const link = e.target.closest('.cat-link');
    if (!link) return;

    const category = link.getAttribute('data-category');
    if (!category || category === '#') return;

    e.preventDefault(); // Stop navigation to collection page

    // Reset all links
    document.querySelectorAll('.cat-link').forEach(l => l.classList.remove('active'));
    // Set active on all matching links (sync mobile and desktop)
    document.querySelectorAll(`.cat-link[data-category="${category}"]`).forEach(l => l.classList.add('active'));

    // Filter both homepage cards and mobile menu rows
    const cards = document.querySelectorAll('.card-rhode, .menu-product-row');
    const sanitize = (str) => str.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
    const targetCat = sanitize(category);

    cards.forEach(card => {
      const cardCatStr = (card.getAttribute('data-category') || '').toLowerCase();
      let matches = false;
      
      if (targetCat === 'featured') {
        if (!cardCatStr.includes('set')) {
          matches = true;
        }
      } else if (targetCat === 'set') {
        if (cardCatStr.includes('set')) {
          matches = true;
        }
      } else {
        // Word-based matching for robustness
        const targetWords = targetCat.split('-').filter(w => w.length > 3);
        matches = targetWords.length > 0 ? targetWords.some(word => cardCatStr.includes(word)) : cardCatStr.includes(targetCat);
        
        // Hardcoded reliable mapping for Korean Glass Skin
        if (targetCat.includes('glass')) {
          const glassTags = ['nightcream', 'serum', 'moisturizer', 'cleanser', 'facewash', 'sunscreen'];
          if (glassTags.some(tag => cardCatStr.includes(tag))) {
            const cardName = (card.querySelector('.card-name, .mini-title')?.textContent || '').toLowerCase();
            if (cardName.includes('tranexamic')) {
              matches = false;
            } else {
              matches = true;
            }
          }
        }
        
        // Hardcoded reliable mapping for Korean Brightening
        if (targetCat.includes('brightening')) {
          const brightTags = ['tranexamic', 'glutathione', 'toner', 'antiacne', 'anti-acne', 'brightening', 'repair', 'serum'];
          if (brightTags.some(tag => cardCatStr.includes(tag))) {
            const cardName = (card.querySelector('.card-name, .mini-title')?.textContent || '').toLowerCase();
            if (cardCatStr.includes('serum') || cardCatStr.includes('repair')) {
               if (cardName.includes('tranexamic') || cardName.includes('brightening') || cardName.includes('acne') || cardName.includes('glutathione')) {
                 matches = true;
               } else {
                 matches = false;
               }
            } else {
               matches = true;
            }
          }
        }
      }

      if (matches || cardCatStr.includes(targetCat)) {
        card.style.display = 'flex';
      } else {
        card.style.display = 'none';
      }
    });

    // Reset carousel position
    const slider = document.getElementById('product-slider') || document.getElementById('product-collection-scroll') || document.querySelector('.product-collection');
    if (slider) slider.scrollLeft = 0;

    // Mobile Menu specific handling (Removed automatic close for categories)
    if (link.closest('#mobile-menu')) {
      // We don't close the menu anymore when a filter is clicked
      // But we do ensure we scroll the menu container to the top so the products are seen
      const menuInner = document.querySelector('.menu-inner');
      if (menuInner) menuInner.scrollTop = 0;
    }
  });


  // Initial Filter on load (Default is Featured)
  const initialFilter = () => {
    const activeLink = document.querySelector('.cat-link.active');
    if (activeLink) {
      const category = activeLink.getAttribute('data-category');
      const cards = document.querySelectorAll('.card-rhode, .menu-product-row');
      if (!category || !cards.length) return;

      const sanitize = (str) => str.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
      const targetCat = sanitize(category);
      cards.forEach(card => {
        const cardCatStr = (card.getAttribute('data-category') || '').toLowerCase();

        if (targetCat === 'featured') {
          if (!cardCatStr.includes('set')) {
            card.style.display = 'flex';
          } else {
            card.style.display = 'none';
          }
        } else if (targetCat === 'set') {
          if (cardCatStr.includes('set')) {
            card.style.display = 'flex';
          } else {
            card.style.display = 'none';
          }
        } else {
          // Word-based matching for robustness
          const targetWords = targetCat.split('-').filter(w => w.length > 3);
          let matches = targetWords.length > 0 ? targetWords.some(word => cardCatStr.includes(word)) : cardCatStr.includes(targetCat);
          
          // Hardcoded reliable mapping for Korean Glass Skin
          if (targetCat.includes('glass')) {
            const glassTags = ['nightcream', 'serum', 'moisturizer', 'cleanser', 'facewash', 'sunscreen'];
            if (glassTags.some(tag => cardCatStr.includes(tag))) {
              const cardName = (card.querySelector('.card-name')?.textContent || '').toLowerCase();
              // EXCLUDE Tranexamic from Glass Skin
              if (cardName.includes('tranexamic')) {
                matches = false;
              } else {
                matches = true;
              }
            }
          }
          
          // Hardcoded reliable mapping for Korean Brightening
          if (targetCat.includes('brightening')) {
            const brightTags = ['tranexamic', 'glutathione', 'toner', 'antiacne', 'anti-acne', 'brightening', 'repair', 'serum'];
            if (brightTags.some(tag => cardCatStr.includes(tag))) {
              const cardName = (card.querySelector('.card-name')?.textContent || '').toLowerCase();
              if (cardCatStr.includes('serum') || cardCatStr.includes('repair')) {
                 if (cardName.includes('tranexamic') || cardName.includes('brightening') || cardName.includes('acne') || cardName.includes('glutathione')) {
                   matches = true;
                 } else {
                   matches = false;
                 }
              } else {
                 matches = true;
              }
            }
          }
          
          if (matches || cardCatStr.includes(targetCat)) {
            card.style.display = 'flex';
          } else {
            card.style.display = 'none';
          }
        }
      });
    }
  };

  initialFilter();
});
