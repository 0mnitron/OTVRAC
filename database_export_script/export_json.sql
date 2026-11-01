SELECT json_agg(
    json_build_object(
        'id', g.id,
        'title', g.title,
        'publisher', g.publisher,
        'developer', g.developer,
        'genre', g.genre,
        'launch_price_usd', g.launch_price_usd,
        'pegi_rating', g.pegi_rating,
        'game_engine', g.game_engine,
        'multiplayer', g.multiplayer,
        'platforms', (
            SELECT json_agg(
                json_build_object(
                    'name', gp.platform_name,
                    'release_date', gp.release_date,
                    'metacritic_score', gp.metacritic_score
                ) ORDER BY gp.release_date, gp.platform_name
            )
            FROM game_platforms gp
            WHERE gp.game_id = g.id
        )
    ) ORDER BY g.id
)
FROM games g;