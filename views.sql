
drop view top_video_performance;
drop view channel_performance;
drop view viewer_behavior;
drop view daily_activity;

CREATE VIEW video_views AS
SELECT video_id, COUNT(*) AS total_views
FROM public.stat_video_views
GROUP BY video_id;

CREATE VIEW video_engagements AS
SELECT video_id, COUNT(DISTINCT id) AS total_engagements,
       ROUND(AVG(playback_position)::NUMERIC, 2) AS avg_playback_position
FROM public.stat_video_engagements
GROUP BY video_id;

CREATE VIEW video_interactions AS
SELECT video_id, COUNT(DISTINCT id) AS impressions
FROM public.stat_video_interactions
GROUP BY video_id;

CREATE MATERIALIZED VIEW public.top_video_performance_materialized AS
SELECT  
    vd.id AS video_id,
    vd.title AS video_title,
    ch.title AS channel_title,
    vv.total_views,
    vint.impressions,
    veng.total_engagements,
    veng.avg_playback_position,
    ROUND((veng.avg_playback_position / NULLIF(vd.duration, 0) * 100)::NUMERIC, 2) AS avg_watch_percent
FROM public.stat_videos vd
LEFT JOIN public.stat_channels ch ON ch.id = vd.channel_id
LEFT JOIN video_views vv ON vv.video_id = vd.id
LEFT JOIN video_engagements veng ON veng.video_id = vd.id
LEFT JOIN video_interactions vint ON vint.video_id = vd.id;




--Top performing videos
CREATE MATERIALIZED VIEW public.top_video_performance_materialized AS
SELECT  
    vd.id AS video_id,
    vd.title AS video_title,
    ch.title AS channel_title,
    COUNT(vv.id) AS total_views,
    COUNT(DISTINCT vint.id) AS impressions,
    COUNT(DISTINCT veng.id) AS total_engagements,
    ROUND(AVG(veng.playback_position)::NUMERIC, 2) AS avg_playback_position,
   ROUND((AVG(veng.playback_position) / NULLIF(vd.duration, 0) * 100)::NUMERIC, 2) AS avg_watch_percent
FROM public.stat_videos vd
LEFT JOIN public.stat_channels ch ON ch.id = vd.channel_id
LEFT JOIN public.stat_video_views vv ON vv.video_id = vd.id
LEFT JOIN public.stat_video_engagements veng ON veng.video_id = vd.id
LEFT JOIN public.stat_video_interactions vint ON vint.video_id = vd.id
GROUP BY vd.id, vd.title, ch.title, vd.duration;

--channel performace
CREATE OR REPLACE VIEW channel_performance AS
SELECT 
    ch.id AS channel_id,
    ch.title AS channel_title,
    COUNT(DISTINCT vd.id) AS total_videos,
    SUM(vv.duration) AS total_watch_time,
    COUNT(DISTINCT vw.id) AS unique_viewers,
    SUM(ch.subscribers_count) AS total_subscribers,
    SUM(ch.revenue) AS channel_revenue
FROM public.stat_channels ch
LEFT JOIN public.stat_videos vd ON ch.id = vd.channel_id
LEFT JOIN public.stat_video_views vv ON vv.video_id = vd.id
LEFT JOIN public.stat_viewers vw ON vw.id = vv.viewer_id
GROUP BY ch.id, ch.title;

-- viewer behavior
CREATE OR REPLACE VIEW viewer_behavior AS
SELECT 
    vw.id AS viewer_id,
    vw.account_name,
    vw.country,
    COUNT(DISTINCT vv.id) AS total_views,
    SUM(vv.duration) AS total_watch_time,
    COUNT(DISTINCT veng.id) AS engagement_count,
    COUNT(DISTINCT sst.id) AS total_sessions,
    COUNT(CASE WHEN sst.returning_user = TRUE THEN 1 END) AS returning_sessions,
    COUNT(CASE WHEN sst.has_ad_blocker = TRUE THEN 1 END) AS ad_blocked_sessions
FROM public.stat_viewers vw
LEFT JOIN public.stat_video_views vv ON vv.viewer_id = vw.id
LEFT JOIN public.stat_video_engagements veng ON veng.view_id = vw.id
LEFT JOIN public.stat_session_trackings sst ON sst.viewer_id = vw.id
GROUP BY vw.id, vw.account_name, vw.country;


-- daily performance
CREATE OR REPLACE VIEW platform_daily_activity AS
SELECT 
    DATE(vv.created_at) AS activity_date,
    COUNT(DISTINCT vv.viewer_id) AS unique_viewers,
    COUNT(vv.id) AS total_views,
    SUM(vv.duration) AS total_watch_time,
    COUNT(DISTINCT veng.id) AS total_engagements
FROM public.stat_video_views vv
LEFT JOIN public.stat_video_engagements veng ON vv.id = veng.view_id
GROUP BY DATE(vv.created_at)
ORDER BY activity_date DESC;

