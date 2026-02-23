// search-ui.js - Auto-inject search functionality into any page
(function() {
    // Only run once
    if (window.searchUIInitialized) return;
    window.searchUIInitialized = true;

    // Find the nav element and add search container
    function initSearch() {
        const nav = document.querySelector('nav');
        if (!nav) return;

        // Check if already has search
        if (nav.querySelector('.search-container')) return;

        // Create search container
        const searchContainer = document.createElement('div');
        searchContainer.className = 'search-container';
        searchContainer.innerHTML = `
            <input type="text" id="search-input" placeholder="Search articles..." autocomplete="off">
            <div id="search-results" class="search-results"></div>
        `;

        nav.appendChild(searchContainer);

        // Load search index and setup handlers
        setupSearch();
    }

    async function setupSearch() {
        let searchIndex = null;

        async function loadSearchIndex() {
            if (!searchIndex) {
                try {
                    const response = await fetch('search-index.json');
                    searchIndex = await response.json();
                } catch (e) {
                    console.warn('Search index not found');
                    return null;
                }
            }
            return searchIndex;
        }

        function performSearch(query, posts) {
            if (!query || query.length < 2) return [];
            const q = query.toLowerCase();
            return posts.filter(post =>
                post.title.toLowerCase().includes(q) ||
                (post.tags && post.tags.some(tag => tag.toLowerCase().includes(q)))
            ).slice(0, 8);
        }

        function showResults(results) {
            const resultsContainer = document.getElementById('search-results');
            if (!resultsContainer) return;

            if (results.length === 0) {
                resultsContainer.innerHTML = '<div class="search-no-results">No results found</div>';
            } else {
                resultsContainer.innerHTML = results.map(post =>
                    '<a href="' + post.url + '" class="search-result-item">' +
                    '<span class="search-result-title">' + post.title + '</span>' +
                    '</a>'
                ).join('');
            }
            resultsContainer.classList.add('show');
        }

        function hideResults() {
            const resultsContainer = document.getElementById('search-results');
            if (resultsContainer) {
                resultsContainer.classList.remove('show');
            }
        }

        const searchInput = document.getElementById('search-input');
        const resultsContainer = document.getElementById('search-results');

        if (!searchInput) return;

        // Load search index
        const data = await loadSearchIndex();
        if (!data) return;

        searchInput.addEventListener('input', function(e) {
            const query = e.target.value.trim();
            if (query.length >= 2) {
                const results = performSearch(query, data.posts);
                showResults(results);
            } else {
                hideResults();
            }
        });

        searchInput.addEventListener('focus', function() {
            if (searchInput.value.trim().length >= 2) {
                const results = performSearch(searchInput.value.trim(), data.posts);
                showResults(results);
            }
        });

        // Close results when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.search-container')) {
                hideResults();
            }
        });

        // Keyboard navigation
        searchInput.addEventListener('keydown', function(e) {
            if (!resultsContainer) return;
            const results = resultsContainer.querySelectorAll('.search-result-item');
            if (results.length === 0) return;

            let activeIndex = -1;
            results.forEach((r, i) => {
                if (r.classList.contains('active')) activeIndex = i;
            });

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                if (activeIndex < results.length - 1) {
                    if (activeIndex >= 0) results[activeIndex].classList.remove('active');
                    results[activeIndex + 1].classList.add('active');
                }
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                if (activeIndex > 0) {
                    results[activeIndex].classList.remove('active');
                    results[activeIndex - 1].classList.add('active');
                }
            } else if (e.key === 'Enter') {
                if (activeIndex >= 0) {
                    results[activeIndex].click();
                }
            } else if (e.key === 'Escape') {
                hideResults();
                searchInput.blur();
            }
        });
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSearch);
    } else {
        initSearch();
    }
})();