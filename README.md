# Digital Marketing Analytics for WatchSports.com

A marketing and product analytics case study for a sports video platform. The project turns raw platform event data into SQL views, cleaned analytical datasets, and a Power BI dashboard for evaluating content performance, channel performance, viewer behavior, and daily platform activity.

## Project Overview

WatchSports.com needed a clearer way to understand how users interacted with sports video content across channels, sessions, and daily activity patterns. This project analyzes viewer behavior and video engagement data to identify performance trends that can support campaign optimization, funnel analysis, and A/B testing decisions.

The workflow combines:

- SQL views for aggregating raw platform tables
- Python EDA and data cleaning with Pandas and NumPy
- Cleaned CSV outputs for dashboarding
- A Power BI dashboard for stakeholder-facing performance analysis

## Business Questions

- Which videos generate the strongest view, impression, and engagement activity?
- Which channels drive the most watch time, viewers, subscribers, and revenue signals?
- How do viewer behavior patterns differ by country, session behavior, return visits, and ad-blocker usage?
- How does platform activity change over time?
- Which engagement metrics can inform campaign optimization and experimentation?

## Repository Contents

```text
.
|-- EDA.ipynb
|-- views.sql
|-- dashboard.pbix
`-- edited_Csvs/
    |-- channel_performance_clean.csv
    |-- platform_activity_clean.csv
    |-- video_performance_clean.csv
    `-- viewer_behavior_clean.csv
```

## Data Outputs

The cleaned CSV files are summary datasets created from SQL exports and prepared for reporting in Power BI.

| File | Rows | What it captures |
| --- | ---: | --- |
| `channel_performance_clean.csv` | 135 | Channel-level videos, watch time, unique viewers, and subscriber counts |
| `viewer_behavior_clean.csv` | 29,638 | Viewer-level views, watch time, engagement counts, sessions, returning sessions, and ad-blocked sessions |
| `video_performance_clean.csv` | 1,189 | Video-level views, impressions, engagements, playback position, and average watch percent |
| `platform_activity_clean.csv` | 114 | Daily unique viewers, total views, total watch time, and total engagements |

## Analysis Workflow

1. Build SQL views

   `views.sql` defines analytical views for:

   - video views
   - video engagements
   - video interactions
   - top video performance
   - channel performance
   - viewer behavior
   - daily platform activity

   These views aggregate source event tables into dashboard-ready outputs.

2. Explore and clean data

   `EDA.ipynb` loads exported CSVs, inspects schema and summary statistics, fills missing values, and writes cleaned datasets.

   Cleaning steps include:

   - filling missing viewer watch time with `0`
   - labeling missing countries as `Unknown`
   - filling missing video metrics such as views, engagements, playback position, and watch percent with `0`

3. Build dashboard

   `dashboard.pbix` uses the cleaned CSVs to visualize campaign and platform performance across content, channels, viewers, and daily trends.

## Key Metrics

- Total views
- Impressions
- Total engagements
- Average playback position
- Average watch percent
- Total watch time
- Unique viewers
- Returning sessions
- Ad-blocked sessions
- Channel subscribers
- Daily platform activity

## Tools Used

- SQL / PostgreSQL-style views
- Python
- Pandas
- NumPy
- Power BI
- DAX-ready dashboard modeling

## How to Use

Clone the repository:

```bash
git clone https://github.com/Sudeeptha21/digital-marketing-analytics-watchsports.git
cd digital-marketing-analytics-watchsports
```

Install the Python analysis dependencies:

```bash
python -m pip install pandas numpy jupyter
```

Open the notebook:

```bash
jupyter notebook EDA.ipynb
```

If you regenerate the cleaned CSVs, update the source file paths in the notebook loading cell so they point to your local SQL export files.

To review the dashboard, open `dashboard.pbix` in Power BI Desktop. If Power BI prompts for source paths, point the data sources to the files in `edited_Csvs/`.

## Outcome

The project creates a reusable analytics workflow for tracking WatchSports.com campaign and content performance. It supports stakeholder decisions around video completion, click-through behavior, content quality, and user engagement by connecting SQL-based metric creation with Python cleaning and Power BI reporting.

The portfolio case study reports that this analysis supported A/B testing and campaign improvements that contributed to a 10 percent lift in video completion and an 8 percent higher click-through rate.

## Notes

- `dashboard.pbix` requires Power BI Desktop.
- `views.sql` should be reviewed against your database object names before rerunning in a new environment.
- The repository does not include a `requirements.txt`; dependencies are listed above for convenience.
- No license file is included. Treat this as portfolio/demo work unless a license is added.
