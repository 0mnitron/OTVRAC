document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('searchInput');
    const attributeSelect = document.getElementById('attributeSelect');
    const tableBody = document.getElementById('tableBody');
    const recordCount = document.getElementById('recordCount');
    const downloadCsv = document.getElementById('downloadCsv');
    const downloadJson = document.getElementById('downloadJson');

    // Fetch filtered games from /api/games and rebuild the HTML table
    async function loadData() {
        const query = searchInput.value.trim();
        const attribute = attributeSelect.value;

        // Build URL query string safely (handles spaces, special chars...)
        const queryParams = `query=${encodeURIComponent(query)}&attribute=${encodeURIComponent(attribute)}`;

        // Keep download buttons synced with the currently active filter
        downloadCsv.href = `/api/games?${queryParams}&format=csv`;
        downloadJson.href = `/api/games?${queryParams}&format=json&download=1`;

        recordCount.textContent = 'Fetching records from database...';

        try {
            // Asynchronous HTTP GET request (no full page reload)
            const res = await fetch(`/api/games?${queryParams}`);
            if (!res.ok) {
                throw new Error(`HTTP ${res.status}`);
            }
            const data = await res.json();

            // Handle empty search results
            if (!data || data.length === 0) {
                tableBody.innerHTML = '<tr><td colspan="10" class="text-center py-4 text-muted">No records found.</td></tr>';
                recordCount.textContent = '0 records found';
                return;
            }

            // Build all table rows as one HTML string, then insert into DOM once
            let rowsHtml = '';
            data.forEach((game) => {
                // Format nested platforms array into readable lines
                const platformsHtml = Array.isArray(game.platforms) && game.platforms.length > 0
                    ? game.platforms.map((p) => {
                        const score = p.metacritic_score ?? 'N/A';
                        return `<div><strong>${p.name}</strong> (${p.release_date || 'N/A'}, Metacritic: ${score})</div>`;
                    }).join('')
                    : '<span class="text-muted">N/A</span>';

                // Format price with 2 decimal places (or N/A if null)
                const price = game.launch_price_usd !== null && game.launch_price_usd !== undefined
                    ? `$${Number(game.launch_price_usd).toFixed(2)}`
                    : 'N/A';

                rowsHtml += `
                    <tr>
                        <td>${game.id}</td>
                        <td class="fw-bold">${game.title}</td>
                        <td>${game.publisher}</td>
                        <td>${game.developer}</td>
                        <td>${game.genre}</td>
                        <td>${game.game_engine || 'N/A'}</td>
                        <td>${price}</td>
                        <td>${game.pegi_rating}</td>
                        <td>${game.multiplayer}</td>
                        <td><small>${platformsHtml}</small></td>
                    </tr>`;
            });

            tableBody.innerHTML = rowsHtml;
            recordCount.textContent = `Showing ${data.length} games`;
        } catch (err) {
            console.error('Fetch error:', err);
            recordCount.textContent = 'Error connecting to database.';
        }
    }

    // Filter form submit - prevent page reload and fetch filtered data
    document.getElementById('filterForm').addEventListener('submit', (e) => {
        e.preventDefault();
        loadData();
    });

    // Reset button - clear inputs and reload all records
    document.getElementById('resetBtn').addEventListener('click', () => {
        searchInput.value = '';
        attributeSelect.value = 'all';
        loadData();
    });

    // Initial load when user first opens /datatable
    loadData();
});