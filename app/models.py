from decimal import Decimal
from sqlalchemy import text
from app import db

# Allowlist of filterable columns on the games table (prevents SQL injection)
GAME_COLUMNS = {
    "id": "g.id",
    "title": "g.title",
    "publisher": "g.publisher",
    "developer": "g.developer",
    "genre": "g.genre",
    "launch_price_usd": "g.launch_price_usd",
    "pegi_rating": "g.pegi_rating",
    "game_engine": "g.game_engine",
    "multiplayer": "g.multiplayer",
}

# Allowlist of filterable columns on the game_platforms table
PLATFORM_COLUMNS = {
    "platform_name": "gp.platform_name",
    "release_date": "gp.release_date",
    "metacritic_score": "gp.metacritic_score",
}


def get_filtered_games(query="", attribute="all"):
    """
    Query PostgreSQL for games with optional text filtering.
    Returns a list of dicts matching the JSON dataset structure.
    """
    sql = """
    SELECT
        g.id,
        g.title,
        g.publisher,
        g.developer,
        g.genre,
        g.launch_price_usd,
        g.pegi_rating,
        g.game_engine,
        g.multiplayer,
        COALESCE(
            (
                SELECT json_agg(
                    json_build_object(
                        'name', gp.platform_name,
                        'release_date', gp.release_date::text,
                        'metacritic_score', gp.metacritic_score
                    ) ORDER BY gp.release_date, gp.platform_name
                )
                FROM game_platforms gp
                WHERE gp.game_id = g.id
            ), '[]'::json
        ) AS platforms
    FROM games g
    """

    where_clauses = []
    params = {}

    if query:
        params["pattern"] = f"%{query}%"

        # Cast non-text columns to TEXT so ILIKE (case-insensitive) works uniformly
        if attribute in GAME_COLUMNS:
            col = GAME_COLUMNS[attribute]
            where_clauses.append(f"CAST({col} AS TEXT) ILIKE :pattern")

        elif attribute in PLATFORM_COLUMNS:
            col = PLATFORM_COLUMNS[attribute]
            where_clauses.append(f"""
                EXISTS (
                    SELECT 1 FROM game_platforms gp
                    WHERE gp.game_id = g.id
                      AND CAST({col} AS TEXT) ILIKE :pattern
                )
            """)

        else:
            # Wildcard search across ALL attributes
            where_clauses.append("""
                (
                    CAST(g.id AS TEXT) ILIKE :pattern OR
                    CAST(g.title AS TEXT) ILIKE :pattern OR
                    CAST(g.publisher AS TEXT) ILIKE :pattern OR
                    CAST(g.developer AS TEXT) ILIKE :pattern OR
                    CAST(g.genre AS TEXT) ILIKE :pattern OR
                    CAST(g.launch_price_usd AS TEXT) ILIKE :pattern OR
                    CAST(g.pegi_rating AS TEXT) ILIKE :pattern OR
                    CAST(g.game_engine AS TEXT) ILIKE :pattern OR
                    CAST(g.multiplayer AS TEXT) ILIKE :pattern OR
                    EXISTS (
                        SELECT 1 FROM game_platforms gp
                        WHERE gp.game_id = g.id AND (
                            CAST(gp.platform_name AS TEXT) ILIKE :pattern OR
                            CAST(gp.release_date AS TEXT) ILIKE :pattern OR
                            CAST(gp.metacritic_score AS TEXT) ILIKE :pattern
                        )
                    )
                )
            """)

    if where_clauses:
        sql += " WHERE " + " AND ".join(where_clauses)

    sql += " ORDER BY g.id;"

    # Execute query and return rows as dict-like mappings
    rows = db.session.execute(text(sql), params).mappings().all()

    results = []
    for row in rows:
        item = dict(row)
        # Convert Decimal to float for JSON serialization
        if isinstance(item.get("launch_price_usd"), Decimal):
            item["launch_price_usd"] = float(item["launch_price_usd"])
        results.append(item)

    return results