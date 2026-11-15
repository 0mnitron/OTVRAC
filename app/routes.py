import os
import csv
import json
import io
from flask import render_template, send_from_directory, abort, request, jsonify, Response
from app import app
from app.models import get_filtered_games

ALLOWED_DOWNLOAD_FILES = {'games.csv', 'games.json'}

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html', title='Home Page')


@app.route('/datatable')
def datatable():
    return render_template('datatable.html', title='Datatable')


@app.route('/download/<filename>')
def download_file(filename):
    if filename not in ALLOWED_DOWNLOAD_FILES:
        abort(404)
    root_dir = os.path.dirname(app.root_path)
    return send_from_directory(root_dir, filename, as_attachment=True)


@app.route('/api/games', methods=['GET'])
def api_games():
    # Read URL query parameters (e.g. /api/games?query=witcher&attribute=title)
    query = request.args.get("query", "").strip()
    attribute = request.args.get("attribute", "all").strip()
    export_format = request.args.get("format", "json").lower()
    as_download = request.args.get("download") == "1"

    # Fetch matching games from database
    data = get_filtered_games(query=query, attribute=attribute)

    # Export filtered data as CSV
    if export_format == 'csv':
        output = io.StringIO()  # (In-memory text buffer; no temp file needed)
        fieldnames = [
            'id', 'title', 'publisher', 'developer', 'genre',
            'launch_price_usd', 'pegi_rating', 'game_engine',
            'multiplayer', 'platform_name', 'release_date', 'metacritic_score'
        ]
        writer = csv.DictWriter(output, fieldnames=fieldnames)
        writer.writeheader()

        for g in data:
            for p in (g.get('platforms') or [{}]):
                writer.writerow({
                    'id': g['id'],
                    'title': g['title'],
                    'publisher': g['publisher'],
                    'developer': g['developer'],
                    'genre': g['genre'],
                    'launch_price_usd': g['launch_price_usd'],
                    'pegi_rating': g['pegi_rating'],
                    'game_engine': g['game_engine'],
                    'multiplayer': g['multiplayer'],
                    'platform_name': p.get('name', ''),
                    'release_date': p.get('release_date', ''),
                    'metacritic_score': p.get('metacritic_score', '')
                })

        return Response(
            output.getvalue(),
            mimetype="text/csv; charset=utf-8",
            # "Content-Disposition: attachment" - browser opens a Save dialog
            headers={"Content-Disposition": "attachment; filename=filtered_games.csv"}
        )

    # Export filtered data as downloadable JSON file
    if as_download:
        return Response(
            json.dumps(data, ensure_ascii=False, indent=2),
            mimetype="application/json; charset=utf-8",
            headers={"Content-Disposition": "attachment; filename=filtered_games.json"}
        )

    # Return JSON for JavaScript fetch()
    return jsonify(data)