# OTVRAC - Video Games Dataset

This repository contains the open dataset created for the laboratory exercises in the course **Open Computing** (*Otvoreno računarstvo*) at the **Faculty of Electrical Engineering and Computing (FER)**, University of Zagreb.

The dataset consists of 10 popular modern video games, containing their core technical and commercial attributes, along with their platform releases, release dates, and Metacritic scores. 

All data is stored in a normalized PostgreSQL database and automatically exported into machine-readable CSV and JSON formats.

---

## Dataset Metadata

1. **Title:** Video Games Dataset
2. **Author:** Anđelko Kućar
3. **Dataset Version:** 1.0
4. **Publication Date:** 2026-11-01
5. **Dataset Language:** English (en)
6. **License:** Creative Commons Zero v1.0 Universal (CC0 1.0) Public Domain Dedication
7. **License Description:** The dataset is placed in the public domain. Anyone can freely use, modify, share, and build upon this data for any purpose without asking permission.
8. **File Formats:** CSV, JSON, SQL
9. **Character Encoding:** UTF-8
10. **Category / Domain:** Video Games / Entertainment

---

## Data Attribute Descriptions

The dataset contains 12 attributes describing the games and their individual platform releases:

| Attribute Name | Data Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `id` | Integer | Unique identifier for each video game entity (Primary Key). | `1` |
| `title` | String (Text) | Official title of the video game. | `The Witcher 3: Wild Hunt` |
| `publisher` | String (Text) | Company that published the game. | `CD Projekt` |
| `developer` | String (Text) | Studio that developed the game. | `CD Projekt Red` |
| `genre` | String (Text) | Main gameplay genre. | `Action RPG` |
| `launch_price_usd` | Decimal (Numeric) | Launch retail price in USD. | `59.99` |
| `pegi_rating` | Integer | Age rating by PEGI (valid values: 3, 7, 12, 16, 18). | `18` |
| `game_engine` | String (Text) | Engine used to develop the game. | `REDengine 3` |
| `multiplayer` | Boolean | Whether the game has multiplayer (`true` or `false`). | `false` |
| `platform_name` / `name` | String (Text) | Platform the game was released on. | `PC`, `PlayStation 5` |
| `release_date` | Date (ISO-8601) | Release date on that specific platform (`YYYY-MM-DD`). | `2015-05-19` |
| `metacritic_score` | Integer (Nullable)| Metacritic review score (0–100) for that platform. | `93` |
